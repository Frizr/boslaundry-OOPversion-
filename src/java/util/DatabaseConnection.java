/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author ASUS
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // ✅ Untuk MySQL 8+, tambahkan parameter berikut:
    private static final String URL = 
        "jdbc:mysql://localhost:3306/poslaundry?" +
        "useSSL=false&" +
        "allowPublicKeyRetrieval=true&" +
        "serverTimezone=UTC";

    private static final String USERNAME = "root";
    private static final String PASSWORD = ""; // atau "root" tergantung setup

    static {
        try {
            // ✅ Muat driver secara eksplisit (untuk kompatibilitas)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver tidak ditemukan!", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}