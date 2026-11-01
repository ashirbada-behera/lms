package org.example.lms.book.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.example.lms.book.domain.Book;
import org.example.lms.book.service.BookService;
import org.example.lms.book.service.BookServiceImpl;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@WebServlet("/books")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 2 * 1024 * 1024,
        maxRequestSize = 3 * 1024 * 1024
)
public class BookServlet extends HttpServlet {

    private BookService bookService;

    private static final Path UPLOAD_DIR = Path.of(
            System.getProperty("user.home"),
            "lms-uploads",
            "book-covers"
    );

    private static final long MAX_IMAGE_SIZE = 2 * 1024 * 1024;

    @Override
    public void init() throws ServletException {
        bookService = new BookServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("new".equals(action)) {
                request.getRequestDispatcher("/book/add-book.jsp")
                        .forward(request, response);
                return;
            }

            if ("edit".equals(action)) {
                Long id = parseId(request.getParameter("id"));

                Book book = bookService.getBookById(id);

                if (book == null) {
                    response.sendError(404, "Book not found.");
                    return;
                }

                request.setAttribute("book", book);

                request.getRequestDispatcher("/book/edit-book.jsp")
                        .forward(request, response);
                return;
            }

            if ("delete".equals(action)) {
                response.sendError(405, "Use POST to delete a book.");
                return;
            }

            String keyword = request.getParameter("keyword");

            if (keyword != null && !keyword.isBlank()) {
                request.setAttribute(
                        "books",
                        bookService.searchBooks(keyword.trim())
                );
                request.setAttribute("keyword", keyword.trim());
            } else {
                request.setAttribute("books", bookService.getAllBooks());
            }

            request.getRequestDispatcher("/book/books.jsp")
                    .forward(request, response);

        } catch (IllegalArgumentException exception) {
            response.sendError(400, exception.getMessage());

        } catch (RuntimeException exception) {
            throw new ServletException(
                    "Unable to retrieve book information.", exception
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String newCoverPath = null;
        String oldCoverPath = null;

        try {
            if ("create".equals(action)) {

                Book book = new Book(
                        request.getParameter("isbn"),
                        request.getParameter("title"),
                        request.getParameter("author"),
                        request.getParameter("category"),
                        parseCopies(request.getParameter("totalCopies"))
                );

                newCoverPath = saveCover(request.getPart("coverImage"));
                book.setCoverImagePath(newCoverPath);

                bookService.addBook(book);

            } else if ("update".equals(action)) {

                Long id = parseId(request.getParameter("id"));

                Book existingBook = bookService.getBookById(id);

                if (existingBook == null) {
                    response.sendError(404, "Book not found.");
                    return;
                }

                existingBook.setIsbn(request.getParameter("isbn"));
                existingBook.setTitle(request.getParameter("title"));
                existingBook.setAuthor(request.getParameter("author"));
                existingBook.setCategory(request.getParameter("category"));

                int totalCopies =
                        parseCopies(request.getParameter("totalCopies"));

                if (totalCopies < existingBook.getAvailableCopies()) {
                    throw new IllegalArgumentException(
                            "Total copies cannot be less than available copies."
                    );
                }

                existingBook.setTotalCopies(totalCopies);

                oldCoverPath = existingBook.getCoverImagePath();

                Part coverPart = request.getPart("coverImage");

                if (coverPart != null && coverPart.getSize() > 0) {
                    newCoverPath = saveCover(coverPart);
                    existingBook.setCoverImagePath(newCoverPath);
                }

                bookService.updateBook(id, existingBook);

            } else if ("delete".equals(action)) {

                Long id = parseId(request.getParameter("id"));
                bookService.deleteBook(id);

            } else {
                response.sendError(400, "Unknown book action.");
                return;
            }

            // Database operation succeeded.
            // Remove the previous cover only after a successful replacement.
            if (newCoverPath != null
                    && oldCoverPath != null
                    && !oldCoverPath.equals(newCoverPath)) {
                deleteCover(oldCoverPath);
            }

            response.sendRedirect(request.getContextPath() + "/books");

        } catch (IllegalArgumentException exception) {

            // Remove newly uploaded image if the operation failed.
            deleteCover(newCoverPath);

            showError(request, response, action, exception.getMessage());

        } catch (IllegalStateException exception) {

            deleteCover(newCoverPath);

            response.sendError(
                    HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE,
                    "The uploaded image or request exceeds the allowed size."
            );

        } catch (RuntimeException exception) {

            deleteCover(newCoverPath);

            throw new ServletException(
                    "Unable to save book information.", exception
            );
        }
    }

    private String saveCover(Part part) throws IOException {

        if (part == null || part.getSize() == 0) {
            return null;
        }

        if (part.getSize() > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                    "Cover image must not exceed 2 MB."
            );
        }

        byte[] data;

        try (var input = part.getInputStream()) {
            data = input.readNBytes((int) MAX_IMAGE_SIZE + 1);
        }

        if (data.length == 0 || data.length > MAX_IMAGE_SIZE) {
            throw new IllegalArgumentException(
                    "Invalid image size."
            );
        }

        String extension = detectImageExtension(data);

        if (extension == null || !isValidImage(data)) {
            throw new IllegalArgumentException(
                    "Please upload a valid JPG, PNG or WEBP image."
            );
        }

        Files.createDirectories(UPLOAD_DIR);

        String filename = UUID.randomUUID() + "." + extension;
        Path destination = UPLOAD_DIR.resolve(filename);

        Files.write(destination, data);

        return "/book-covers/" + filename;
    }

    private String detectImageExtension(byte[] data) {

        if (data.length >= 3
                && (data[0] & 0xFF) == 0xFF
                && (data[1] & 0xFF) == 0xD8
                && (data[2] & 0xFF) == 0xFF) {
            return "jpg";
        }

        if (data.length >= 8
                && (data[0] & 0xFF) == 0x89
                && data[1] == 0x50
                && data[2] == 0x4E
                && data[3] == 0x47
                && data[4] == 0x0D
                && data[5] == 0x0A
                && data[6] == 0x1A
                && data[7] == 0x0A) {
            return "png";
        }

        if (data.length >= 12
                && data[0] == 'R'
                && data[1] == 'I'
                && data[2] == 'F'
                && data[3] == 'F'
                && data[8] == 'W'
                && data[9] == 'E'
                && data[10] == 'B'
                && data[11] == 'P') {
            return "webp";
        }

        return null;
    }

    private boolean isValidImage(byte[] data) {

        try (ByteArrayInputStream input =
                     new ByteArrayInputStream(data)) {

            BufferedImage image = ImageIO.read(input);

            return image != null
                    && image.getWidth() <= 5000
                    && image.getHeight() <= 5000;

        } catch (IOException exception) {
            return false;
        }
    }

    private void deleteCover(String coverPath) {

        if (coverPath == null || !coverPath.startsWith("/book-covers/")) {
            return;
        }

        try {
            String filename = coverPath.substring("/book-covers/".length());

            if (!filename.matches("[a-f0-9-]+\\.(jpg|png|webp)")) {
                return;
            }

            Files.deleteIfExists(UPLOAD_DIR.resolve(filename));

        } catch (IOException exception) {
            getServletContext().log(
                    "Unable to delete book cover: " + coverPath,
                    exception
            );
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String action,
            String message
    ) throws ServletException, IOException {

        request.setAttribute("error", message);

        if ("update".equals(action)) {
            Long id = parseId(request.getParameter("id"));
            request.setAttribute("book", bookService.getBookById(id));

            request.getRequestDispatcher("/book/edit-book.jsp")
                    .forward(request, response);

        } else if ("create".equals(action)) {

            request.getRequestDispatcher("/book/add-book.jsp")
                    .forward(request, response);

        } else {
            request.setAttribute("books", bookService.getAllBooks());

            request.getRequestDispatcher("/book/books.jsp")
                    .forward(request, response);
        }
    }

    private Long parseId(String value) {

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Book ID is required.");
        }

        try {
            long id = Long.parseLong(value);

            if (id <= 0) {
                throw new IllegalArgumentException("Book ID must be positive.");
            }

            return id;

        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException(
                    "Book ID must be a valid number.", exception
            );
        }
    }

    private int parseCopies(String value) {

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Total copies are required.");
        }

        try {
            int copies = Integer.parseInt(value);

            if (copies < 1) {
                throw new IllegalArgumentException(
                        "Total copies must be at least 1."
                );
            }

            return copies;

        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException(
                    "Total copies must be a valid whole number.", exception
            );
        }
    }
}