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
import java.util.List;
import org.example.lms.model.IssueRecord;

@WebServlet("/return")
public class ReturnServlet extends HttpServlet {

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

        String memberCode = request.getParameter("memberCode");

        if (memberCode != null && !memberCode.isBlank()) {
            try {
                Long memberId =
                        memberDAO.findMemberIdByCode(memberCode);

                if (memberId == null) {
                    request.setAttribute(
                            "error",
                            "Active member not found. Check the member code."
                    );
                } else {
                    List<IssueRecord> issues =
                            issueDAO.findActiveIssuesByMemberCode(memberCode);

                    request.setAttribute("issues", issues);
                    request.setAttribute("memberCode", memberCode.trim());
                }

            } catch (SQLException exception) {
                getServletContext().log(
                        "Database error while finding active issues.",
                        exception
                );

                request.setAttribute(
                        "error",
                        "Unable to retrieve issued books. Please try again."
                );
            }
        }

        request.getRequestDispatcher("/return.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String memberCode = request.getParameter("memberCode");
        String issueIdValue = request.getParameter("issueId");

        try {
            if (memberCode == null || memberCode.isBlank()) {
                throw new IllegalArgumentException(
                        "Member code is required."
                );
            }

            if (issueIdValue == null || issueIdValue.isBlank()) {
                throw new IllegalArgumentException(
                        "Issue ID is required."
                );
            }

            Long issueId;

            try {
                issueId = Long.parseLong(issueIdValue.trim());

                if (issueId <= 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException exception) {
                throw new IllegalArgumentException(
                        "Please enter a valid Issue ID."
                );
            }

            Long memberId =
                    memberDAO.findMemberIdByCode(memberCode);

            if (memberId == null) {
                throw new IllegalArgumentException(
                        "Active member not found. Check the member code."
                );
            }

            issueDAO.returnBook(issueId, memberId);

            response.sendRedirect(
                    request.getContextPath()
                            + "/return?memberCode="
                            + java.net.URLEncoder.encode(
                            memberCode.trim(),
                            java.nio.charset.StandardCharsets.UTF_8
                    )
                            + "&success=1"
            );

        } catch (IllegalArgumentException exception) {
            showError(
                    request, response, memberCode, exception.getMessage()
            );

        } catch (SQLException exception) {
            getServletContext().log(
                    "Database error while returning a book.",
                    exception
            );

            showError(
                    request,
                    response,
                    memberCode,
                    "Unable to return the book. Verify that this Issue ID "
                            + "belongs to the member and is still active."
            );
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String memberCode,
            String message
    ) throws ServletException, IOException {

        request.setAttribute("error", message);
        request.setAttribute("memberCode", memberCode);

        request.getRequestDispatcher("/return.jsp")
                .forward(request, response);
    }
}