package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.service.MemberNotFoundException;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;
import org.example.lms.security.CsrfTokenUtil;

import java.io.IOException;

@WebServlet(name = "MemberActivateServlet", urlPatterns = "/members/activate")
public class MemberActivateServlet extends HttpServlet {

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

        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        request.setCharacterEncoding("UTF-8");

        if (!CsrfTokenUtil.isValid(
                request,
                request.getParameter("csrfToken"))) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid or expired security token. Reload the member directory and try again."
            );
            return;
        }

        Long memberId;

        try {
            memberId = Long.parseLong(request.getParameter("id"));

            if (memberId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException | NullPointerException exception) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A valid member ID is required."
            );
            return;
        }

        try {
            memberService.changeMemberStatus(
                    memberId,
                    MemberStatus.ACTIVE
            );

            response.sendRedirect(
                    request.getContextPath() + "/members?activated=true"
            );

        } catch (MemberNotFoundException exception) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "The requested member was not found."
            );

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Unexpected error while activating a member.",
                    exception
            );

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to activate the member. Please try again."
                );
            }
        }
    }
}
