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

public class OrderItem implements Serializable {
    private long id;
    private long orderId;
    private long serviceId;
    private String serviceName;
    private double weight;
    private double price;

    public OrderItem() {}

    // Getters and Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }
    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }
    public long getServiceId() { return serviceId; }
    public void setServiceId(long serviceId) { this.serviceId = serviceId; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
