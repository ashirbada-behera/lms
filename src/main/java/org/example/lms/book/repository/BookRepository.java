package org.example.lms.book.repository;

import org.example.lms.book.domain.Book;

import java.util.List;
import java.util.Optional;

/**
 * Defines database operations for the Book entity.
 */
public interface BookRepository {

    Book save(Book book);

    Optional<Book> findById(Long id);

    Optional<Book> findByIsbn(String isbn);

    List<Book> findAll();

    List<Book> search(String keyword);

    Book update(Book book);

    boolean deleteById(Long id);
}
