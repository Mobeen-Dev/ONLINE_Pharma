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

    public String getImageUrl() {
        return "https://plus.unsplash.com/premium_photo-1668487826871-2f2cac23ad56?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWVkaWNpbmV8ZW58MHx8MHx8fDA%3D";
    }
}
