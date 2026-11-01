package org.example.lms.dao;

import org.example.lms.model.User;
import org.example.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Existing login authentication
    public User authenticate(String username, String password) {

        String sql = "SELECT id, username, password, role " +
                "FROM lms WHERE username = ? AND password = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username);
            statement.setString(2, password);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    User user = new User();

                    user.setId(resultSet.getInt("id"));
                    user.setUsername(resultSet.getString("username"));
                    user.setRole(resultSet.getString("role"));

                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Database authentication failed.", e);
        }

        return null;
    }

    // Get all registered users
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();

        String sql = "SELECT id, username, role FROM lms ORDER BY id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                User user = new User();

                user.setId(resultSet.getInt("id"));
                user.setUsername(resultSet.getString("username"));
                user.setRole(resultSet.getString("role"));

                users.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Unable to retrieve users.", e);
        }

        return users;
    }

    // Add a new user
    public boolean addUser(String username, String password, String role) {

        if (!"ADMIN".equalsIgnoreCase(role)
                && !"MEMBER".equalsIgnoreCase(role)) {
            return false;
        }

        String sql = "INSERT INTO lms (username, password, role) " +
                "VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username);
            statement.setString(2, password);
            statement.setString(3, role.toUpperCase());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Unable to add user.", e);
        }
    }

    // Change a user's role
    public boolean updateUserRole(int id, String role) {

        if (!"ADMIN".equalsIgnoreCase(role)
                && !"MEMBER".equalsIgnoreCase(role)) {
            return false;
        }

        String sql = "UPDATE lms SET role = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, role.toUpperCase());
            statement.setInt(2, id);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Unable to update user role.", e);
        }
    }

    // Delete a user, but never delete the currently logged-in admin
    public boolean deleteUser(int id, int currentAdminId) {

        if (id == currentAdminId) {
            return false;
        }

        String sql = "DELETE FROM lms WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Unable to delete user.", e);
        }
    }
}