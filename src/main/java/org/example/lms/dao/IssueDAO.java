package org.example.lms.dao;
import java.sql.Connection;
import org.example.lms.model.util.DBConnection;
import java.sql.PreparedStatement;
import org.example.lms.model.IssueRecord;

public class IssueDAO {
    public boolean addIssue(IssueRecord issue) {
        String sql = "INSERT INTO issue_records (member_id, book_id, issue_date, due_date, return_date, status, fine) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement psmt = con.prepareStatement(sql);

            psmt.setInt(1, issue.getMemberId());
            psmt.setInt(2, issue.getBookId());
            psmt.setDate(3, java.sql.Date.valueOf (issue.getIssueDate()));
            psmt.setDate(4, java.sql.Date.valueOf (issue.getDueDate()));
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
}
