package com.pharmacy.servlet;

import com.pharmacy.dao.OrderDAO;
import com.pharmacy.dao.CustomerDAO;
import com.pharmacy.model.Order;
import com.pharmacy.model.OrderLineItem;
import com.pharmacy.model.Customer;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class OrderConfirmationServlet extends HttpServlet {
    private OrderDAO orderDao;
    private CustomerDAO custDao;

    @Override
    public void init() {
        orderDao = new OrderDAO();
        custDao  = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String idParam = req.getParameter("orderId");
        if (idParam == null) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderId");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid orderId");
            return;
        }

        try {
            // Fetch the order row
            Order order = orderDao.getOrderById(orderId);
            if (order == null) {
                res.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            // Fetch its line items
            List<OrderLineItem> items = orderDao.getLineItems(orderId);

            // Fetch the customer
            Customer customer = custDao.getById(order.getCustomerId());
            if (customer == null) {
                res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Customer record missing");
                return;
            }

            // Put all three in request
            req.setAttribute("order", order);
            req.setAttribute("lineItems", items);
            req.setAttribute("customer", customer);

            // Forward to the JSP
            RequestDispatcher rd = req.getRequestDispatcher(
                    "/WEB-INF/orderSuccess.jsp");
            rd.forward(req, res);

        } catch (SQLException ex) {
            throw new ServletException("Unable to load order details", ex);
        }
    }
}
