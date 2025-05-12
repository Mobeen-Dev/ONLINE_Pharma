package com.pharmacy.dao;
import java.util.ArrayList;
import java.util.List;
import com.pharmacy.model.OrderLineItem;

import java.math.BigDecimal;
import java.sql.*;
import com.pharmacy.model.Order;
import com.pharmacy.model.OrderLineItem;
import java.time.LocalDateTime;

public class OrderDAO {
    private final String url  = "jdbc:mysql://localhost:3306/pharmacy?useSSL=false&serverTimezone=UTC";
    private final String user = "root";
    private final String pass = "123456789";

    /** Single connection for transactional work */
    public Connection getConnection() throws SQLException {
        Connection conn = DriverManager.getConnection(url, user, pass);
        conn.setAutoCommit(true);
        return conn;
    }

    /** Inserts an order row; returns generated order_id */
    public int createOrder(Connection conn,
                           int customerId,
                           int totalItems,
                           BigDecimal totalPrice) throws SQLException {
        String sql = """
            INSERT INTO orders(customer_id, total_items, total_price)
            VALUES (?,?,?)
            """;
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerId);
            ps.setInt(2, totalItems);
            ps.setBigDecimal(3, totalPrice);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
                throw new SQLException("Creating order failed, no ID obtained.");
            }
        }
    }

    /**
     * Returns a list of Order objects for the given customerId.
     */
    public List<Order> getOrdersByCustomer(int customerId) throws SQLException {
        String sql = """
            SELECT order_id, customer_id, total_items, total_price, order_timestamp
              FROM orders
             WHERE customer_id = ?
             ORDER BY order_timestamp DESC
            """;
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(new Order(
                            rs.getInt("order_id"),
                            rs.getInt("customer_id"),
                            rs.getInt("total_items"),
                            rs.getBigDecimal("total_price"),
                            rs.getTimestamp("order_timestamp")
                                    .toLocalDateTime()
                    ));
                }
            }
        }
        return orders;
    }

    /** Inserts a line-item row */
    public void addLineItem(Connection conn,
                            int orderId,
                            int medicineId,
                            int quantity,
                            BigDecimal unitPrice) throws SQLException {
        String sql = """
            INSERT INTO order_line_items
              (order_id, medicine_id, quantity, unit_price)
            VALUES (?,?,?,?)
            """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity);
            ps.setBigDecimal(4, unitPrice);
            ps.executeUpdate();
        }
    }

    /** Fetch an order (including its timestamp) */
    public Order getOrderById(int orderId) throws SQLException {
        String sql = """
            SELECT order_id, customer_id, total_items, total_price, order_timestamp
              FROM orders WHERE order_id = ?
            """;
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return new Order(
                        rs.getInt("order_id"),
                        rs.getInt("customer_id"),
                        rs.getInt("total_items"),
                        rs.getBigDecimal("total_price"),
                        rs.getTimestamp("order_timestamp")
                                .toLocalDateTime()
                );
            }
        }
    }

    /** Fetch all line-items for a given order */
    public List<OrderLineItem> getLineItems(int orderId) throws SQLException {
        String sql = """
            SELECT order_item_id, order_id, medicine_id,
                   quantity, unit_price, total_price
              FROM order_line_items
             WHERE order_id = ?
            """;
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                List<OrderLineItem> items = new ArrayList<>();
                while (rs.next()) {
                    items.add(new OrderLineItem(
                            rs.getInt("order_item_id"),
                            rs.getInt("order_id"),
                            rs.getInt("medicine_id"),
                            rs.getInt("quantity"),
                            rs.getBigDecimal("unit_price"),
                            rs.getBigDecimal("total_price")
                    ));
                }
                return items;
            }
        }
    }
}
