<!DOCTYPE html>
<html>
<head>
    <title>LMS Login</title>
</head>
<body>

<h2>Library Management System</h2>

<% String error = request.getParameter("error"); %>

<% if ("empty".equals(error)) { %>
<p style="color: red;">
    Please enter both username and password.
</p>
<% } else if ("invalid".equals(error)) { %>
<p style="color: red;">
    Invalid username or password.
</p>
<% } %>

<form action="login" method="post">

    <label>Username:</label>
    <input type="text" name="username" required>

    <br><br>

    <label>Password:</label>
    <input type="password" name="password" required>

    <br><br>

    <button type="submit">Login</button>

</form>

</body>
</html>