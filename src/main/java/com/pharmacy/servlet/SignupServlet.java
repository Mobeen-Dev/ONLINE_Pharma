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
        String username = req.getParameter("username").trim();
        String password = req.getParameter("password");

        if (username.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        // Hash the password server-side with SHA-256
        String hash = sha256(password);

        try {
            int newId = dao.createCustomer(
                    username,
                    hash,
                    /* firstName */ "",
                    /* lastName */ "",
                    /* primaryContact */ "",
                    /* address */ ""
            );
            // signup successful → redirect to login
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } catch (SQLException e) {
            // handle duplicate username, etc.
            req.setAttribute("error", "Signup failed: " + e.getMessage());
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
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
