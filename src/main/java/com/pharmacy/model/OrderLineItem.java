package com.pharmacy.model;

import java.math.BigDecimal;

public class OrderLineItem {
    private int orderItemId;
    private int orderId;
    private int medicineId;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;  // quantity * unitPrice

    public OrderLineItem(int orderItemId,
                         int orderId,
                         int medicineId,
                         int quantity,
                         BigDecimal unitPrice,
                         BigDecimal totalPrice) {
        this.orderItemId = orderItemId;
        this.orderId     = orderId;
        this.medicineId  = medicineId;
        this.quantity    = quantity;
        this.unitPrice   = unitPrice;
        this.totalPrice  = totalPrice;
    }

    public int getOrderItemId() { return orderItemId; }
    public int getOrderId() { return orderId; }
    public int getMedicineId() { return medicineId; }
    public int getQuantity() { return quantity; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public BigDecimal getTotalPrice() { return totalPrice; }
}
