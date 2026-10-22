package org.example.lms.book.service;

import org.example.lms.book.domain.Book;
import org.example.lms.book.repository.BookRepository;
import org.example.lms.book.repository.BookRepositoryImpl;

import java.util.List;
import java.util.Objects;

public class BookServiceImpl implements BookService {

    private final BookRepository bookRepository;

    public BookServiceImpl() {
        this(new BookRepositoryImpl());
    }

    public BookServiceImpl(BookRepository bookRepository) {
        this.bookRepository = Objects.requireNonNull(
                bookRepository,
                "Book repository is required"
        );
    }

    @Override
    public Book addBook(Book book) {
        Objects.requireNonNull(book, "Book is required");

        String isbn = book.getIsbn().trim();

        if (bookRepository.findByIsbn(isbn).isPresent()) {
            throw new IllegalArgumentException(
                    "A book with this ISBN already exists."
            );
        }

        return bookRepository.save(book);
    }

    @Override
    public Book getBookById(Long id) {
        requireId(id);

        return bookRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Book not found with ID: " + id
                ));
    }

    @Override
    public Book getBookByIsbn(String isbn) {
        if (isbn == null || isbn.isBlank()) {
            throw new IllegalArgumentException("ISBN is required.");
        }

        String cleanedIsbn = isbn.trim();

        return bookRepository.findByIsbn(cleanedIsbn)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Book not found with ISBN: " + cleanedIsbn
                ));
    }

    @Override
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    @Override
    public List<Book> searchBooks(String keyword) {
        return bookRepository.search(keyword);
    }

    @Override
    public Book updateBook(Long id, Book updatedBook) {
        requireId(id);
        Objects.requireNonNull(updatedBook, "Updated book is required");

        Book existingBook = getBookById(id);

        String updatedIsbn = updatedBook.getIsbn().trim();

        bookRepository.findByIsbn(updatedIsbn)
                .filter(book -> !book.getId().equals(id))
                .ifPresent(book -> {
                    throw new IllegalArgumentException(
                            "Another book already uses this ISBN."
                    );
                });

        existingBook.setIsbn(updatedIsbn);
        existingBook.setTitle(updatedBook.getTitle());
        existingBook.setAuthor(updatedBook.getAuthor());
        existingBook.setCategory(updatedBook.getCategory());

        // Preserve the real available-copy count.
        // The entity validates the new total against this count.
        existingBook.setTotalCopies(updatedBook.getTotalCopies());

        return bookRepository.update(existingBook);
    }

    @Override
    public boolean deleteBook(Long id) {
        requireId(id);

        // Verify that the book exists before requesting deletion.
        getBookById(id);

        // Repository-level protection against issue-record references
        // must be implemented before production use.
        return bookRepository.deleteById(id);
    }

    private void requireId(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "A valid book ID is required."
            );
        }
    }
}
