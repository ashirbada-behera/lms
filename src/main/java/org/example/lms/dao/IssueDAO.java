
package org.example.lms.dao;

import org.example.lms.model.IssueRecord;
import org.example.lms.model.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

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


    // Add a new issue record
    public boolean addIssue(IssueRecord issue) {

        String checkSql = "SELECT issue_id FROM issue_records " +
                "WHERE book_id = ? AND status = 'ISSUED'";

        String insertSql = "INSERT INTO issue_records " +
                "(member_id, book_id, issue_date, due_date, return_date, status, fine) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {

            // Prevent issuing an already issued book
            try (PreparedStatement checkStmt = con.prepareStatement(checkSql)) {

                checkStmt.setInt(1, issue.getBookId());

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        return false;
                    }
                }
            }

            // Insert issue record
            try (PreparedStatement psmt = con.prepareStatement(insertSql)) {

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

                return psmt.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // Return a book and calculate its fine
    public boolean returnBook(int issueId) {

        LocalDate returnDate = LocalDate.now();

        String selectSql = "SELECT due_date FROM issue_records " +
                "WHERE issue_id = ? AND status = 'ISSUED'";

        String updateSql = "UPDATE issue_records " +
                "SET return_date = ?, status = 'RETURNED', fine = ? " +
                "WHERE issue_id = ? AND status = 'ISSUED'";

        try (Connection con = DBConnection.getConnection()) {

            LocalDate dueDate;

            // Get due date
            try (PreparedStatement psmt = con.prepareStatement(selectSql)) {

                psmt.setInt(1, issueId);

                try (ResultSet rs = psmt.executeQuery()) {

                    if (!rs.next()) {
                        return false;
                    }

                    dueDate = rs.getDate("due_date").toLocalDate();
                }
            }

            // Calculate fine: ₹5 per late day
            long daysLate = ChronoUnit.DAYS.between(dueDate, returnDate);
            double fine = Math.max(0, daysLate) * 5.0;

            // Update return details
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


    // Get the fine for a particular issue
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
