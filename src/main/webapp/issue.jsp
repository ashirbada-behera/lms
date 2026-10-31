
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Issue a Book</title>
    <link rel="stylesheet" href="issue.css">
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <h2>Library</h2>
        <p>Management System</p>
    </div>

    <nav class="sidebar-nav">
        <p class="nav-heading">MAIN MENU</p>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="members">Members</a>
        <a href="books">Books</a>
        <a href="issue.jsp" class="active">Issue Book</a>
        <a href="return.jsp">Return Book</a>
    </nav>
</aside>

<main class="main-content">

    <header class="page-header">
        <p class="eyebrow">WORKSPACE / CIRCULATION</p>
        <h1>Issue a Book</h1>
        <p class="page-subtitle">
            Record a book issue and set its due date.
        </p>
    </header>

    <section class="issue-panel">

        <h2>Issue a book</h2>
        <p>Enter the member registration number, book ID, and due date.</p>

        <!-- Success or error message -->
        <% if (request.getAttribute("message") != null) { %>

        <div class="issue-message <%= request.getAttribute("messageType") %>">

            <h3><%= request.getAttribute("message") %></h3>

            <% if ("success".equals(request.getAttribute("messageType"))) { %>

            <div class="issue-details">

                <h4>Issue Details</h4>

                <p>
                    <strong>Issue ID:</strong>
                    <%= request.getAttribute("issueId") %>
                </p>

                <p>
                    <strong>Member ID:</strong>
                    <%= request.getAttribute("memberId") %>
                </p>

                <p>
                    <strong>Book ID:</strong>
                    <%= request.getAttribute("bookId") %>
                </p>

                <p>
                    <strong>Issue Date:</strong>
                    <%= request.getAttribute("issueDate") %>
                </p>

                <p>
                    <strong>Due Date:</strong>
                    <%= request.getAttribute("dueDate") %>
                </p>

                <p class="issue-note">
                    Keep the Issue ID. You will need it when returning this book.
                </p>

            </div>

            <% } %>

        </div>

        <% } %>

        <div class="form-panel">

            <form action="issue" method="post">

                <label class="form-label" for="registrationNumber">
                    Registration Number:
                </label>

                <input type="text"
                       id="registrationNumber"
                       name="registrationNumber"
                       required>

                <label class="form-label" for="bookId">
                    Book ID:
                </label>

                <input type="number"
                       id="bookId"
                       name="bookId"
                       min="1"
                       required>

                <label class="form-label" for="dueDate">
                    Due Date:
                </label>

                <input type="date"
                       id="dueDate"
                       name="dueDate"
                       min="<%= java.time.LocalDate.now() %>"
                       required>

                <button class="issue-button" type="submit">
                    Issue Book
                </button>

            </form>

        </div>

    </section>

</main>

</body>
</html>
