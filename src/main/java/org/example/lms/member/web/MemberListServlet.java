package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;
import org.example.lms.security.CsrfTokenUtil;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

@WebServlet(
        name = "MemberListServlet",
        urlPatterns = "/members"
)
public class MemberListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String MEMBER_LIST_PAGE = "/member/members.jsp";

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

        // Make the session CSRF token available to the JSP.
        request.setAttribute(
                "csrfToken",
                CsrfTokenUtil.getOrCreateToken(request)
        );

        try {
            String statusParameter = request.getParameter("status");
            String searchParameter = request.getParameter("q");

            List<MemberResponse> members;

            if (statusParameter != null && !statusParameter.isBlank()) {
                MemberStatus status = parseStatus(statusParameter);

                members = memberService.getMembersByStatus(status);
                request.setAttribute("selectedStatus", status.name());

            } else if (searchParameter != null && !searchParameter.isBlank()) {
                members = memberService.searchMembers(searchParameter.trim());

            } else {
                members = memberService.getAllMembers();
            }

            request.setAttribute("members", members);
            request.setAttribute("searchQuery", searchParameter);
            request.setAttribute("memberCount", members.size());

            request.getRequestDispatcher(MEMBER_LIST_PAGE)
                    .forward(request, response);

        } catch (IllegalArgumentException exception) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            request.setAttribute(
                    "errorMessage",
                    "The selected member filter is invalid."
            );
            request.setAttribute("members", List.of());
            request.setAttribute("memberCount", 0);

            request.getRequestDispatcher(MEMBER_LIST_PAGE)
                    .forward(request, response);
        }
    }

    private static MemberStatus parseStatus(String value) {
        try {
            return MemberStatus.valueOf(
                    value.trim().toUpperCase(Locale.ROOT)
            );
        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException("Invalid member status.");
        }
    }
}