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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.DatabaseConnection;

@WebServlet(urlPatterns = { "/new_order", "/orders" })
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/new_order".equals(path)) {
            request.getRequestDispatcher("/views/new_order.jsp").forward(request, response);
        } else if ("/orders".equals(path)) {
            String action = request.getParameter("action");
            if ("cancel".equals(action)) {
                cancelOrder(request, response);
            } else if ("delete".equals(action)) {
                deleteOrder(request, response);
            } else {
                request.getRequestDispatcher("/views/orders.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createOrder(request, response);
        } else if ("cancel".equals(action)) {
            cancelOrder(request, response);
        }
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String employeeIdStr = request.getParameter("employeeId");
        if (employeeIdStr == null || "null".equals(employeeIdStr) || employeeIdStr.isEmpty()) {
            request.setAttribute("error", "Sesi anda telah berakhir. Silakan login kembali.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        int employeeId = Integer.parseInt(employeeIdStr);
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String customerAddress = request.getParameter("customerAddress");
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        int customerId = 0;

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sqlCustomer = "INSERT INTO customers (name, phone, address) VALUES (?, ?, ?)";
            PreparedStatement stmtCustomer = conn.prepareStatement(sqlCustomer, Statement.RETURN_GENERATED_KEYS);
            stmtCustomer.setString(1, customerName);
            stmtCustomer.setString(2, customerPhone);
            stmtCustomer.setString(3, customerAddress);
            stmtCustomer.executeUpdate();

            ResultSet rs = stmtCustomer.getGeneratedKeys();
            if (rs.next()) {
                customerId = rs.getInt(1);
            }

            String sqlOrder = "INSERT INTO orders (customer_id, employee_id, total_amount, status) VALUES (?, ?, ?, 'pending')";
            PreparedStatement stmtOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            stmtOrder.setInt(1, customerId);
            stmtOrder.setInt(2, employeeId);
            stmtOrder.setDouble(3, totalAmount);
            stmtOrder.executeUpdate();

            ResultSet rsOrder = stmtOrder.getGeneratedKeys();
            int orderId = 0;
            if (rsOrder.next()) {
                orderId = rsOrder.getInt(1);
            }

            String[] serviceIds = request.getParameterValues("serviceId[]");
            String[] quantities = request.getParameterValues("quantity[]");

            for (int i = 0; i < serviceIds.length; i++) {
                int serviceId = Integer.parseInt(serviceIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                double price = getServicePrice(serviceId);
                double subtotal = price * quantity;

                String sqlItem = "INSERT INTO order_items (order_id, service_id, quantity, subtotal) VALUES (?, ?, ?, ?)";
                PreparedStatement stmtItem = conn.prepareStatement(sqlItem);
                stmtItem.setInt(1, orderId);
                stmtItem.setInt(2, serviceId);
                stmtItem.setInt(3, quantity);
                stmtItem.setDouble(4, subtotal);
                stmtItem.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/payment?orderId=" + orderId);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Gagal membuat pesanan.");
            request.getRequestDispatcher("/views/new_order.jsp").forward(request, response);
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "UPDATE orders SET status = 'cancelled' WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Hapus item pesanan terlebih dahulu (jika tidak ada CASCADE DELETE)
            String sqlItems = "DELETE FROM order_items WHERE order_id = ?";
            PreparedStatement stmtItems = conn.prepareStatement(sqlItems);
            stmtItems.setInt(1, orderId);
            stmtItems.executeUpdate();

            // Hapus payments terkait (jika ada)
            String sqlPayment = "DELETE FROM payments WHERE order_id = ?";
            PreparedStatement stmtPayment = conn.prepareStatement(sqlPayment);
            stmtPayment.setInt(1, orderId);
            stmtPayment.executeUpdate();

            // Hapus pesanan
            String sqlOrder = "DELETE FROM orders WHERE id = ?";
            PreparedStatement stmtOrder = conn.prepareStatement(sqlOrder);
            stmtOrder.setInt(1, orderId);
            stmtOrder.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/orders");
    }

    private double getServicePrice(int serviceId) {
        double price = 0;
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "SELECT price FROM services WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                price = rs.getDouble("price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return price;
    }
}