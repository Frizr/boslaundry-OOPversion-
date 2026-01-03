/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

/**
 *
 * @author ASUS
 */

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DatabaseConnection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username dan password harus diisi!");
            request.getRequestDispatcher("/views/index.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT id, username, role FROM users WHERE username = ? AND password = MD5(?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");
                if ("admin".equals(role)) {
                    response.sendRedirect("login");
                } else if ("karyawan".equals(role)) {
                    response.sendRedirect("orders");
                } else {
                    request.setAttribute("error", "Role tidak valid: " + role);
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }

            } else {
                request.setAttribute("error", "Username atau password salah!");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            String msg = e.getMessage();
            String userMsg = "Terjadi kesalahan server.";
            if (msg != null) {
                if (msg.contains("Unknown database"))
                    userMsg = "Database 'poslaundry' belum dibuat!";
                else if (msg.contains("Access denied"))
                    userMsg = "Akses MySQL ditolak!";
                else if (msg.contains("Unknown column"))
                    userMsg = "Struktur tabel users salah!";
            }
            request.setAttribute("error", userMsg);
            request.getRequestDispatcher("/views/index.jsp").forward(request, response);
        }
    }
}