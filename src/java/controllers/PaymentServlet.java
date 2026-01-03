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
import util.DatabaseConnection;

@WebServlet(name = "PaymentServlet", urlPatterns = { "/payment" })
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }
        request.getRequestDispatcher("/views/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("pay".equals(action)) {
            processPayment(request, response);
        }
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentMethod = request.getParameter("paymentMethod");

        try (Connection conn = DatabaseConnection.getConnection()) {
            // Update status pesanan
            String sqlOrder = "UPDATE orders SET status = 'paid' WHERE id = ?";
            PreparedStatement stmtOrder = conn.prepareStatement(sqlOrder);
            stmtOrder.setInt(1, orderId);
            stmtOrder.executeUpdate();

            // Simpan pembayaran
            String sqlPayment = "INSERT INTO payments (order_id, amount, payment_method) VALUES (?, ?, ?)";
            PreparedStatement stmtPayment = conn.prepareStatement(sqlPayment);
            stmtPayment.setInt(1, orderId);
            stmtPayment.setDouble(2, amount);
            stmtPayment.setString(3, paymentMethod);
            stmtPayment.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/orders");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Gagal memproses pembayaran.");
            request.getRequestDispatcher("payment.jsp?orderId=" + orderId).forward(request, response);
        }
    }
}