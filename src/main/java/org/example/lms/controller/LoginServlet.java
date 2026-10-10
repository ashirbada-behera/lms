package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

            request.getSession(true).setAttribute("username", user.getUsername());
            request.getSession().setAttribute("role", user.getRole());

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/admin-home.jsp"
                );
            } else {
                response.sendRedirect(
                        request.getContextPath() + "/protected/home.jsp"
                );
            }

        } else {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp?error=invalid");
        }
    }
}