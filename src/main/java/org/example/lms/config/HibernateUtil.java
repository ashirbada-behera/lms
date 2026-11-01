
package org.example.lms.config;

import org.example.lms.member.domain.Member;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Centralized Hibernate SessionFactory management.
 *
 * A single SessionFactory is shared across the application.
 * Each database operation must manage its own Session and transaction.
 */
public final class HibernateUtil {

    private static final Logger LOGGER =
            Logger.getLogger(HibernateUtil.class.getName());

    private static final SessionFactory SESSION_FACTORY =
            buildSessionFactory();

    private HibernateUtil() {
        // Prevent instantiation.
    }

    private static SessionFactory buildSessionFactory() {
        String dbPassword = System.getenv("LMS_DB_PASSWORD");

        if (dbPassword == null || dbPassword.isBlank()) {
            throw new IllegalStateException(
                    "The LMS_DB_PASSWORD environment variable is not configured."
            );
        }

        try {
            return new Configuration()
                    .configure("hibernate.cfg.xml")
                    .setProperty("hibernate.connection.password", dbPassword)
                    .addAnnotatedClass(Member.class)
                    .buildSessionFactory();

        } catch (RuntimeException exception) {
            LOGGER.log(
                    Level.SEVERE,
                    "Failed to initialize the Hibernate SessionFactory.",
                    exception
            );

            throw exception;

        } catch (Exception exception) {
            LOGGER.log(
                    Level.SEVERE,
                    "Failed to initialize the Hibernate SessionFactory.",
                    exception
            );

            throw new ExceptionInInitializerError(exception);
        }
    }

    /**
     * Returns the shared Hibernate SessionFactory.
     *
     * @return initialized SessionFactory
     */
    public static SessionFactory getSessionFactory() {
        if (SESSION_FACTORY.isClosed()) {
            throw new IllegalStateException(
                    "The Hibernate SessionFactory has already been closed."
            );
        }

        return SESSION_FACTORY;
    }

    /**
     * Closes the shared SessionFactory during application shutdown.
     */
    public static void shutdown() {
        if (!SESSION_FACTORY.isClosed()) {
            SESSION_FACTORY.close();
            LOGGER.info("Hibernate SessionFactory closed.");
        }
    }
}
