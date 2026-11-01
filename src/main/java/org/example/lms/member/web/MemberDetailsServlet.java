
package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.service.MemberNotFoundException;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;

import java.io.IOException;

@WebServlet(
        name = "MemberDetailsServlet",
        urlPatterns = "/members/details"
)
public class MemberDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DETAILS_PAGE =
            "/member/member-details.jsp";

    private MemberService memberService;

    @Override
    public void init() throws ServletException {
        memberService = new MemberServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParameter = request.getParameter("id");

        if (idParameter == null || idParameter.isBlank()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A member ID is required."
            );
            return;
        }

        final long memberId;

        try {
            memberId = Long.parseLong(idParameter.trim());

            if (memberId <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "A valid member ID is required."
                );
                return;
            }
        } catch (NumberFormatException exception) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A valid member ID is required."
            );
            return;
        }

        try {
            MemberResponse member =
                    memberService.getMemberById(memberId);

            request.setAttribute("member", member);

            request.getRequestDispatcher(DETAILS_PAGE)
                    .forward(request, response);

        } catch (MemberNotFoundException exception) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "The requested member was not found."
            );
        }
    }
}
