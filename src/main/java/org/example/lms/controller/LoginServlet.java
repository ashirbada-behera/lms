package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.example.lms.model.User;
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

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=empty");
            return;
        }

        User user = authenticationService.authenticate(username, password);

        if (user != null) {

            HttpSession session = request.getSession(true);

            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            session.setAttribute("currentUser", user);

            // Both ADMIN and MEMBER use the common dashboard.
            response.sendRedirect(
                    request.getContextPath() + "/index.jsp"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=invalid");
        }
    }
}