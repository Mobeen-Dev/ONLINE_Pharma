<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sign Up - Online Pharma</title>
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #f8f9fc;
            --accent-color: #1cc88a;
            --error-color: #e74a3b;
            --font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            padding: 0;
            font-family: var(--font-family), serif;
            background: var(--secondary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
            padding: 2rem;
        }
        .card h1 {
            margin-top: 0;
            color: var(--primary-color);
            text-align: center;
        }
        .error-msg {
            color: var(--error-color);
            background: rgba(231,74,59,0.1);
            padding: 0.75rem;
            border-radius: 4px;
            margin-bottom: 1rem;
            display: none;
        }
        form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        form .full {
            grid-column: 1 / -1;
        }
        label {
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
            display: block;
            color: #333;
        }
        input, textarea {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(78,115,223,0.2);
        }
        .btn {
            padding: 0.75rem 1.5rem;
            background: var(--accent-color);
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s ease-in-out;
            grid-column: 1 / -1;
        }
        .btn:hover {
            background: #17a673;
        }
        .text-center {
            text-align: center;
        }
        @media (max-width: 600px) {
            form { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="card">
    <h1>Create Account</h1>
    <div id="error" class="error-msg"></div>
    <form id="signupForm" action="${pageContext.request.contextPath}/signup" method="post">
        <div class="full">
            <label for="username">Username</label>
            <input id="username" name="username" type="text" required>
        </div>
        <div class="full">
            <label for="password">Password</label>
            <input id="password" name="password" type="password" required>
        </div>
        <div>
            <label for="firstName">First Name</label>
            <input id="firstName" name="firstName" type="text" required>
        </div>
        <div>
            <label for="lastName">Last Name</label>
            <input id="lastName" name="lastName" type="text" required>
        </div>
        <div>
            <label for="primaryContact">Primary Contact</label>
            <input id="primaryContact" name="primaryContact" type="tel" required placeholder="+1-234-567-8901">
        </div>
        <div>
            <label for="secondaryContact">Secondary Contact</label>
            <input id="secondaryContact" name="secondaryContact" type="tel" placeholder="+1-234-567-8902">
        </div>
        <div class="full">
            <label for="address">Address</label>
            <textarea id="address" name="address" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn">Sign Up</button>
        <p class="text-center">Already have an account? <a href="${pageContext.request.contextPath}/login">Log in here</a>.</p>
    </form>
</div>
<script>
    document.getElementById('signupForm').addEventListener('submit', function(e) {
        const errorDiv = document.getElementById('error');
        errorDiv.style.display = 'none';
        // Basic front-end validation example
        const pwd = document.getElementById('password').value;
        if (pwd.length < 6) {
            e.preventDefault();
            errorDiv.textContent = 'Password must be at least 6 characters long.';
            errorDiv.style.display = 'block';
        }
    });
</script>
</body>
</html>
