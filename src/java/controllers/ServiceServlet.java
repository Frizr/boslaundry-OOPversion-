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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DatabaseConnection;

@WebServlet(urlPatterns = { "/services", "/add_service" })
public class ServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cek permission
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        String path = request.getServletPath();

        if ("/add_service".equals(path)) {
            request.getRequestDispatcher("/views/add_service.jsp").forward(request, response);
        } else if ("/services".equals(path)) {
            String action = request.getParameter("action");
            if ("delete".equals(action)) {
                deleteService(request, response);
            } else {
                request.getRequestDispatcher("/views/services.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cek permission
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addService(request, response);
        } else if ("edit".equals(action)) {
            editService(request, response);
        } else if ("delete".equals(action)) {
            deleteService(request, response);
        }
    }

    private void addService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO services (name, price, description) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setDouble(2, price);
            stmt.setString(3, description);
            stmt.executeUpdate();

            request.getRequestDispatcher("/views/services.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Gagal menambah layanan.");
            request.getRequestDispatcher("/views/add_service.jsp").forward(request, response);
        }
    }

    private void editService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE services SET name = ?, price = ?, description = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setDouble(2, price);
            stmt.setString(3, description);
            stmt.setInt(4, id);
            stmt.executeUpdate();

            request.getRequestDispatcher("/views/services.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Gagal mengupdate layanan.");

            request.getRequestDispatcher("/views/edit_service.jsp").forward(request, response);
        }
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "DELETE FROM services WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/services");
    }
}