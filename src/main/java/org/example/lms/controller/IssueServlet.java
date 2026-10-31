
package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.dao.MemberDAO;
import org.example.lms.dao.IssueDAO;
import org.example.lms.model.IssueRecord;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/issue")
public class IssueServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/issue.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");

        String registrationNumber = req.getParameter("registrationNumber");
        String bookIdText = req.getParameter("bookId");
        String dueDateText = req.getParameter("dueDate");

        // Validate registration number
        if (registrationNumber == null || registrationNumber.trim().isEmpty()) {
            showMessage(req, resp, "Please enter a registration number.", "error");
            return;
        }

        // Check whether member exists
        MemberDAO memberDAO = new MemberDAO();
        int memberId = memberDAO.getMemberId(registrationNumber.trim());

        if (memberId == -1) {
            showMessage(req, resp,
                    "Member not found. Check the registration number.", "error");
            return;
        }

        try {
            // Validate Book ID
            int bookId = Integer.parseInt(bookIdText);

            if (bookId <= 0) {
                showMessage(req, resp,
                        "Book ID must be a positive number.", "error");
                return;
            }

            // Validate due date
            if (dueDateText == null || dueDateText.trim().isEmpty()) {
                showMessage(req, resp, "Please select a due date.", "error");
                return;
            }

            LocalDate issueDate = LocalDate.now();
            LocalDate dueDate = LocalDate.parse(dueDateText);

            if (dueDate.isBefore(issueDate)) {
                showMessage(req, resp,
                        "Due date cannot be before the issue date.", "error");
                return;
            }

            IssueDAO issueDAO = new IssueDAO();

            // Check for an existing active issue
            if (issueDAO.isBookAlreadyIssued(bookId)) {
                showMessage(req, resp,
                        "This book is already issued.", "error");
                return;
            }

            // Create issue record
            IssueRecord issue = new IssueRecord(
                    0,
                    memberId,
                    bookId,
                    issueDate,
                    dueDate,
                    null,
                    "ISSUED",
                    0.0
            );

            // Save and retrieve generated Issue ID
            int generatedIssueId = issueDAO.addIssue(issue);

            if (generatedIssueId > 0) {

                req.setAttribute("issueId", generatedIssueId);
                req.setAttribute("memberId", memberId);
                req.setAttribute("bookId", bookId);
                req.setAttribute("issueDate", issueDate);
                req.setAttribute("dueDate", dueDate);

                showMessage(req, resp,
                        "Book issued successfully!", "success");

            } else {
                showMessage(req, resp,
                        "Issue failed. The book may already be issued. Please try again.",
                        "error");
            }

        } catch (NumberFormatException e) {
            showMessage(req, resp,
                    "Please enter a valid numeric Book ID.", "error");

        } catch (DateTimeParseException e) {
            showMessage(req, resp,
                    "Please enter a valid due date.", "error");

        } catch (SQLException e) {
            e.printStackTrace();
            showMessage(req, resp,
                    "Unable to check book availability. Please try again.", "error");
        }
    }

    private void showMessage(HttpServletRequest req,
                             HttpServletResponse resp,
                             String message,
                             String messageType)
            throws ServletException, IOException {

        req.setAttribute("message", message);
        req.setAttribute("messageType", messageType);

        req.getRequestDispatcher("/issue.jsp").forward(req, resp);
    }
}
