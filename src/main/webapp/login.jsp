<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Log In</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 2rem; }
        .error { color: red; margin-bottom: 1rem; }
        form { max-width: 320px; margin: auto; }
        label { display: block; margin-top: 1rem; }
        input { width: 100%; padding: .5rem; margin-top: .25rem; }
        button { margin-top: 1rem; padding: .5rem 1rem; }
    </style>
</head>
<body>

<h2>Log In</h2>

<% String error = (String) request.getAttribute("error"); %>
<% if (error != null) { %>
<div class="error"><%= error %></div>
<% } %>

<form action="<%= request.getContextPath() %>/login" method="post">
    <label for="username">Username</label>
    <input id="username" name="username" required/>

    <label for="password">Password</label>
    <input id="password" type="password" name="password" required/>

    <button type="submit">Log In</button>
</form>

<p>New user? <a href="signup.jsp">Sign up here</a>.</p>
</body>
</html>
