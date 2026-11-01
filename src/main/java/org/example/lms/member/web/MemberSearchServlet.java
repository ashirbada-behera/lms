package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(
        name = "MemberSearchServlet",
        urlPatterns = "/members/search"
)
public class MemberSearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String SEARCH_PAGE =
            "/member/search-member.jsp";

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

        String query = request.getParameter("q");

        if (query != null) {
            query = query.trim();
        }

        request.setAttribute("searchQuery", query);

        try {
            List<MemberResponse> members =
                    memberService.searchMembers(query);

            request.setAttribute("members", members);
            request.setAttribute("memberCount", members.size());

        } catch (IllegalArgumentException exception) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            request.setAttribute(
                    "errorMessage",
                    "Please provide a valid search query."
            );

            request.setAttribute("members", List.of());
            request.setAttribute("memberCount", 0);
        }

        request.getRequestDispatcher(SEARCH_PAGE)
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String query = request.getParameter("q");

        if (query == null) {
            query = "";
        }

        String encodedQuery = URLEncoder.encode(
                query.trim(),
                StandardCharsets.UTF_8
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/members/search?q="
                        + encodedQuery
        );
    }
}
