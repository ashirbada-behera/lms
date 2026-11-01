package org.example.lms.dao;

import org.example.lms.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MemberDAO {

    public Long findMemberIdByCode(String memberCode)
            throws SQLException {

        String sql = """
                SELECT id
                FROM members
                WHERE member_code = ?
                AND status = 'ACTIVE'
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, memberCode.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("id");
                }
            }
        }

        return null;
    }
}