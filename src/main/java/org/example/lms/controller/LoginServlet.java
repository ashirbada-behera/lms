package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.lms.service.AuthenticationService;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthenticationService authenticationService =
            new AuthenticationService();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        boolean authenticated =
                authenticationService.authenticate(username, password);

        if (authenticated) {

            String role = "MEMBER";

            request.getSession(true).setAttribute("username", username);
            request.getSession().setAttribute("role", role);

            response.getWriter().println("Login successful for: " + username);
            response.getWriter().println("Role: " + role);
            response.getWriter().println("Session created successfully.");

        } else {
            response.getWriter().println("Invalid username or password.");
        }
    }
}