package com.pharmacy.servlet;
import java.sql.Connection;
import java.sql.SQLException;

import com.pharmacy.dao.*;
import com.pharmacy.model.*;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;

public class PlaceOrderServlet extends HttpServlet {
    private MedicineDAO medDao;
    private CustomerDAO custDao;
    private OrderDAO orderDao;

    @Override
    public void init() {
        medDao   = new MedicineDAO();
        custDao  = new CustomerDAO();
        orderDao = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // 1) Try session
        HttpSession session = req.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        // 2) Fallback to cookie if needed
        if (customerId == null) {
            if (req.getCookies() != null) {
                for (Cookie c : req.getCookies()) {
                    if ("customerId".equals(c.getName())) {
                        try {
                            customerId = Integer.valueOf(c.getValue());
                            session.setAttribute("customerId", customerId);
                        } catch (NumberFormatException ignored) {}
                        break;
                    }
                }
            }
        }

        // 3) If still missing, send to login
        if (customerId == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 4) Load medicines & the customer
        try {
            req.setAttribute("medicines", medDao.getAllMedicines());
            Customer c = custDao.getById(customerId);
            req.setAttribute("customer", c);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/WEB-INF/order.jsp")
                .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        // 1) Determine customer (default to ID=1)
        HttpSession session = req.getSession();
        Integer cid = (Integer) session.getAttribute("customerId");
        if (cid == null) {
            cid = 1;
            session.setAttribute("customerId", 1);
        }

        // 2) Update contact & address (optional)
        String phone   = req.getParameter("phone").trim();
        String address = req.getParameter("address").trim();
        System.out.println("DEBUG: phone = " + phone);
        System.out.println("DEBUG: Address = " + address);
        try {
            custDao.updateContactAndAddress(cid, phone, address);
        } catch (SQLException e) {
            System.out.println("DEBUG: Error in updating contact and address ");

            throw new ServletException("Failed to update customer info", e);

        }
        Map<String,String[]> paramMap = req.getParameterMap();
        // 3) Build qtyMap from request parameters
        Map<Integer,Integer> qtyMap = new LinkedHashMap<>();
        req.getParameterMap().forEach((key, values) -> {
            if (key.startsWith("qty_")) {
                try {
                    int medId = Integer.parseInt(key.substring(4));
                    int qty   = Integer.parseInt(values[0].trim());
                    qtyMap.put(medId, qty);
                } catch (NumberFormatException ignored) { }
            }
        });


        // 4) Validate quantities against stock
        List<String> errors = new ArrayList<>();
        Iterator<Map.Entry<Integer,Integer>> it = qtyMap.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<Integer,Integer> e = it.next();
            int medId = e.getKey(), qty = e.getValue();
            if (qty < 1) {
                errors.add("Quantity for medicine #" + medId + " must be ≥ 1.");
                it.remove();
                continue;
            }
            try {
                Medicine m = medDao.getById(medId);
                if (m == null) {
                    errors.add("Medicine ID " + medId + " not found.");
                    it.remove();
                } else if (qty > m.getStock()) {
                    errors.add("Only " + m.getStock() +
                            " in stock for " + m.getName() + ".");
                    it.remove();
                }
            } catch (SQLException sqe) {
                throw new ServletException("Error checking stock for " + medId, sqe);
            }
        }

        if (qtyMap.isEmpty()) {
            if (errors.isEmpty()) {
                errors.add("Your cart is empty. Please add at least one item.");
            }
            req.setAttribute("error", String.join("<br>", errors));
            doGet(req, res);
            return;
        }

        // 5) Compute totals
        BigDecimal totalPrice = BigDecimal.ZERO;
        int totalItems = 0;
        try {
            for (Map.Entry<Integer,Integer> e : qtyMap.entrySet()) {
                Medicine m = medDao.getById(e.getKey());
                int qty = e.getValue();
                totalItems += qty;
                totalPrice = totalPrice.add(m.getPrice()
                        .multiply(BigDecimal.valueOf(qty)));
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to compute order totals", e);
        }

        System.out.println("DEBUG: totalPrice = " + totalPrice);
        int orderId ;
        // 6) Persist in one transaction
        try (Connection tx = orderDao.getConnection()) {
            orderId = orderDao.createOrder(tx, cid, totalItems, totalPrice);
            for (Map.Entry<Integer,Integer> e : qtyMap.entrySet()) {
                int medId = e.getKey(), qty = e.getValue();
                Medicine m = medDao.getById(medId);
                orderDao.addLineItem(tx, orderId, medId, qty, m.getPrice());
                medDao.updateStock(medId, m.getStock() - qty);
            }
            //tx.commit();
        } catch (SQLException e) {
            throw new ServletException("Order placement failed: " + e.getMessage(), e);
        }


        res.sendRedirect(req.getContextPath()
                + "/orderSuccess?orderId=" + orderId);
    }




}
