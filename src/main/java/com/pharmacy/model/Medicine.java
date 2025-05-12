package com.pharmacy.model;

import java.math.BigDecimal;

public class Medicine {
    private int id;
    private String name;
    private String manufacturer;
    private String sku;
    private BigDecimal price;
    private int stock;

    public Medicine(int id, String name, String manufacturer,
                    String sku, BigDecimal price, int stock) {
        this.id = id;
        this.name = name;
        this.manufacturer = manufacturer;
        this.sku = sku;
        this.price = price;
        this.stock = stock;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getManufacturer() { return manufacturer; }
    public String getSku() { return sku; }
    public BigDecimal getPrice() { return price; }
    public int getStock() { return stock; }
}
