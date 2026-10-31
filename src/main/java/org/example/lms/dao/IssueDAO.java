
package org.example.lms.dao;

import org.example.lms.model.IssueRecord;
import org.example.lms.model.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    // Check whether a book is already issued
    public boolean isBookAlreadyIssued(int bookId) throws SQLException {

        String sql = "SELECT issue_id FROM issue_records " +
                "WHERE book_id = ? AND status = 'ISSUED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement psmt = con.prepareStatement(sql)) {

            psmt.setInt(1, bookId);

            try (ResultSet rs = psmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Add a new issue record and return its generated Issue ID
    public int addIssue(IssueRecord issue) {

        String checkSql = "SELECT issue_id FROM issue_records " +
                "WHERE book_id = ? AND status = 'ISSUED'";

        String insertSql = "INSERT INTO issue_records " +
                "(member_id, book_id, issue_date, due_date, return_date, status, fine) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {

            // Prevent duplicate active issues
            try (PreparedStatement checkStmt = con.prepareStatement(checkSql)) {
                checkStmt.setInt(1, issue.getBookId());

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        return 0;
                    }
                }
            }

            // Insert issue and retrieve generated ID
            try (PreparedStatement psmt = con.prepareStatement(
                    insertSql, Statement.RETURN_GENERATED_KEYS)) {

                psmt.setInt(1, issue.getMemberId());
                psmt.setInt(2, issue.getBookId());
                psmt.setDate(3, java.sql.Date.valueOf(issue.getIssueDate()));
                psmt.setDate(4, java.sql.Date.valueOf(issue.getDueDate()));

                if (issue.getReturnDate() == null) {
                    psmt.setNull(5, Types.DATE);
                } else {
                    psmt.setDate(5, java.sql.Date.valueOf(issue.getReturnDate()));
                }

                psmt.setString(6, issue.getStatus());
                psmt.setDouble(7, issue.getFine());

                int rowsInserted = psmt.executeUpdate();

                if (rowsInserted > 0) {
                    try (ResultSet keys = psmt.getGeneratedKeys()) {
                        if (keys.next()) {
                            return keys.getInt(1);
                        }
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Find all currently issued books belonging to a member
    public List<IssueRecord> getIssuedBooksByRegistrationNumber(
            String registrationNumber) {

        List<IssueRecord> issuedBooks = new ArrayList<>();

        String sql = "SELECT ir.issue_id, ir.member_id, ir.book_id, " +
                "ir.issue_date, ir.due_date, ir.return_date, ir.status, ir.fine " +
                "FROM issue_records ir " +
                "JOIN members m ON ir.member_id = m.member_id " +
                "WHERE m.registration_number = ? AND ir.status = 'ISSUED' " +
                "ORDER BY ir.issue_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement psmt = con.prepareStatement(sql)) {

            psmt.setString(1, registrationNumber);

            try (ResultSet rs = psmt.executeQuery()) {

                while (rs.next()) {

                    IssueRecord issue = new IssueRecord();

                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setMemberId(rs.getInt("member_id"));
                    issue.setBookId(rs.getInt("book_id"));
                    issue.setIssueDate(rs.getDate("issue_date").toLocalDate());
                    issue.setDueDate(rs.getDate("due_date").toLocalDate());

                    java.sql.Date returnDate = rs.getDate("return_date");

                    if (returnDate != null) {
                        issue.setReturnDate(returnDate.toLocalDate());
                    }

                    issue.setStatus(rs.getString("status"));
                    issue.setFine(rs.getDouble("fine"));

                    issuedBooks.add(issue);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return issuedBooks;
    }

    // Return a book and calculate its fine
    public boolean returnBook(int issueId) {

        LocalDate returnDate = LocalDate.now();

        String selectSql = "SELECT issue_date FROM issue_records " +
                "WHERE issue_id = ? AND status = 'ISSUED'";

        String updateSql = "UPDATE issue_records " +
                "SET return_date = ?, status = 'RETURNED', fine = ? " +
                "WHERE issue_id = ? AND status = 'ISSUED'";

        try (Connection con = DBConnection.getConnection()) {

            LocalDate issueDate;

            try (PreparedStatement psmt = con.prepareStatement(selectSql)) {
                psmt.setInt(1, issueId);

                try (ResultSet rs = psmt.executeQuery()) {
                    if (!rs.next()) {
                        return false;
                    }

                    issueDate = rs.getDate("issue_date").toLocalDate();
                }
            }

            // Calculate the number of calendar days since issue
            long daysSinceIssue = ChronoUnit.DAYS.between(issueDate, returnDate);

            // First 3 days are free; ₹5 fine for each additional day
            long chargeableDays = Math.max(0, daysSinceIssue - 3);
            double fine = chargeableDays * 5.0;

            try (PreparedStatement psmt = con.prepareStatement(updateSql)) {

                psmt.setDate(1, java.sql.Date.valueOf(returnDate));
                psmt.setDouble(2, fine);
                psmt.setInt(3, issueId);

                return psmt.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get fine for a particular issue
    public double getFine(int issueId) {

        String sql = "SELECT fine FROM issue_records WHERE issue_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement psmt = con.prepareStatement(sql)) {

            psmt.setInt(1, issueId);

            try (ResultSet rs = psmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("fine");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }
}
