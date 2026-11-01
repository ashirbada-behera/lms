package org.example.lms.dao;

import org.example.lms.config.DBConnection;
import org.example.lms.model.IssueRecord;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    private static final BigDecimal FINE_PER_DAY =
            new BigDecimal("5.00");

    private static final long FREE_OVERDUE_DAYS = 3;

    public Long issueBook(
            Long memberId,
            Long bookId,
            LocalDate issueDate,
            LocalDate dueDate) throws SQLException {

        if (memberId == null || bookId == null
                || issueDate == null || dueDate == null) {
            throw new IllegalArgumentException("All issue details are required.");
        }

        if (dueDate.isBefore(issueDate)) {
            throw new IllegalArgumentException(
                    "Due date cannot be before issue date.");
        }

        String stockSql = """
                SELECT available_copies
                FROM books
                WHERE id = ?
                FOR UPDATE
                """;

        String updateStockSql = """
                UPDATE books
                SET available_copies = available_copies - 1
                WHERE id = ? AND available_copies > 0
                """;

        String insertSql = """
                INSERT INTO issue_records
                    (member_id, book_id, issue_date, due_date, status, fine)
                VALUES (?, ?, ?, ?, 'ISSUED', 0.00)
                """;

        try (Connection con = DBConnection.getConnection()) {

            boolean originalAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);

            try {
                try (PreparedStatement ps =
                             con.prepareStatement(stockSql)) {

                    ps.setLong(1, bookId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException("Book not found.");
                        }

                        if (rs.getInt("available_copies") <= 0) {
                            throw new SQLException(
                                    "No copies of this book are available.");
                        }
                    }
                }

                try (PreparedStatement ps =
                             con.prepareStatement(updateStockSql)) {

                    ps.setLong(1, bookId);

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Unable to update book stock.");
                    }
                }

                Long issueId;

                try (PreparedStatement ps = con.prepareStatement(
                        insertSql, Statement.RETURN_GENERATED_KEYS)) {

                    ps.setLong(1, memberId);
                    ps.setLong(2, bookId);
                    ps.setDate(3, Date.valueOf(issueDate));
                    ps.setDate(4, Date.valueOf(dueDate));

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Unable to create issue record.");
                    }

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException(
                                    "Issue ID was not generated.");
                        }

                        issueId = keys.getLong(1);
                    }
                }

                con.commit();
                return issueId;

            } catch (SQLException | RuntimeException exception) {
                con.rollback();
                throw exception;
            } finally {
                con.setAutoCommit(originalAutoCommit);
            }
        }
    }

    public List<IssueRecord> findActiveIssuesByMemberCode(
            String memberCode) throws SQLException {

        String sql = """
                SELECT ir.issue_id, ir.member_id, ir.book_id,
                       ir.issue_date, ir.due_date, ir.return_date,
                       ir.status, ir.fine
                FROM issue_records ir
                INNER JOIN members m ON ir.member_id = m.id
                WHERE m.member_code = ?
                  AND ir.status = 'ISSUED'
                ORDER BY ir.due_date
                """;

        List<IssueRecord> issues = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, memberCode.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    issues.add(mapIssue(rs));
                }
            }
        }

        return issues;
    }

    public BigDecimal returnBook(
            Long issueId,
            Long memberId) throws SQLException {

        if (issueId == null || memberId == null) {
            throw new IllegalArgumentException(
                    "Issue ID and member ID are required.");
        }

        String findSql = """
                SELECT book_id, due_date
                FROM issue_records
                WHERE issue_id = ?
                  AND member_id = ?
                  AND status = 'ISSUED'
                FOR UPDATE
                """;

        String returnSql = """
                UPDATE issue_records
                SET status = 'RETURNED',
                    return_date = ?,
                    fine = ?
                WHERE issue_id = ?
                  AND member_id = ?
                  AND status = 'ISSUED'
                """;

        String stockSql = """
                UPDATE books
                SET available_copies = available_copies + 1
                WHERE id = ?
                  AND available_copies < total_copies
                """;

        try (Connection con = DBConnection.getConnection()) {

            boolean originalAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);

            try {
                Long bookId;
                LocalDate dueDate;

                try (PreparedStatement ps = con.prepareStatement(findSql)) {
                    ps.setLong(1, issueId);
                    ps.setLong(2, memberId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException(
                                    "Active issue not found for this member.");
                        }

                        bookId = rs.getLong("book_id");
                        dueDate = rs.getDate("due_date").toLocalDate();
                    }
                }

                LocalDate returnDate = LocalDate.now();
                BigDecimal fine = calculateFine(dueDate, returnDate);

                try (PreparedStatement ps = con.prepareStatement(returnSql)) {
                    ps.setDate(1, Date.valueOf(returnDate));
                    ps.setBigDecimal(2, fine);
                    ps.setLong(3, issueId);
                    ps.setLong(4, memberId);

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Unable to update return record.");
                    }
                }

                try (PreparedStatement ps = con.prepareStatement(stockSql)) {
                    ps.setLong(1, bookId);

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                                "Unable to restore book stock.");
                    }
                }

                con.commit();
                return fine;

            } catch (SQLException | RuntimeException exception) {
                con.rollback();
                throw exception;
            } finally {
                con.setAutoCommit(originalAutoCommit);
            }
        }
    }

    public static BigDecimal calculateFine(
            LocalDate dueDate,
            LocalDate returnDate) {

        if (dueDate == null || returnDate == null) {
            throw new IllegalArgumentException(
                    "Due date and return date are required.");
        }

        long overdueDays = Math.max(
                0,
                ChronoUnit.DAYS.between(dueDate, returnDate)
        );

        long chargeableDays = Math.max(
                0,
                overdueDays - FREE_OVERDUE_DAYS
        );

        return FINE_PER_DAY.multiply(
                BigDecimal.valueOf(chargeableDays)
        );
    }

    private IssueRecord mapIssue(ResultSet rs) throws SQLException {

        IssueRecord issue = new IssueRecord();

        issue.setIssueId(rs.getLong("issue_id"));
        issue.setMemberId(rs.getLong("member_id"));
        issue.setBookId(rs.getLong("book_id"));
        issue.setIssueDate(rs.getDate("issue_date").toLocalDate());
        issue.setDueDate(rs.getDate("due_date").toLocalDate());

        Date returnDate = rs.getDate("return_date");
        issue.setReturnDate(
                returnDate == null ? null : returnDate.toLocalDate()
        );

        issue.setStatus(rs.getString("status"));
        issue.setFine(rs.getBigDecimal("fine"));

        return issue;
    }
}