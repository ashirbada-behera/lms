package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.example.lms.dao.UserDAO;
import org.example.lms.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<User> users = userDAO.getAllUsers();

        request.setAttribute("users", users);

        request.getRequestDispatcher("/admin/user-management.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");

        try {

            if ("add".equals(action)) {

                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                if (username == null || username.isBlank()
                        || password == null || password.isBlank()
                        || role == null
                        || (!"ADMIN".equals(role) && !"MEMBER".equals(role))) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/users?error=invalid");
                    return;
                }

                userDAO.addUser(username.trim(), password, role);

            } else if ("update".equals(action)) {

                int id = Integer.parseInt(request.getParameter("id"));
                String role = request.getParameter("role");

                if (!"ADMIN".equals(role) && !"MEMBER".equals(role)) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser != null && currentUser.getId() == id) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/users?error=self");
                    return;
                }

                userDAO.updateUserRole(id, role);

            } else if ("delete".equals(action)) {

                int id = Integer.parseInt(request.getParameter("id"));

                User currentUser = (User) session.getAttribute("currentUser");

                if (currentUser != null) {
                    userDAO.deleteUser(id, currentUser.getId());
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

        } catch (NumberFormatException e) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;

        } catch (RuntimeException e) {

            response.sendRedirect(
                    request.getContextPath() + "/admin/users?error=operation");
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/admin/users?success=1");
    }

    private boolean isAdmin(HttpSession session) {

        return session != null
                && session.getAttribute("username") != null
                && "ADMIN".equalsIgnoreCase(
                (String) session.getAttribute("role"));
    }
}