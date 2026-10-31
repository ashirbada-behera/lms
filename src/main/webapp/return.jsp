
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.lms.model.IssueRecord" %>

<!DOCTYPE html>
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
        <a href="return" class="active">Return Book</a>
    </nav>
</aside>

<main class="main-content">

    <header class="page-header">
        <p class="eyebrow">WORKSPACE / CIRCULATION</p>
        <h1>Return Book</h1>
        <p class="page-subtitle">
            Find a member's issued books and process a return.
        </p>
    </header>

    <section class="return-panel">

        <h2>Find Member's Issued Books</h2>
        <p>Enter the member's registration number to view active issues.</p>

        <% if (request.getAttribute("message") != null) { %>

        <div class="return-message
                <%= Boolean.TRUE.equals(request.getAttribute("success"))
                        ? "success-message" : "error-message" %>">

            <p><%= request.getAttribute("message") %></p>

            <% if (Boolean.TRUE.equals(request.getAttribute("success"))
                    && request.getAttribute("fine") != null) { %>

            <h3>
                Fine: ₹<%= String.format("%.2f",
                    request.getAttribute("fine")) %>
            </h3>

            <% } %>
        </div>

        <% } %>

        <div class="form-panel">

            <form action="return" method="POST">

                <input type="hidden" name="action" value="search">

                <label class="form-label" for="registrationNumber">
                    Member Registration Number:
                </label>

                <input
                        type="text"
                        id="registrationNumber"
                        name="registrationNumber"
                        value="<%= request.getAttribute("registrationNumber") != null
                            ? request.getAttribute("registrationNumber") : "" %>"
                        placeholder="Enter registration number"
                        required>

                <button class="return-button" type="submit">
                    Find Issued Books
                </button>

            </form>

        </div>

        <%
            List<IssueRecord> issuedBooks =
                    (List<IssueRecord>) request.getAttribute("issuedBooks");
        %>

        <% if (issuedBooks != null && !issuedBooks.isEmpty()) { %>

        <div class="issued-books-section">

            <h2>Currently Issued Books</h2>

            <p>
                Registration Number:
                <strong><%= request.getAttribute("registrationNumber") %></strong>
            </p>

            <div class="table-container">

                <table class="issued-books-table">

                    <thead>
                    <tr>
                        <th>Issue ID</th>
                        <th>Book ID</th>
                        <th>Issue Date</th>
                        <th>Due Date</th>
                        <th>Action</th>
                    </tr>
                    </thead>

                    <tbody>

                    <% for (IssueRecord issue : issuedBooks) { %>

                    <tr>
                        <td><%= issue.getIssueId() %></td>
                        <td><%= issue.getBookId() %></td>
                        <td><%= issue.getIssueDate() %></td>
                        <td><%= issue.getDueDate() %></td>

                        <td>
                            <form action="return" method="POST">

                                <input type="hidden"
                                       name="action"
                                       value="return">

                                <input type="hidden"
                                       name="registrationNumber"
                                       value="<%= request.getAttribute("registrationNumber") %>">

                                <input type="hidden"
                                       name="issueId"
                                       value="<%= issue.getIssueId() %>">

                                <button class="return-button"
                                        type="submit">
                                    Return Book
                                </button>

                            </form>
                        </td>
                    </tr>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </div>

        <% } %>

    </section>

</main>

</body>
</html>
