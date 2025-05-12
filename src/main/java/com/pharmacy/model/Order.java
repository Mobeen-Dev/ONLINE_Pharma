package com.pharmacy.model;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class Order {
    private int orderId;
    private int customerId;
    private int totalItems;
    private BigDecimal totalPrice;
    private LocalDateTime orderTimestamp;

    public Order(int orderId,
                 int customerId,
                 int totalItems,
                 BigDecimal totalPrice,
                 LocalDateTime orderTimestamp) {
        this.orderId        = orderId;
        this.customerId     = customerId;
        this.totalItems     = totalItems;
        this.totalPrice     = totalPrice;
        this.orderTimestamp = orderTimestamp;
    }

    public int getOrderId() { return orderId; }
    public int getCustomerId() { return customerId; }
    public int getTotalItems() { return totalItems; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public LocalDateTime getOrderTimestamp() { return orderTimestamp; }
}
