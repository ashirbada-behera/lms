package org.example.lms.book.service;

import org.example.lms.book.domain.Book;

import java.util.List;
import java.util.Optional;

/**
 * Defines business operations for book management.
 */
public interface BookService {

    Book addBook(Book book);

    Book getBookById(Long id);

    Book getBookByIsbn(String isbn);

    List<Book> getAllBooks();

    List<Book> searchBooks(String keyword);

    Book updateBook(Long id, Book updatedBook);

    boolean deleteBook(Long id);
}
