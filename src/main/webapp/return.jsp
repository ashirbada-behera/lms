<%--
  Created by IntelliJ IDEA.
  User: Juber Alam
  Date: 12-10-2026
  Time: 14:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Book</title>

    <link rel="stylesheet" href="return.css">
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <h2>Library</h2>
        <p>Management System</p>
    </div>

    <nav class="sidebar-nav">
        <p class="nav-heading">MAIN MENU</p>
        <a href="index.jsp">Dashboard</a>
        <a href="members.jsp">Members</a>
        <a href="books.jsp">Books</a>
        <a href="issue.jsp">Issue Book</a>
        <a href="return.jsp" class="active">Return Book</a>
    </nav>
</aside>


<main class="main-content">
    <header class="page-header">
        <p class="eyebrow">WORKSPACE / CIRCULATION</p>
        <h1>Return Book</h1>
        <p class="page-subtitle">Record a book return and update its status.</p>
    </header>

    <section class="return-panel">
        <h2>Return a book</h2>
        <p>Enter the issue ID to process the return.</p>

        <% if (request.getAttribute("message") != null) { %>
        <div class="return-message">
            <p><%= request.getAttribute("message") %></p>

            <% if (Boolean.TRUE.equals(request.getAttribute("success"))) { %>
            <h3>
                Fine: ₹<%= String.format("%.2f", request.getAttribute("fine")) %>
            </h3>
            <% } %>
        </div>
        <% } %>
        <div class="form-panel">
<form action = "return" method = "POST">
    <label class="form-label" for="issueId">Issue Id:</label>
    <input type="number" id="issueId" name="issueId" required>
    <br><br>

    <button class = "return-button" type = submit>Return Book</button>
</form>
        </div>

    </section>
</main>
</body>
</html>
