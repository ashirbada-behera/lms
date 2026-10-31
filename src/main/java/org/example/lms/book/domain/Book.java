package org.example.lms.book.domain;

import java.util.Objects;

public class Book {

    private Long id;
    private String isbn;
    private String title;
    private String author;
    private String category;
    private int totalCopies;
    private int availableCopies;
    private String coverImagePath;

    // No-argument constructor for JDBC mapping
    public Book() {
    }

    // Constructor for creating a new book
    public Book(
            String isbn,
            String title,
            String author,
            String category,
            int totalCopies
    ) {
        setIsbn(isbn);
        setTitle(title);
        setAuthor(author);
        setCategory(category);
        setTotalCopies(totalCopies);

        this.availableCopies = totalCopies;
    }

    private static String requireText(String value, String fieldName) {
        Objects.requireNonNull(value, fieldName + " is required");

        String cleaned = value.trim();

        if (cleaned.isEmpty()) {
            throw new IllegalArgumentException(
                    fieldName + " cannot be blank"
            );
        }

        return cleaned;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        if (id != null && id <= 0) {
            throw new IllegalArgumentException(
                    "Book ID must be positive."
            );
        }
        this.id = id;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = requireText(isbn, "ISBN");
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = requireText(title, "Title");
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = requireText(author, "Author");
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = requireText(category, "Category");
    }

    public int getTotalCopies() {
        return totalCopies;
    }

    public void setTotalCopies(int totalCopies) {
        if (totalCopies < 1) {
            throw new IllegalArgumentException(
                    "Total copies must be at least 1"
            );
        }

        if (totalCopies < availableCopies) {
            throw new IllegalArgumentException(
                    "Total copies cannot be less than available copies"
            );
        }

        this.totalCopies = totalCopies;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        if (availableCopies < 0 || availableCopies > totalCopies) {
            throw new IllegalArgumentException(
                    "Available copies must be between 0 and total copies"
            );
        }

        this.availableCopies = availableCopies;
    }

    // Book cover image path
    public String getCoverImagePath() {
        return coverImagePath;
    }

    public void setCoverImagePath(String coverImagePath) {
        if (coverImagePath != null && coverImagePath.trim().isEmpty()) {
            this.coverImagePath = null;
        } else {
            this.coverImagePath = coverImagePath;
        }
    }
}
