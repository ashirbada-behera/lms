package org.example.lms.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter({"/protected/*", "/admin/*"})
public class LoginCheckFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("username") == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/login.jsp"
            );
            return;
        }

        String requestPath = httpRequest.getRequestURI()
                .substring(httpRequest.getContextPath().length());

        if (requestPath.startsWith("/admin/")) {

            String role = (String) session.getAttribute("role");

            if (!"ADMIN".equalsIgnoreCase(role)) {
                httpResponse.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Access denied. Admin role required."
                );
                return;
            }
        }

        chain.doFilter(request, response);
    }
}