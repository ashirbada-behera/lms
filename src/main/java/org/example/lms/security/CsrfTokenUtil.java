package org.example.lms.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Objects;

public final class CsrfTokenUtil {

    private static final String SESSION_ATTRIBUTE = "csrfToken";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private CsrfTokenUtil() {
        // Utility class; prevent instantiation.
    }

    public static String getOrCreateToken(HttpServletRequest request) {
        Objects.requireNonNull(request, "Request is required.");

        HttpSession session = request.getSession(true);
        Object existingToken = session.getAttribute(SESSION_ATTRIBUTE);

        if (existingToken instanceof String token && !token.isBlank()) {
            return token;
        }

        byte[] randomBytes = new byte[32];
        SECURE_RANDOM.nextBytes(randomBytes);

        String token = Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(randomBytes);

        session.setAttribute(SESSION_ATTRIBUTE, token);
        return token;
    }

    public static boolean isValid(
            HttpServletRequest request,
            String submittedToken
    ) {
        if (request == null || submittedToken == null
                || submittedToken.isBlank()) {
            return false;
        }

        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        Object expectedToken = session.getAttribute(SESSION_ATTRIBUTE);

        if (!(expectedToken instanceof String token)) {
            return false;
        }

        return MessageDigest.isEqual(
                token.getBytes(StandardCharsets.UTF_8),
                submittedToken.getBytes(StandardCharsets.UTF_8)
        );
    }
}
