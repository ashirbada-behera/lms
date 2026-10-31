
package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.dao.IssueDAO;
import org.example.lms.model.IssueRecord;

import java.io.IOException;
import java.util.List;

@WebServlet("/return")
public class ReturnServlet extends HttpServlet {

    private final IssueDAO issueDAO = new IssueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/return.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String registrationNumber = req.getParameter("registrationNumber");

        if (registrationNumber == null || registrationNumber.trim().isEmpty()) {
            req.setAttribute("message", "Please enter the member registration number.");
            req.setAttribute("success", false);
            req.getRequestDispatcher("/return.jsp").forward(req, resp);
            return;
        }

        registrationNumber = registrationNumber.trim();
        req.setAttribute("registrationNumber", registrationNumber);

        if ("search".equals(action)) {

            findIssuedBooks(req, registrationNumber);

        } else if ("return".equals(action)) {

            processReturn(req, registrationNumber);

        } else {

            req.setAttribute("message", "Invalid request.");
            req.setAttribute("success", false);
        }

        req.getRequestDispatcher("/return.jsp").forward(req, resp);
    }

    private void findIssuedBooks(HttpServletRequest req, String registrationNumber) {

        List<IssueRecord> issuedBooks =
                issueDAO.getIssuedBooksByRegistrationNumber(registrationNumber);

        req.setAttribute("issuedBooks", issuedBooks);

        if (issuedBooks.isEmpty()) {
            req.setAttribute("message",
                    "No currently issued books found for this member.");
            req.setAttribute("success", false);
        }
    }

    private void processReturn(HttpServletRequest req, String registrationNumber) {

        String issueIdText = req.getParameter("issueId");

        try {

            int issueId = Integer.parseInt(issueIdText);

            if (issueId <= 0) {
                throw new NumberFormatException();
            }

            // Verify that this issue belongs to the entered member
            List<IssueRecord> issuedBooks =
                    issueDAO.getIssuedBooksByRegistrationNumber(registrationNumber);

            boolean belongsToMember = issuedBooks.stream()
                    .anyMatch(issue -> issue.getIssueId() == issueId);

            if (!belongsToMember) {
                req.setAttribute("message",
                        "This issue does not belong to the selected member or is already returned.");
                req.setAttribute("success", false);

            } else if (issueDAO.returnBook(issueId)) {

                double fine = issueDAO.getFine(issueId);

                req.setAttribute("message", "Book returned successfully!");
                req.setAttribute("fine", fine);
                req.setAttribute("success", true);

            } else {

                req.setAttribute("message",
                        "Return failed. Please try again.");
                req.setAttribute("success", false);
            }

        } catch (NumberFormatException e) {

            req.setAttribute("message", "Invalid issue ID.");
            req.setAttribute("success", false);
        }

        // Refresh the member's remaining issued books
        findIssuedBooks(req, registrationNumber);

        // Preserve the return confirmation if one was set
        if (Boolean.TRUE.equals(req.getAttribute("success"))
                && req.getAttribute("fine") != null) {
            req.setAttribute("message", "Book returned successfully!");
            req.setAttribute("success", true);
        }
    }
}
