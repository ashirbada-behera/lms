package org.example.lms.dao;
import java.sql.Connection;
import org.example.lms.model.util.DBConnection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.sql.ResultSet;

import org.example.lms.model.IssueRecord;

public class IssueDAO {
    public boolean addIssue(IssueRecord issue) {
        String sql = "INSERT INTO issue_records (member_id, book_id, issue_date, due_date, return_date, status, fine) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement psmt = con.prepareStatement(sql);

            psmt.setInt(1, issue.getMemberId());
            psmt.setInt(2, issue.getBookId());
            psmt.setDate(3, java.sql.Date.valueOf(issue.getIssueDate()));
            psmt.setDate(4, java.sql.Date.valueOf(issue.getDueDate()));
            if (issue.getReturnDate() != null) {
                psmt.setDate(5, java.sql.Date.valueOf(issue.getReturnDate()));
            } else {
                psmt.setNull(5, java.sql.Types.DATE);
            }
            psmt.setString(6, issue.getStatus());
            psmt.setDouble(7, issue.getFine());

            psmt.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean returnBook(int issueId) {
        LocalDate returnDate = LocalDate.now();

        String selectSql =
                "SELECT due_date FROM issue_records " +
                        "WHERE issue_id = ? AND status = 'ISSUED'";

        String updateSql =
                "UPDATE issue_records SET return_date = ?, status = ?, fine = ? " +
                        "WHERE issue_id = ? AND status = 'ISSUED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(selectSql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }

                LocalDate dueDate =
                        rs.getDate("due_date").toLocalDate();

                long daysLate =
                        java.time.temporal.ChronoUnit.DAYS
                                .between(dueDate, returnDate);

                double fine = Math.max(0, daysLate) * 5.0;

                try (PreparedStatement updatePs =
                             con.prepareStatement(updateSql)) {

                    updatePs.setDate(
                            1, java.sql.Date.valueOf(returnDate));
                    updatePs.setString(2, "RETURNED");
                    updatePs.setDouble(3, fine);
                    updatePs.setInt(4, issueId);

                    return updatePs.executeUpdate() == 1;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}