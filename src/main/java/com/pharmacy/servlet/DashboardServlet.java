package com.pharmacy.servlet;

import com.pharmacy.dao.CustomerDAO;
import com.pharmacy.dao.OrderDAO;
import com.pharmacy.model.Customer;
import com.pharmacy.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


public class DashboardServlet extends HttpServlet {
    private CustomerDAO custDao;
    private OrderDAO orderDao;

    @Override
    public void init() {
        custDao  = new CustomerDAO();
        orderDao = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer customerId = null;
        if (session != null) {
            customerId = (Integer) session.getAttribute("customerId");
        }
        if (customerId == null) {
            // not logged in: bounce to login page
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // now load the real customer
        Customer customer = null;
        try {
            customer = custDao.getById(customerId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        List<Order> orders = null;
        try {
            orders = orderDao.getOrdersByCustomer(customerId);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        req.setAttribute("customer", customer);
        req.setAttribute("orders",   orders);
        req.getRequestDispatcher("/dashboard.jsp")
                .forward(req, resp);
    }

}
