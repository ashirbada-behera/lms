package org.example.lms.book.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet("/book-covers/*")
public class BookCoverServlet extends HttpServlet {

    private static final Path UPLOAD_DIR = Path.of(
            System.getProperty("user.home"),
            "lms-uploads",
            "book-covers"
    );

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String filename = request.getPathInfo();

        if (filename == null
                || !filename.matches(
                "/[a-f0-9-]+\\.(jpg|png|webp)"
        )) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Path image = UPLOAD_DIR.resolve(filename.substring(1))
                .normalize();

        if (!image.startsWith(UPLOAD_DIR.normalize())
                || !Files.isRegularFile(image)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String extension = filename.substring(
                filename.lastIndexOf('.') + 1
        );

        String contentType = switch (extension) {
            case "jpg" -> "image/jpeg";
            case "png" -> "image/png";
            case "webp" -> "image/webp";
            default -> "application/octet-stream";
        };

        response.setContentType(contentType);
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setContentLengthLong(Files.size(image));

        try (var output = response.getOutputStream()) {
            Files.copy(image, output);
        }
    }
}
