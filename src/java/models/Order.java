/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author ASUS
 */

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int id;
    private int customerId;
    private int employeeId;
    private BigDecimal totalAmount;
    private String status;
    private Timestamp createdAt;
    
    public Order() {}
    
    public Order(int id, int customerId, int employeeId, BigDecimal totalAmount, String status, Timestamp createdAt) {
        this.id = id;
        this.customerId = customerId;
        this.employeeId = employeeId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    
    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}