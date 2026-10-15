package org.example.lms.dao;

import org.example.lms.model.User;
import org.example.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User authenticate(String username, String password) {

        String sql = "SELECT id, username, password, role " +
                "FROM lms WHERE username = ? AND password = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username);
            statement.setString(2, password);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {

                User user = new User();
                user.setUsername(resultSet.getString("username"));
                user.setRole(resultSet.getString("role"));

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Database authentication failed.", e);
        }

        return null;
    }
}