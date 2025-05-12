<%@ page import="java.util.List, com.pharmacy.model.Medicine" %>
<%
    List<Medicine> meds = (List<Medicine>)request.getAttribute("medicines");
%>
<html><body>
<h2>All Medicines</h2>
<table border="1" cellpadding="5">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Manufacturer</th>
        <th>SKU</th>
        <th>Price</th>
        <th>Stock</th>
    </tr>
    <% for (Medicine m : meds) { %>
    <tr>
        <td><%= m.getId() %></td>
        <td><%= m.getName() %></td>
        <td><%= m.getManufacturer() %></td>
        <td><%= m.getSku() %></td>
        <td>PKR <%= m.getPrice() %></td>
        <td><%= m.getStock() %></td>
    </tr>
    <% } %>
</table>
<p>
    <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
</p>
</body></html>
