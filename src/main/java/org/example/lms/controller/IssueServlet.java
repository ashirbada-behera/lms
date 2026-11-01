package org.example.lms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.dao.IssueDAO;
import org.example.lms.dao.MemberDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/issue")
public class IssueServlet extends HttpServlet {

    private MemberDAO memberDAO;
    private IssueDAO issueDAO;

    @Override
    public void init() throws ServletException {
        memberDAO = new MemberDAO();
        issueDAO = new IssueDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.getRequestDispatcher("/issue.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String memberCode = request.getParameter("memberCode");
        String bookIdValue = request.getParameter("bookId");
        String dueDateValue = request.getParameter("dueDate");

        try {
            if (memberCode == null || memberCode.isBlank()) {
                throw new IllegalArgumentException(
                        "Member code is required.");
            }

            if (bookIdValue == null || bookIdValue.isBlank()) {
                throw new IllegalArgumentException(
                        "Book ID is required.");
            }

            if (dueDateValue == null || dueDateValue.isBlank()) {
                throw new IllegalArgumentException(
                        "Due date is required.");
            }

            Long bookId;

            try {
                bookId = Long.parseLong(bookIdValue.trim());

                if (bookId <= 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException exception) {
                throw new IllegalArgumentException(
                        "Please enter a valid positive Book ID.");
            }

            LocalDate issueDate = LocalDate.now();
            LocalDate dueDate;

            try {
                dueDate = LocalDate.parse(dueDateValue.trim());

            } catch (DateTimeParseException exception) {
                throw new IllegalArgumentException(
                        "Please enter a valid due date.");
            }

            if (dueDate.isBefore(issueDate)) {
                throw new IllegalArgumentException(
                        "Due date cannot be before the issue date.");
            }

            Long memberId =
                    memberDAO.findMemberIdByCode(memberCode);

            if (memberId == null) {
                throw new IllegalArgumentException(
                        "Active member not found. Check the member code.");
            }

            Long issueId = issueDAO.issueBook(
                    memberId,
                    bookId,
                    issueDate,
                    dueDate
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/issue?success=1&issueId=" + issueId
            );

        } catch (IllegalArgumentException exception) {

            showError(request, response, memberCode,
                    bookIdValue, dueDateValue, exception.getMessage());

        } catch (SQLException exception) {

            getServletContext().log(
                    "Database error while issuing a book.", exception
            );

            String message = "Unable to issue the book. "
                    + "Check that the book exists and has available copies.";

            showError(request, response, memberCode,
                    bookIdValue, dueDateValue, message);
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String memberCode,
            String bookId,
            String dueDate,
            String message
    ) throws ServletException, IOException {

        request.setAttribute("memberCode", memberCode);
        request.setAttribute("bookId", bookId);
        request.setAttribute("dueDate", dueDate);
        request.setAttribute("error", message);

        request.getRequestDispatcher("/issue.jsp")
                .forward(request, response);
    }
}