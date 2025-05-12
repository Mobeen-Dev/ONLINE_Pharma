package com.pharmacy.dao;

import com.pharmacy.model.Medicine;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {
    private Connection connection;

    public MedicineDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pharmacy?useSSL=false&serverTimezone=UTC",
                    "root","123456789"
            );
        } catch (Exception e) {
            throw new RuntimeException("DB init failed", e);
        }
    }

    public boolean updateStock(int id, int newStock) throws SQLException {
        String sql = "UPDATE medicine SET stock = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newStock);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        }
    }

    public Medicine getById(int id) throws SQLException {
        String sql = "SELECT id, name, manufacturer, sku, price, stock "
                + "FROM medicine WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM medicine";
        try (Statement st = connection.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    public boolean existsBySku(String sku) throws SQLException {
        String sql = "SELECT 1 FROM medicine WHERE sku=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sku);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean existsByName(String name) throws SQLException {
        String sql = "SELECT 1 FROM medicine WHERE name=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean addMedicine(Medicine m) throws SQLException {
        String sql = "INSERT INTO medicine(name,manufacturer,sku,price,stock) VALUES(?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, m.getName());
            ps.setString(2, m.getManufacturer());
            ps.setString(3, m.getSku());
            ps.setBigDecimal(4, m.getPrice());
            ps.setInt(5, m.getStock());
            return ps.executeUpdate() == 1;
        }
    }

    public boolean deleteBySku(String sku) throws SQLException {
        String sql = "DELETE FROM medicine WHERE sku=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sku);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteByName(String name) throws SQLException {
        String sql = "DELETE FROM medicine WHERE name=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateMedicineBySku(String oldSku,
                                       String newSku,
                                       BigDecimal newPrice,
                                       int newStock) throws SQLException {
        String sql = "UPDATE medicine SET sku=?, price=?, stock=? WHERE sku=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newSku);
            ps.setBigDecimal(2, newPrice);
            ps.setInt(3, newStock);
            ps.setString(4, oldSku);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateMedicineByName(String oldName,
                                        String newSku,
                                        BigDecimal newPrice,
                                        int newStock) throws SQLException {
        String sql = "UPDATE medicine SET sku=?, price=?, stock=? WHERE name=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newSku);
            ps.setBigDecimal(2, newPrice);
            ps.setInt(3, newStock);
            ps.setString(4, oldName);
            return ps.executeUpdate() == 1;
        }
    }

    private Medicine mapRow(ResultSet rs) throws SQLException {
        return new Medicine(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("manufacturer"),
                rs.getString("sku"),
                rs.getBigDecimal("price"),
                rs.getInt("stock")
        );
    }
}
