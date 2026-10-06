package com.quantix.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static String value(String primary, String secondary, String fallback) {
        String setting = System.getenv(primary);
        if (setting == null || setting.trim().isEmpty()) setting = System.getenv(secondary);
        return (setting == null || setting.trim().isEmpty()) ? fallback : setting.trim();
    }

    private static String databaseUrl() {
        String url = System.getenv("DB_URL");
        if (url != null && !url.trim().isEmpty()) return url.trim();

        String host = value("DB_HOST", "MYSQLHOST", "localhost");
        String port = value("DB_PORT", "MYSQLPORT", "3306");
        String database = value("DB_NAME", "MYSQLDATABASE", "quantix_db");
        return "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false&serverTimezone=UTC";
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found.", e);
        }

        String user = value("DB_USER", "MYSQLUSER", "root");
        String password = value("DB_PASSWORD", "MYSQLPASSWORD", null);
        if (password == null) {
            throw new SQLException("Database password is missing. Set DB_PASSWORD or MYSQLPASSWORD.");
        }
        return DriverManager.getConnection(databaseUrl(), user, password);
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) System.out.println("Database connection successful.");
        } catch (SQLException e) {
            System.out.println("Database connection failed: " + e.getMessage());
        }
    }
}
