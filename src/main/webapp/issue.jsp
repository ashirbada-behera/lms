<%--
  Created by IntelliJ IDEA.
  User: Juber Alam
  Date: 09-10-2026
  Time: 19:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Issue a Book</title>
</head>
<body>

<h2>Issue a Book</h2>

<form action="issue" method="post">
<label>Registration Number:</label>
<input type="number" name="registrationNumber" required>
<br><br>

<label>Book Id:</label>
<input type="number" name="bookId" required>
<br><br>

<label>Due Date:</label>
<input type="date" name="dueDate" required>
<br><br>

<input type="submit" value="Issue Book">
</form>
</body>
</html>
