package org.example.lms.book.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;

import java.util.Objects;

@Entity
@Table(
        name = "books",
        indexes = {
                @Index(name = "idx_books_title", columnList = "title"),
                @Index(name = "idx_books_author", columnList = "author"),
                @Index(name = "idx_books_category", columnList = "category")
        }
)
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "isbn", nullable = false, unique = true, length = 20)
    private String isbn;

    @Column(name = "title", nullable = false, length = 200)
    private String title;

    @Column(name = "author", nullable = false, length = 150)
    private String author;

    @Column(name = "category", nullable = false, length = 100)
    private String category;

    @Column(name = "total_copies", nullable = false)
    private int totalCopies;

    @Column(name = "available_copies", nullable = false)
    private int availableCopies;

    // Required by Hibernate
    protected Book() {
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
}