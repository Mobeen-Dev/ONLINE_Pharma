<%--
  Created by IntelliJ IDEA.
  User: mubee
  Date: 5/10/2025
  Time: 6:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, com.pharmacy.model.Order, com.pharmacy.model.Customer" %>
<%
  Customer customer = (Customer) request.getAttribute("customer");
  @SuppressWarnings("unchecked")
  List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Your Dashboard</title>
  <style>
    body { font-family: sans-serif; max-width: 800px; margin: 2rem auto; }

    .btn { padding: .5rem 1rem; background: #0077cc; color: #fff; text-decoration: none; border-radius:4px; }
    table { width:100%; border-collapse: collapse; margin-top:1rem; }
    th, td { border:1px solid #ccc; padding:.5rem; text-align:left; }
    header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      flex-wrap: wrap;
      padding: 1rem;
      background: #fff;
    }
    .user-info {
      flex: 1 1 300px;      /* grow, shrink, base width */
      min-width: 200px;
    }
    .user-info h1 {
      margin: 0;
      font-size: 1.5rem;
    }
    .user-info p {
      margin: .5rem 0 0;
      word-wrap: break-word; /* break very long addresses */
      max-width: 600px;
    }
    .actions {
      display: flex;
      gap: .5rem;
      flex-wrap: wrap;
      margin-top: .5rem;
    }
    .actions .btn {
      padding: .5rem 1rem;
      text-decoration: none;
      background: #007bff;
      color: #fff;
      border-radius: 4px;
    }
    .actions .btn.logout {
      background: #d9534f;
    }
    th { background: #f0f0f0; }
  </style>
</head>
<body>

<header>
  <div class="user-info">
    <h1>Welcome, <%= customer.getFirstName() %> <%= customer.getLastName() %></h1>
    <p>Address: <%= customer.getAddress() %></p>
  </div>
  <nav class="actions">
    <a href="<%= request.getContextPath() %>/order" class="btn">Continue Shopping</a>
    <a href="<%= request.getContextPath() %>/manage" class="btn">Manage Medicine</a>
    <a href="<%= request.getContextPath() %>/logout" class="btn logout">Logout</a>
  </nav>
</header>

<section>
  <h2>Your Previous Orders</h2>
  <% if (orders == null || orders.isEmpty()) { %>
  <p>You haven’t placed any orders yet.</p>
  <% } else { %>
  <table>
    <thead>
    <tr>
      <th>Order #</th>
      <th>Date</th>
      <th>Items</th>
      <th>Total (₹)</th>
      <th>Details</th>
    </tr>
    </thead>
    <tbody>
    <% for (Order o : orders) { %>
    <tr>
      <td><%= o.getOrderId() %></td>
      <td><%= o.getOrderTimestamp() %></td>
      <td><%= o.getTotalItems() %></td>
      <td><%= o.getTotalPrice().setScale(2) %></td>
      <td>
        <a href="<%= request.getContextPath() %>/orderSuccess?orderId=<%= o.getOrderId() %>">
          View
        </a>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
  <% } %>
</section>

</body>
</html>
