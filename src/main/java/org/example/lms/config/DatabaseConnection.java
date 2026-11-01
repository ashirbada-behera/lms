
package org.example.lms.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/lms"
                    + "?useSSL=false"
                    + "&serverTimezone=Asia/Kolkata"
                    + "&allowPublicKeyRetrieval=true"
                    + "&characterEncoding=UTF-8";

    private DatabaseConnection() {
    }

    public static Connection getConnection() throws SQLException {

        String username = System.getenv("LMS_DB_USER");
        String password = System.getenv("LMS_DB_PASSWORD");

        if (username == null || username.isBlank()) {
            username = "root";
        }

        if (password == null || password.isBlank()) {
            throw new SQLException(
                    "LMS_DB_PASSWORD is missing from Tomcat environment variables."
            );
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException exception) {
            throw new SQLException(
                    "MySQL Connector/J driver is missing from the application.",
                    exception
            );
        }

        return DriverManager.getConnection(URL, username, password);
    }
}
