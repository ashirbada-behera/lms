package org.example.lms.book.repository;

import org.example.lms.book.domain.Book;
import org.example.lms.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BookRepositoryImpl implements BookRepository {

    @Override
    public Book save(Book book) {

        String sql = """
                INSERT INTO books
                    (isbn, title, author, category, total_copies,
                     available_copies, cover_image_path)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, book.getIsbn());
            statement.setString(2, book.getTitle());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getCategory());
            statement.setInt(5, book.getTotalCopies());
            statement.setInt(6, book.getAvailableCopies());
            statement.setString(7, book.getCoverImagePath());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating book failed; no row inserted.");
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    book.setId(keys.getLong(1));
                } else {
                    throw new SQLException(
                            "Creating book failed; no generated ID returned."
                    );
                }
            }

            return book;

        } catch (SQLException exception) {
            throw new IllegalStateException("Unable to save book.", exception);
        }
    }

    @Override
    public Optional<Book> findById(Long id) {

        String sql = "SELECT * FROM books WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
                return Optional.empty();
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to find book by ID.", exception);
        }
    }

    @Override
    public Optional<Book> findByIsbn(String isbn) {

        String sql = "SELECT * FROM books WHERE isbn = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, isbn);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapRow(resultSet));
                }
                return Optional.empty();
            }

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to find book by ISBN.", exception);
        }
    }

    @Override
    public List<Book> findAll() {

        String sql = "SELECT * FROM books ORDER BY title";
        List<Book> books = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                books.add(mapRow(resultSet));
            }

            return books;

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to retrieve books.", exception);
        }
    }

    @Override
    public List<Book> search(String keyword) {

        String sql = """
                SELECT * FROM books
                WHERE LOWER(title) LIKE LOWER(?)
                   OR LOWER(author) LIKE LOWER(?)
                   OR LOWER(isbn) LIKE LOWER(?)
                   OR LOWER(category) LIKE LOWER(?)
                ORDER BY title
                """;

        String term = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        List<Book> books = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            for (int i = 1; i <= 4; i++) {
                statement.setString(i, term);
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    books.add(mapRow(resultSet));
                }
            }

            return books;

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to search books.", exception);
        }
    }

    @Override
    public Book update(Book book) {

        String sql = """
                UPDATE books
                SET isbn = ?, title = ?, author = ?, category = ?,
                    total_copies = ?, available_copies = ?,
                    cover_image_path = ?
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, book.getIsbn());
            statement.setString(2, book.getTitle());
            statement.setString(3, book.getAuthor());
            statement.setString(4, book.getCategory());
            statement.setInt(5, book.getTotalCopies());
            statement.setInt(6, book.getAvailableCopies());
            statement.setString(7, book.getCoverImagePath());
            statement.setLong(8, book.getId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new IllegalArgumentException(
                        "Book not found with ID: " + book.getId()
                );
            }

            return book;

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to update book.", exception);
        }
    }

    @Override
    public boolean deleteById(Long id) {

        String sql = "DELETE FROM books WHERE id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setLong(1, id);
            return statement.executeUpdate() > 0;

        } catch (SQLException exception) {
            throw new IllegalStateException(
                    "Unable to delete book. It may be referenced by issue records.",
                    exception
            );
        }
    }

    private Book mapRow(ResultSet resultSet) throws SQLException {

        Book book = new Book();

        book.setId(resultSet.getLong("id"));
        book.setIsbn(resultSet.getString("isbn"));
        book.setTitle(resultSet.getString("title"));
        book.setAuthor(resultSet.getString("author"));
        book.setCategory(resultSet.getString("category"));
        book.setTotalCopies(resultSet.getInt("total_copies"));
        book.setAvailableCopies(resultSet.getInt("available_copies"));
        book.setCoverImagePath(resultSet.getString("cover_image_path"));

        return book;
    }
}