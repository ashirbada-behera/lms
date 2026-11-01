package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.dao.DashboardDAO;
import org.example.lms.model.DashboardStats;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private DashboardDAO dashboardDAO;

    @Override
    public void init() {
        dashboardDAO = new DashboardDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int totalBooks = dashboardDAO.getTotalBooks();
            int totalMembers = dashboardDAO.getTotalMembers();
            int booksIssued = dashboardDAO.getBooksIssued();
            int overdueBooks = dashboardDAO.getOverdueBooks();

            DashboardStats stats = new DashboardStats(
                    totalBooks,
                    totalMembers,
                    booksIssued,
                    overdueBooks
            );

            request.setAttribute("dashboardStats", stats);

            request.getRequestDispatcher("/index.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load dashboard statistics.", e
            );
        }
    }
}
