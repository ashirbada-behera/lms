package org.example.lms.service;

import org.example.lms.dao.UserDAO;
import org.example.lms.model.User;

public class AuthenticationService {

    private final UserDAO userDAO = new UserDAO();

    public User authenticate(String username, String password) {

        if (username == null || username.trim().isEmpty()) {
            return null;
        }

        if (password == null || password.trim().isEmpty()) {
            return null;
        }

        return userDAO.authenticate(username, password);
    }
}