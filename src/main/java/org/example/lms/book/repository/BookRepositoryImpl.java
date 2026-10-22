package org.example.lms.book.repository;

import org.example.lms.book.domain.Book;
import org.example.lms.config.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.Optional;

public class BookRepositoryImpl implements BookRepository {

    @Override
    public Book save(Book book) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();
            session.persist(book);
            transaction.commit();

            return book;

        } catch (RuntimeException exception) {
            rollback(transaction);
            throw exception;
        }
    }

    @Override
    public Optional<Book> findById(Long id) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return Optional.ofNullable(session.get(Book.class, id));
        }
    }

    @Override
    public Optional<Book> findByIsbn(String isbn) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Book book = session.createQuery(
                            "FROM Book b WHERE b.isbn = :isbn",
                            Book.class
                    )
                    .setParameter("isbn", isbn)
                    .uniqueResult();

            return Optional.ofNullable(book);
        }
    }

    @Override
    public List<Book> findAll() {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "FROM Book b ORDER BY b.title",
                    Book.class
            ).getResultList();
        }
    }

    @Override
    public List<Book> search(String keyword) {
        String searchTerm = "%" +
                (keyword == null ? "" : keyword.trim()) + "%";

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                            """
                            FROM Book b
                            WHERE LOWER(b.title) LIKE LOWER(:term)
                               OR LOWER(b.author) LIKE LOWER(:term)
                               OR LOWER(b.isbn) LIKE LOWER(:term)
                               OR LOWER(b.category) LIKE LOWER(:term)
                            ORDER BY b.title
                            """,
                            Book.class
                    )
                    .setParameter("term", searchTerm)
                    .getResultList();
        }
    }

    @Override
    public Book update(Book book) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Book updatedBook = session.merge(book);

            transaction.commit();

            return updatedBook;

        } catch (RuntimeException exception) {
            rollback(transaction);
            throw exception;
        }
    }

    @Override
    public boolean deleteById(Long id) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Book book = session.get(Book.class, id);

            if (book == null) {
                transaction.commit();
                return false;
            }

            session.remove(book);
            transaction.commit();

            return true;

        } catch (RuntimeException exception) {
            rollback(transaction);
            throw exception;
        }
    }

    private void rollback(Transaction transaction) {
        if (transaction != null && transaction.isActive()) {
            try {
                transaction.rollback();
            } catch (RuntimeException rollbackException) {
                System.err.println(
                        "Failed to roll back the Hibernate transaction."
                );
                rollbackException.printStackTrace(System.err);
            }
        }
    }
}
