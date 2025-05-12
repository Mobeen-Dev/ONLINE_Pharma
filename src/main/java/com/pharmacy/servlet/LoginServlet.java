package com.pharmacy.servlet;

import com.pharmacy.dao.CustomerDAO;
import com.pharmacy.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;
import java.util.Formatter;


public class LoginServlet extends HttpServlet {
    private CustomerDAO dao;

    @Override
    public void init() {
        dao = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");

        // If not in session, try cookies
        if (customerId == null && req.getCookies() != null) {
            for (Cookie cookie : req.getCookies()) {
                if ("customerId".equals(cookie.getName())) {
                    try {
                        int id = Integer.parseInt(cookie.getValue());
                        // validate against DB
                        if (dao.getById(id) != null) {
                            customerId = id;
                            session.setAttribute("customerId", id);
                        }
                    } catch (NumberFormatException | SQLException ignored) {
                    }
                    break;
                }
            }
        }

        // If we have a valid customerId, skip login and go to dashboard
        if (customerId != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            // otherwise, show the login form
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username").trim();
        String password = req.getParameter("password");

        try {
            Customer customer = dao.findByUsername(username);
            if (customer == null) {
                fail(req, resp, "Invalid username or password.");
                return;
            }

            // Hash & compare password...
            String submittedHash = sha256(password);
            if (!submittedHash.equals(customer.getPasswordHash())) {
                fail(req, resp, "Invalid username or password.");
                return;
            }

            // 1) Store in session
            HttpSession session = req.getSession();
            session.setAttribute("customerId", customer.getCustomerId());

            // 2) Store CUSTOMER ID cookie
            Cookie idCookie = new Cookie("customerId",
                    String.valueOf(customer.getCustomerId()));
            idCookie.setHttpOnly(true);
            idCookie.setMaxAge(7 * 24 * 60 * 60); // 1 week
            idCookie.setPath(req.getContextPath());
            resp.addCookie(idCookie);

            // 3) (Optional) Store hashed ID or other token
            String idHash = sha256(Integer.toString(customer.getCustomerId()));
            Cookie hashCookie = new Cookie("user_hash", idHash);
            hashCookie.setHttpOnly(true);
            hashCookie.setMaxAge(7 * 24 * 60 * 60);
            hashCookie.setPath(req.getContextPath());
            resp.addCookie(hashCookie);

            // 4) Redirect to dashboard
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (SQLException e) {
            throw new ServletException("Login error", e);
        }
    }


    private void fail(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    private String sha256(String input) throws IOException {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            try (Formatter fmt = new Formatter()) {
                for (byte b : digest) {
                    fmt.format("%02x", b);
                }
                return fmt.toString();
            }
        } catch (Exception e) {
            throw new IOException("Hashing error", e);
        }
    }
}
