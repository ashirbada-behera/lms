package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.lms.dao.IssueDAO;

import java.io.IOException;

@WebServlet("/return")
public class ReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/return.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String issueIdText = req.getParameter("issueId");
        IssueDAO issueDAO = new IssueDAO();

        try {
            int issueId = Integer.parseInt(issueIdText);
            boolean success = issueDAO.returnBook(issueId);

            if (success) {
                double fine = issueDAO.getFine(issueId);
                req.setAttribute("message", "Book returned successfully!");
                req.setAttribute("fine", fine);
                req.setAttribute("success", true);
            } else {
                req.setAttribute("message",
                        "Return failed. Check the issue ID or book status.");
                req.setAttribute("success", false);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("message", "Please enter a valid issue ID.");
            req.setAttribute("success", false);
        }

        req.getRequestDispatcher("/return.jsp").forward(req, resp);
    }
}