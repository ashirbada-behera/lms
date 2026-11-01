
package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.domain.MemberStatus;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.repository.MemberRepository;
import org.example.lms.member.repository.MemberRepositoryImpl;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;
import org.example.lms.security.CsrfTokenUtil;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "MemberListServlet", urlPatterns = "/members")
public class MemberListServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String MEMBER_LIST_PAGE =
            "/member/members.jsp";

    private MemberService memberService;

    /**
     * Initializes Member Management dependencies.
     */
    @Override
    public void init() throws ServletException {
        try {
            MemberRepository memberRepository =
                    new MemberRepositoryImpl();

            memberService =
                    new MemberServiceImpl(memberRepository);

        } catch (RuntimeException exception) {
            getServletContext().log(
                    "Member Management initialization failed.",
                    exception
            );

            throw new ServletException(
                    "Unable to initialize Member Management.",
                    exception
            );
        }
    }

    /**
     * Displays the member directory.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        setNoCacheHeaders(response);

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Generate or retrieve the session CSRF token.
            request.setAttribute(
                    "csrfToken",
                    CsrfTokenUtil.getOrCreateToken(request)
            );

            // Support current and legacy search parameters.
            String searchQuery = request.getParameter("search");

            if (searchQuery == null) {
                searchQuery = request.getParameter("q");
            }

            if (searchQuery != null) {
                searchQuery = searchQuery.trim();

                if (searchQuery.isEmpty()) {
                    searchQuery = null;
                }
            }

            String statusParameter =
                    request.getParameter("status");

            request.setAttribute("searchQuery", searchQuery);

            MemberStatus selectedStatus =
                    parseStatus(statusParameter);

            request.setAttribute(
                    "selectedStatus",
                    selectedStatus == null
                            ? ""
                            : selectedStatus.name()
            );

            // Load members using the service layer.
            List<MemberResponse> members =
                    memberService.searchMembers(
                            searchQuery,
                            selectedStatus
                    );

            if (members == null) {
                throw new IllegalStateException(
                        "Member service returned a null list."
                );
            }

            request.setAttribute("members", members);
            request.setAttribute("memberCount", members.size());

            request.getRequestDispatcher(MEMBER_LIST_PAGE)
                    .forward(request, response);

        } catch (IllegalArgumentException exception) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            request.setAttribute(
                    "errorMessage",
                    "Invalid member status filter."
            );

            request.setAttribute("members", List.of());
            request.setAttribute("memberCount", 0);
            request.setAttribute("selectedStatus", "");

            request.getRequestDispatcher(MEMBER_LIST_PAGE)
                    .forward(request, response);

        } catch (Exception exception) {

            // Print the complete exception and stack trace
            // in the Tomcat console.
            getServletContext().log(
                    "ERROR: Unable to load the member directory.",
                    exception
            );

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to load the member directory. Please check Tomcat logs."
                );
            }
        }
    }

    /**
     * Parses a member status filter.
     */
    private static MemberStatus parseStatus(String value) {

        if (value == null || value.isBlank()) {
            return null;
        }

        try {
            return MemberStatus.valueOf(
                    value.trim().toUpperCase(Locale.ROOT)
            );

        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException(
                    "Invalid member status.",
                    exception
            );
        }
    }

    /**
     * Prevents browsers from displaying stale directory data.
     */
    private static void setNoCacheHeaders(
            HttpServletResponse response
    ) {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate, max-age=0"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
