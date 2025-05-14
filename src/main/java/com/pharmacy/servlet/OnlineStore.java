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
import java.util.stream.Collectors;

public class OnlineStore extends HttpServlet {
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
        req.getRequestDispatcher("/WEB-INF/store.jsp")
                .forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        /* ------------------------------------------------------------------ *
         * 1 . identify customer (fall back to anonymous ID 1)                 *
         * ------------------------------------------------------------------ */
        System.out.println("DEBUG: Arrived in doPost function  ");
        HttpSession session = req.getSession();
        int customerId = Optional.ofNullable((Integer) session.getAttribute("customerId"))
                .orElseGet(() -> {
                    session.setAttribute("customerId", 1);
                    return 1;
                });
        System.out.println("DEBUG:CustomerID ->  "+customerId);
        /* ------------------------------------------------------------------ *
         * 2 . collect quantities:  qty_123 → 3  ⇒  {123=3}                    *
         * ------------------------------------------------------------------ */
        Map<Integer,Integer> qtyMap = req.getParameterMap().entrySet().stream()
                .filter(e -> e.getKey().startsWith("qty_"))
                .map(e -> {
                    try {
                        int medId = Integer.parseInt(e.getKey().substring(4));
                        int qty   = Integer.parseInt(e.getValue()[0].trim());
                        System.out.println("DEBUG: medId ->  "+medId);
                        System.out.println("DEBUG: qty ->  "+qty);
                        return Map.entry(medId, qty);
                    } catch (NumberFormatException nfe) {   // skip garbage parameters
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (a,b) -> b,                     // in case of duplicates keep last
                        LinkedHashMap::new));           // keep order for nicer error list

        /* ------------------------------------------------------------------ *
         * 3 . validate quantities against database in one round-trip         *
         * ------------------------------------------------------------------ */
        List<String> errors   = new ArrayList<>();
        Map<Integer,Medicine> medsById = new LinkedHashMap<>();

        try {
            for (Integer medId : qtyMap.keySet()) {
                Medicine m = medDao.getById(medId);   // ← legacy single-row fetch
                medsById.put(medId, m);               // may be null if not found
            }
        } catch (SQLException ex) {
            throw new ServletException("Failed to load medicines", ex);
        }
        qtyMap.entrySet().removeIf(e -> {
            int medId = e.getKey();
            int qty   = e.getValue();

            if (qty < 1) {
                errors.add("Quantity for medicine #" + medId + " must be ≥ 1.");
                return true;
            }

            Medicine m = medsById.get(medId);
            if (m == null) {
                errors.add("Medicine ID " + medId + " not found.");
                return true;
            }
            if (qty > m.getStock()) {
                errors.add("Only " + m.getStock() + " left for " + m.getName() + ".");
                return true;
            }
            return false;      // keep valid entry
        });

        /* ------------------------------------------------------------------ *
         * 4 . short-circuit back to the catalog if nothing to order           *
         * ------------------------------------------------------------------ */
        if (qtyMap.isEmpty()) {
            if (errors.isEmpty()) {
                System.out.println("DEBUG: Your cart is empty. Please add at least one item. ");
                errors.add("empty cart");
            }
            req.setAttribute("error", String.join("<br>", errors));
            doGet(req, res);
            return;
        }

        /* ------------------------------------------------------------------ *
         * 5 . calculate order totals locally (BigDecimal)                    *
         * ------------------------------------------------------------------ */
        BigDecimal totalPrice = BigDecimal.ZERO;
        int        totalItems = 0;

        for (Map.Entry<Integer,Integer> e : qtyMap.entrySet()) {
            Medicine m = medsById.get(e.getKey());
            int qty     = e.getValue();
            totalItems += qty;
            totalPrice  = totalPrice.add(m.getPrice().multiply(BigDecimal.valueOf(qty)));
        }

        System.out.println("DEBUG: Your cart Price : "+totalPrice);

        /* ------------------------------------------------------------------ *
         * 6 . persist – one transaction, explicit rollback on failure        *
         * ------------------------------------------------------------------ */
        int orderId;
        try (Connection conn = orderDao.getConnection()) {
            conn.setAutoCommit(true);        // begin TX
            try {
                orderId = orderDao.createOrder(conn, customerId, totalItems, totalPrice);
                for (Map.Entry<Integer,Integer> e : qtyMap.entrySet()) {
                    Medicine m  = medsById.get(e.getKey());
                    int qty      = e.getValue();
                    orderDao.addLineItem(conn, orderId, m.getId(), qty, m.getPrice());
                    medDao.updateStock(m.getId(), m.getStock() - qty);
                }
//                conn.commit();               // success
            } catch (SQLException ex) {
//                conn.rollback();             // restore DB
                throw ex;
            }
        } catch (SQLException ex) {
            System.out.println("DEBUG: Order placement failed"+ ex);

            throw new ServletException("Order placement failed", ex);
        }

        /* ------------------------------------------------------------------ *
         * 7 . redirect to confirmation                                        *
         * ------------------------------------------------------------------ */
        res.sendRedirect(req.getContextPath() + "/orderSuccess?orderId=" + orderId);
    }





}
