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
import java.sql.SQLException;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DatabaseConnection.getConnection();
            System.out.println("Koneksi ke database berhasil!");
            conn.close();
        } catch (SQLException e) {
            System.err.println("Gagal koneksi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
