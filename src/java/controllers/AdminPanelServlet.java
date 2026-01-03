/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.DatabaseConnection;

/**
 *
 * @author BossLaundry Team
 */
@WebServlet(name = "AdminPanelServlet", urlPatterns = { "/admin-panel" })
public class AdminPanelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Cek permission
        String role = (String) session.getAttribute("role");
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {

            // 1. Fetch Stats
            fetchStats(conn, request);

            // 2. Fetch Users
            fetchUsers(conn, request);

            // 3. Fetch Orders
            fetchOrders(conn, request);

            request.getRequestDispatcher("/views/admin_panel.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("/views/admin_panel.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try (Connection conn = DatabaseConnection.getConnection()) {
            if ("changeRole".equals(action)) {
                handleChangeRole(conn, request);
            } else if ("changeStatus".equals(action)) {
                handleChangeStatus(conn, request);
            } else if ("deleteOrder".equals(action)) {
                handleDeleteOrder(conn, request);
            } else if ("resetPassword".equals(action)) {
                handleResetPassword(conn, request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Action Failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin-panel");
    }

    private void fetchStats(Connection conn, HttpServletRequest request) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();

        stats.put("totalUsers", getCount(conn, "SELECT COUNT(*) FROM users"));
        stats.put("totalOrders", getCount(conn, "SELECT COUNT(*) FROM orders"));
        stats.put("pendingOrders", getCount(conn, "SELECT COUNT(*) FROM orders WHERE status = 'pending'"));
        stats.put("completedOrders", getCount(conn, "SELECT COUNT(*) FROM orders WHERE status IN ('done', 'paid')"));

        request.setAttribute("stats", stats);
    }

    private int getCount(Connection conn, String sql) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private void fetchUsers(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, Object>> users = new ArrayList<>();
        String sql = "SELECT u.id, u.username, u.role, " +
                "(SELECT COUNT(*) FROM orders WHERE employee_id = u.id) as order_count " +
                "FROM users u";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getInt("id"));
                user.put("username", rs.getString("username"));
                user.put("role", rs.getString("role"));
                user.put("orderCount", rs.getInt("order_count"));
                // Since created_at might not exist in users table based on LoginServlet check,
                // we'll omit it or simulate it if needed.
                // For now let's assume valid data or just show '-' if simpler.

                users.add(user);
            }
        }
        request.setAttribute("userList", users);
    }

    private void fetchOrders(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, Object>> orders = new ArrayList<>();
        String sql = "SELECT o.id, o.customer_id, o.employee_id, o.total_amount, o.status, o.created_at, " +
                "c.name as customer_name, c.phone as customer_phone, " +
                "u.username as employee_name, u.role as employee_role " +
                "FROM orders o " +
                "LEFT JOIN customers c ON o.customer_id = c.id " +
                "LEFT JOIN users u ON o.employee_id = u.id " +
                "ORDER BY o.created_at DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("id", rs.getInt("id"));
                order.put("customerName", rs.getString("customer_name"));
                order.put("customerPhone", rs.getString("customer_phone"));
                order.put("employeeName", rs.getString("employee_name"));
                order.put("employeeRole", rs.getString("employee_role"));
                order.put("totalAmount", rs.getDouble("total_amount"));
                order.put("status", rs.getString("status"));
                order.put("date", rs.getTimestamp("created_at"));

                orders.add(order);
            }
        }
        request.setAttribute("orderList", orders);
    }

    private void handleChangeRole(Connection conn, HttpServletRequest request) throws SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newRole = request.getParameter("role");

        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    private void handleChangeStatus(Connection conn, HttpServletRequest request) throws SQLException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("status");

        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        }
    }

    private void handleDeleteOrder(Connection conn, HttpServletRequest request) throws SQLException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        // Manual Cascade Delete

        // 1. Delete Order Items
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM order_items WHERE order_id = ?")) {
            stmt.setInt(1, orderId);
            stmt.executeUpdate();
        }

        // 2. Delete Payments
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM payments WHERE order_id = ?")) {
            stmt.setInt(1, orderId);
            stmt.executeUpdate();
        }

        // 3. Delete Order
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM orders WHERE id = ?")) {
            stmt.setInt(1, orderId);
            stmt.executeUpdate();
        }
    }

    private void handleResetPassword(Connection conn, HttpServletRequest request) throws SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newPassword = request.getParameter("password");

        String sql = "UPDATE users SET password = MD5(?) WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }
}
