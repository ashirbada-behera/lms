package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.service.MemberNotFoundException;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;
import org.example.lms.security.CsrfTokenUtil;

import java.io.IOException;

@WebServlet(
        name = "MemberDeactivateServlet",
        urlPatterns = "/members/deactivate"
)
public class MemberDeactivateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MemberService memberService;

    @Override
    public void init() throws ServletException {
        memberService = new MemberServiceImpl();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Validate CSRF before performing any state-changing operation.
        String submittedToken = request.getParameter("csrfToken");

        if (!CsrfTokenUtil.isValid(request, submittedToken)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid or expired security token. "
                            + "Reload the member directory and try again."
            );
            return;
        }

        String idParameter = request.getParameter("id");
        Long memberId;

        try {
            if (idParameter == null || idParameter.isBlank()) {
                throw new IllegalArgumentException();
            }

            memberId = Long.parseLong(idParameter.trim());

            if (memberId <= 0) {
                throw new IllegalArgumentException();
            }

        } catch (IllegalArgumentException exception) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A valid member ID is required."
            );
            return;
        }

        try {
            memberService.deactivateMember(memberId);

            response.sendRedirect(
                    request.getContextPath() + "/members?deactivated=true"
            );

        } catch (MemberNotFoundException exception) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "The requested member was not found."
            );
        }
    }
}