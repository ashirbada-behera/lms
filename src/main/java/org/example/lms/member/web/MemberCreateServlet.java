
package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.domain.Gender;
import org.example.lms.member.domain.MembershipType;
import org.example.lms.member.dto.MemberCreateRequest;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;
import org.example.lms.security.CsrfTokenUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Locale;

@WebServlet(
        name = "MemberCreateServlet",
        urlPatterns = "/members/create"
)
public class MemberCreateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String ADD_MEMBER_PAGE = "/member/add-member.jsp";

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

        request.setAttribute(
                "csrfToken",
                CsrfTokenUtil.getOrCreateToken(request)
        );

        response.setContentType("text/html;charset=UTF-8");

        request.getRequestDispatcher(ADD_MEMBER_PAGE)
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!CsrfTokenUtil.isValid(
                request,
                request.getParameter("csrfToken")
        )) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid or expired security token. Reload the form and try again."
            );
            return;
        }

        try {
            MemberCreateRequest createRequest = buildCreateRequest(request);

            MemberResponse createdMember =
                    memberService.createMember(createRequest);

            response.sendRedirect(
                    request.getContextPath()
                            + "/members/details?id="
                            + createdMember.getId()
                            + "&created=true"
            );

        } catch (IllegalArgumentException exception) {
            request.setAttribute("errorMessage", exception.getMessage());

            preserveFormValues(request);

            request.setAttribute(
                    "csrfToken",
                    CsrfTokenUtil.getOrCreateToken(request)
            );

            request.getRequestDispatcher(ADD_MEMBER_PAGE)
                    .forward(request, response);
        }
    }

    private MemberCreateRequest buildCreateRequest(
            HttpServletRequest request
    ) {
        MemberCreateRequest createRequest = new MemberCreateRequest();

        createRequest.setFullName(
                requiredParameter(request, "fullName")
        );

        createRequest.setEmail(
                requiredParameter(request, "email")
        );

        createRequest.setPhone(
                requiredParameter(request, "phone")
        );

        createRequest.setDateOfBirth(
                parseOptionalDate(request.getParameter("dateOfBirth"))
        );

        createRequest.setGender(
                parseOptionalEnum(
                        request.getParameter("gender"),
                        Gender.class
                )
        );

        createRequest.setAddress(request.getParameter("address"));

        createRequest.setMembershipType(
                parseRequiredEnum(
                        request.getParameter("membershipType"),
                        MembershipType.class,
                        "Membership type"
                )
        );

        return createRequest;
    }

    private static String requiredParameter(
            HttpServletRequest request,
            String name
    ) {
        String value = request.getParameter(name);

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(
                    fieldLabel(name) + " is required."
            );
        }

        return value.trim();
    }

    private static LocalDate parseOptionalDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        try {
            return LocalDate.parse(value.trim());
        } catch (DateTimeParseException exception) {
            throw new IllegalArgumentException(
                    "Enter a valid date of birth."
            );
        }
    }

    private static <E extends Enum<E>> E parseOptionalEnum(
            String value,
            Class<E> enumType
    ) {
        if (value == null || value.isBlank()) {
            return null;
        }

        return parseRequiredEnum(
                value,
                enumType,
                enumType.getSimpleName()
        );
    }

    private static <E extends Enum<E>> E parseRequiredEnum(
            String value,
            Class<E> enumType,
            String fieldName
    ) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }

        try {
            return Enum.valueOf(
                    enumType,
                    value.trim().toUpperCase(Locale.ROOT)
            );
        } catch (IllegalArgumentException exception) {
            throw new IllegalArgumentException(
                    "Select a valid "
                            + fieldName.toLowerCase(Locale.ROOT)
                            + "."
            );
        }
    }

    private static String fieldLabel(String name) {
        return switch (name) {
            case "fullName" -> "Full name";
            case "email" -> "Email address";
            case "phone" -> "Phone number";
            default -> "This field";
        };
    }

    private static void preserveFormValues(HttpServletRequest request) {
        request.setAttribute("fullName", request.getParameter("fullName"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phone", request.getParameter("phone"));
        request.setAttribute("dateOfBirth", request.getParameter("dateOfBirth"));
        request.setAttribute("gender", request.getParameter("gender"));
        request.setAttribute("address", request.getParameter("address"));
        request.setAttribute(
                "membershipType",
                request.getParameter("membershipType")
        );
    }
}
