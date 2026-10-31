package org.example.lms.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        String url = getConfig(
                "LMS_DB_URL",
                "jdbc:mysql://localhost:3306/library"
        );

        String username = getConfig("LMS_DB_USER", "root");
        String password = getConfig("LMS_DB_PASSWORD", null);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC driver is missing from the application runtime.",
                    e
            );
        }

        return DriverManager.getConnection(url, username, password);
    }

    private static String getConfig(String key, String defaultValue) {
        String value = System.getProperty(key);

        if (value == null || value.isBlank()) {
            value = System.getenv(key);
        }

        if (value == null || value.isBlank()) {
            value = defaultValue;
        }

        if (value == null || value.isBlank()) {
            throw new IllegalStateException(
                    "Missing database configuration: " + key
                            + ". Set it as an environment variable or JVM property."
            );
        }

        return value.trim();
    }
}
