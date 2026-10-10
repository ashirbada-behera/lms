<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Admin Dashboard</title>
</head>
<body>

<h1>Library Management System</h1>
<h2>Admin Area</h2>

<p>Welcome, ${sessionScope.username}!</p>
<p>You are logged in with the role: ${sessionScope.role}</p>

<hr>

<h3>Management</h3>

<ul>
    <li>Book Management (coming soon)</li>
    <li>Member Management (coming soon)</li>
    <li>Issue and Return Books (coming soon)</li>
</ul>

<hr>

<a href="${pageContext.request.contextPath}/logout">Logout</a>

</body>
</html>