package com.pharmacy.servlet;

import com.pharmacy.dao.CustomerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;
import java.util.Formatter;


public class SignupServlet extends HttpServlet {
    private CustomerDAO dao;

    @Override
    public void init() {
        dao = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // forward to signup JSP
        req.getRequestDispatcher("/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Grab all form parameters
        String username          = req.getParameter("username").trim();
        String password          = req.getParameter("password");
        String firstName         = req.getParameter("firstName").trim();
        String lastName          = req.getParameter("lastName").trim();
        String primaryContact    = req.getParameter("primaryContact").trim();
        String secondaryContact  = req.getParameter("secondaryContact").trim();
        String address           = req.getParameter("address").trim();

        // 2) Basic non-empty validation
        if (username.isEmpty() || password.isEmpty() ||
                firstName.isEmpty() || lastName.isEmpty() ||
                primaryContact.isEmpty() || address.isEmpty()) {
            req.setAttribute("error", "All fields except secondary contact are required.");
            req.getRequestDispatcher("/WEB-INF/signup.jsp")
                    .forward(req, resp);
            return;
        }

        // 3) Hash the password
        String hash = sha256(password);

        try {
            // 4) Create the customer record
            int newId = dao.createCustomer(
                    username,
                    hash,
                    firstName,
                    lastName,
                    primaryContact,
                    secondaryContact,
                    address
            );

            // 5) Redirect to login on success
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (SQLException e) {
            // e.g. duplicate username, DB error
            req.setAttribute("error", "Signup failed: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/signup.jsp")
                    .forward(req, resp);
        }
    }

    private String sha256(String input) throws IOException {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            // convert to hex
            try (Formatter fmt = new Formatter()) {
                for (byte b : digest) {
                    fmt.format("%02x", b);
                }
                return fmt.toString();
            }
        } catch (Exception e) {
            throw new IOException("Could not hash password", e);
        }
    }
}
