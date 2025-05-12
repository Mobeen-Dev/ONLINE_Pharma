package com.pharmacy.model;

import java.math.BigDecimal;

public class Customer {
    private int customerId;
    private String username;
    private String passwordHash;
    private String firstName;
    private String lastName;
    private String primaryContact;
    private String secondaryContact;
    private String address;
    private boolean isAdmin;
    private BigDecimal totalPurchaseWorth;

    public Customer(int customerId,
                    String username,
                    String passwordHash,
                    String firstName,
                    String lastName,
                    String primaryContact,
                    String secondaryContact,
                    String address,
                    boolean isAdmin,
                    BigDecimal totalPurchaseWorth) {
        this.customerId         = customerId;
        this.username           = username;
        this.passwordHash       = passwordHash;
        this.firstName          = firstName;
        this.lastName           = lastName;
        this.primaryContact     = primaryContact;
        this.secondaryContact   = secondaryContact;
        this.address            = address;
        this.isAdmin            = isAdmin;
        this.totalPurchaseWorth = totalPurchaseWorth;
    }

    // getters...
    public int getCustomerId()       { return customerId; }
    public String getUsername()      { return username; }
    public String getPasswordHash()  { return passwordHash; }
    public String getFirstName()     { return firstName; }
    public String getLastName()      { return lastName; }
    public String getPrimaryContact(){ return primaryContact; }
    public String getSecondaryContact(){ return secondaryContact; }
    public String getAddress()       { return address; }
    public boolean isAdmin()         { return isAdmin; }
    public BigDecimal getTotalPurchaseWorth() { return totalPurchaseWorth; }
}
