
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain");
        resp.setCharacterEncoding("UTF-8");

        String registrationNumber = req.getParameter("registrationNumber");
        String bookIdText = req.getParameter("bookId");
        String dueDateText = req.getParameter("dueDate");

        // Validate registration number
        if (registrationNumber == null || registrationNumber.trim().isEmpty()) {
            resp.getWriter().write("Please enter a registration number.");
            return;
        }

        // Check whether member exists
        MemberDAO memberDAO = new MemberDAO();
        int memberId = memberDAO.getMemberId(registrationNumber.trim());

        if (memberId == -1) {
            resp.getWriter().write("Member not found. Check the registration number.");
            return;
        }

        try {
            // Validate book ID
            int bookId = Integer.parseInt(bookIdText);

            if (bookId <= 0) {
                resp.getWriter().write("Book ID must be a positive number.");
                return;
            }

            // Check whether book is already issued
            IssueDAO issueDAO = new IssueDAO();

            if (issueDAO.isBookAlreadyIssued(bookId)) {
                resp.getWriter().write("This book is already issued.");
                return;
            }

            // Validate due date
            LocalDate dueDate = LocalDate.parse(dueDateText);
            LocalDate issueDate = LocalDate.now();

            if (dueDate.isBefore(issueDate)) {
                resp.getWriter().write("Due date cannot be before the issue date.");
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

            boolean success = issueDAO.addIssue(issue);

            if (success) {
                resp.getWriter().write("success");
            } else {
                resp.getWriter().write("failure");
            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("Please enter a valid numeric Book ID.");

        } catch (DateTimeParseException e) {
            resp.getWriter().write("Please enter a valid due date.");

        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().write(
                    "Unable to verify book availability. Please try again."
            );
        }
    }
}
