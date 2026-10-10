package org.example.lms.member.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.example.lms.member.domain.Gender;
import org.example.lms.member.domain.MembershipType;
import org.example.lms.member.dto.MemberResponse;
import org.example.lms.member.dto.MemberUpdateRequest;
import org.example.lms.member.service.MemberNotFoundException;
import org.example.lms.member.service.MemberService;
import org.example.lms.member.service.MemberServiceImpl;
import org.example.lms.security.CsrfTokenUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Locale;

@WebServlet(
        name = "MemberEditServlet",
        urlPatterns = "/members/edit"
)
public class MemberEditServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String EDIT_PAGE = "/member/edit-member.jsp";

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

        // Make the session CSRF token available to the edit form.
        request.setAttribute(
                "csrfToken",
                CsrfTokenUtil.getOrCreateToken(request)
        );

        Long id = parseMemberId(request.getParameter("id"), response);

        if (id == null) {
            return;
        }

        try {
            MemberResponse member = memberService.getMemberById(id);

            request.setAttribute("member", member);

            request.getRequestDispatcher(EDIT_PAGE)
                    .forward(request, response);

        } catch (MemberNotFoundException exception) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "The requested member was not found."
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Reject invalid or missing tokens before processing the update.
        if (!CsrfTokenUtil.isValid(
                request,
                request.getParameter("csrfToken"))) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid or expired security token. "
                            + "Reload the edit form and try again."
            );
            return;
        }

        Long id = parseMemberId(request.getParameter("id"), response);

        if (id == null) {
            return;
        }

        try {
            MemberUpdateRequest updateRequest = buildUpdateRequest(request);

            MemberResponse updatedMember =
                    memberService.updateMember(id, updateRequest);

            response.sendRedirect(
                    request.getContextPath()
                            + "/members/details?id="
                            + updatedMember.getId()
                            + "&updated=true"
            );

        } catch (MemberNotFoundException exception) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "The requested member was not found."
            );

        } catch (IllegalArgumentException exception) {
            request.setAttribute("errorMessage", exception.getMessage());
            request.setAttribute("memberId", id);

            // Preserve the token when redisplaying a validation error.
            request.setAttribute(
                    "csrfToken",
                    CsrfTokenUtil.getOrCreateToken(request)
            );

            preserveFormValues(request);

            request.getRequestDispatcher(EDIT_PAGE)
                    .forward(request, response);
        }
    }

    private static MemberUpdateRequest buildUpdateRequest(
            HttpServletRequest request
    ) {
        MemberUpdateRequest updateRequest = new MemberUpdateRequest();

        updateRequest.setFullName(
                requiredParameter(request, "fullName")
        );

        updateRequest.setEmail(
                requiredParameter(request, "email")
        );

        updateRequest.setPhone(
                requiredParameter(request, "phone")
        );

        updateRequest.setDateOfBirth(
                parseOptionalDate(request.getParameter("dateOfBirth"))
        );

        updateRequest.setGender(
                parseOptionalEnum(
                        request.getParameter("gender"),
                        Gender.class
                )
        );

        updateRequest.setAddress(request.getParameter("address"));

        updateRequest.setMembershipType(
                parseRequiredEnum(
                        request.getParameter("membershipType"),
                        MembershipType.class,
                        "Membership type"
                )
        );

        updateRequest.setRegistrationDate(
                parseRequiredDate(
                        request.getParameter("registrationDate"),
                        "Registration date"
                )
        );

        updateRequest.setValidUntil(
                parseRequiredDate(
                        request.getParameter("validUntil"),
                        "Membership expiry date"
                )
        );

        return updateRequest;
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

    private static LocalDate parseRequiredDate(
            String value,
            String fieldName
    ) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }

        try {
            return LocalDate.parse(value.trim());
        } catch (DateTimeParseException exception) {
            throw new IllegalArgumentException(
                    "Enter a valid "
                            + fieldName.toLowerCase(Locale.ROOT)
                            + "."
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
            default -> name;
        };
    }

    private static void preserveFormValues(
            HttpServletRequest request
    ) {
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

        request.setAttribute(
                "registrationDate",
                request.getParameter("registrationDate")
        );

        request.setAttribute(
                "validUntil",
                request.getParameter("validUntil")
        );
    }
}
