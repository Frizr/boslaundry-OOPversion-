/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author ASUS
 */
import java.io.Serializable;
import java.sql.Timestamp;

public class Payment implements Serializable {
    private long id;
    private long orderId;
    private double amountPaid;
    private String paymentMethod;
    private Timestamp createdAt;

    public Payment() {}

    public Payment(long orderId, double amountPaid, String paymentMethod) {
        this.orderId = orderId;
        this.amountPaid = amountPaid;
        this.paymentMethod = paymentMethod;
    }

    // Getters and Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }
    public double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(double amountPaid) { this.amountPaid = amountPaid; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}