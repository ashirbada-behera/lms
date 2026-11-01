
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

@WebServlet(name = "MemberDeactivateServlet", urlPatterns = "/members/deactivate")
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

        setNoCacheHeaders(response);
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

        Long memberId = parseMemberId(
                request.getParameter("id"),
                response
        );

        if (memberId == null) {
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

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Unexpected error while deactivating a member.",
                    exception
            );

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to deactivate the member. Please try again."
                );
            }
        }
    }

    private static Long parseMemberId(
            String value,
            HttpServletResponse response
    ) throws IOException {

        try {
            if (value == null || value.isBlank()) {
                throw new NumberFormatException();
            }

            long id = Long.parseLong(value.trim());

            if (id <= 0) {
                throw new NumberFormatException();
            }

            return id;

        } catch (NumberFormatException exception) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A valid member ID is required."
            );
            return null;
        }
    }

    private static void setNoCacheHeaders(HttpServletResponse response) {
        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate, max-age=0"
        );
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
