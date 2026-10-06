package org.example.lms.service;

public class AuthenticationService {

    public boolean authenticate(String username, String password) {

        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        if (password == null || password.trim().isEmpty()) {
            return false;
        }

        return true;
    }
}