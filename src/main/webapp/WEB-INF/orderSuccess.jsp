<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pharmacy.model.OrderLineItem, com.pharmacy.model.Customer, com.pharmacy.model.Order" %>
<%
    // Grab the objects set by your servlet
    Order order = (Order) request.getAttribute("order");
    @SuppressWarnings("unchecked")
    List<OrderLineItem> lineItems = (List<OrderLineItem>) request.getAttribute("lineItems");
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 2em auto; line-height: 1.5; color: #333; }
        h1 { color: #0066cc; }
        table { width: 100%; border-collapse: collapse; margin-top: 1em; }
        th, td { padding: 0.75em; border-bottom: 1px solid #ddd; text-align: left; }
        th { background-color: #f4f4f4; }
        tfoot td { font-weight: bold; }
        .summary { margin-top: 1.5em; }
        .btn-home { display: inline-block; margin-top: 2em; padding: 0.75em 1.5em; background-color: #0066cc; color: #fff; text-decoration: none; border-radius: 4px; }
        .btn-home:hover { background-color: #005bb5; }
    </style>
</head>
<body>

<h1>Thank You for Your Order!</h1>
<p>Hello <strong><%= customer.getFirstName() %> <%= customer.getLastName() %></strong>,</p>
<p>Your order has been successfully placed. Below are the details of your purchase:</p>

<div class="summary">
    <p><strong>Order Number:</strong> <%= order.getOrderId() %></p>
    <p><strong>Date Placed:</strong> <%= order.getOrderTimestamp() %></p>
    <p><strong>Shipping To:</strong> <%= customer.getAddress() %></p>
    <p><strong>Contact:</strong> <%= customer.getPrimaryContact() %></p>
</div>

<table>
    <thead>
    <tr>
        <th>Medicine</th>
        <th>SKU</th>
        <th>Unit Price</th>
        <th>Quantity</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <% for (OrderLineItem item : lineItems) { %>
    <tr>
        <td>
            <%-- you may look up the medicine name via DAO or pass name in the item model --%>
            <%= item.getMedicineId() %>
        </td>
        <td><%= item.getUnitPrice() != null ? item.getUnitPrice() : "" %></td>
        <td>$<%= item.getUnitPrice().setScale(2) %></td>
        <td><%= item.getQuantity() %></td>
        <td>$<%= item.getTotalPrice().setScale(2) %></td>
    </tr>
    <% } %>
    </tbody>
    <tfoot>
    <tr>
        <td colspan="4" style="text-align:right;">Items:</td>
        <td><%= order.getTotalItems() %></td>
    </tr>
    <tr>
        <td colspan="4" style="text-align:right;">Grand Total:</td>
        <td>$<%= order.getTotalPrice().setScale(2) %></td>
    </tr>
    </tfoot>
</table>

<a href="<%= request.getContextPath() %>/order" class="btn-home">Continue Shopping</a>

</body>
</html>
