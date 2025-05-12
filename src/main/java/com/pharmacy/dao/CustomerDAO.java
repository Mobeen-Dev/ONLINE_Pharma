package com.pharmacy.dao;

import com.pharmacy.model.Customer;

import java.sql.*;
import java.math.BigDecimal;

public class CustomerDAO {
    private Connection connection;

    public CustomerDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pharmacy?useSSL=false&serverTimezone=UTC",
                    "root",
                    "123456789"
            );
        } catch (Exception e) {
            throw new RuntimeException("Failed to init CustomerDAO", e);
        }
    }

    /** Fetch by primary key (existing) */
    public Customer getById(int customerId) throws SQLException {
        String sql = """
            SELECT customer_id, username, password_hash,
                   first_name, last_name,
                   primary_contact, secondary_contact, address,
                   is_admin, total_purchase_worth
              FROM customers WHERE customer_id = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    /** Lookup by username (for login) */
    public Customer findByUsername(String username) throws SQLException {
        String sql = """
            SELECT customer_id, username, password_hash,
                   first_name, last_name,
                   primary_contact, secondary_contact, address,
                   is_admin, total_purchase_worth
              FROM customers WHERE username = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    /** Create a new customer (signup) */
    public int createCustomer(String username,
                              String passwordHash,
                              String firstName,
                              String lastName,
                              String primaryContact,
                              String address) throws SQLException {
        String sql = """
            INSERT INTO customers
              (username, password_hash,
               first_name, last_name,
               primary_contact, address)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (PreparedStatement ps =
                     connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, passwordHash);
            ps.setString(3, firstName);
            ps.setString(4, lastName);
            ps.setString(5, primaryContact);
            ps.setString(6, address);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
                throw new SQLException("Creating customer failed, no ID obtained.");
            }
        }
    }

    /** Update contact & address (existing) */
    public boolean updateContactAndAddress(int customerId,
                                           String newPhone,
                                           String newAddress) throws SQLException {
        String sql = "UPDATE customers SET primary_contact=?, address=? WHERE customer_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPhone);
            ps.setString(2, newAddress);
            ps.setInt(3, customerId);
            return ps.executeUpdate() == 1;
        }
    }

    /** Helper to map a ResultSet row to Customer */
    private Customer mapRow(ResultSet rs) throws SQLException {
        return new Customer(
                rs.getInt("customer_id"),
                rs.getString("username"),
                rs.getString("password_hash"),
                rs.getString("first_name"),
                rs.getString("last_name"),
                rs.getString("primary_contact"),
                rs.getString("secondary_contact"),
                rs.getString("address"),
                rs.getBoolean("is_admin"),
                rs.getBigDecimal("total_purchase_worth")
        );
    }
}
