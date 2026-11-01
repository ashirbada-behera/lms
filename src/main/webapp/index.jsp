<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS | Dashboard</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body>

<div class="app-shell">

    <!-- Sidebar -->
    <aside class="sidebar">

        <div class="brand">
            <div class="brand-mark">L</div>
            <div>
                <strong>LIBRARY</strong>
                <div>Management System</div>
            </div>
        </div>

        <nav class="sidebar-nav">

            <p class="eyebrow">WORKSPACE</p>

            <a class="nav-link active" href="#overview">
                ▦ &nbsp; Dashboard
            </a>

            <% if (isAdmin) { %>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/books">
                ▤ &nbsp; Book Management
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/members">
                ♙ &nbsp; Member Management
            </a>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/issue">
                📖 &nbsp; Issue Book
            </a>

            <a class="nav-link"
               href= "${pageContext.request.contextPath}/return">
                ↩️ &nbsp; Return Book

            <!-- User Management -->
            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/users">
                ♟ &nbsp; User Management
            </a>

            <% } else { %>

            <a class="nav-link"
               href="${pageContext.request.contextPath}/books">
                ▤ &nbsp; Book Management
            </a>

            <a class="nav-link" href="#my-borrowing">
                ⇄ &nbsp; My Borrowing
            </a>

            <% } %>

            <a href="${pageContext.request.contextPath}/logout"
               class="nav-link logout-link">
                <span class="nav-icon">↪</span>
                <span>Logout</span>
            </a>

        </nav>

        <div class="sidebar-bottom">
            <p>Library Management System</p>
            <small>
                <%= isAdmin ? "Admin Workspace" : "Member Workspace" %>
            </small>
        </div>

    </aside>

    <!-- Main Dashboard -->
    <main class="main-content" id="overview">

        <header class="topbar">

            <div>
                <p class="eyebrow">LIBRARY</p>
                <h1>Dashboard</h1>
                <p>Manage your library from one place.</p>
            </div>

            <!-- Top User Management Button -->
            <% if (isAdmin) { %>
            <a class="nav-link"
               href="${pageContext.request.contextPath}/admin/users">
                User Management
            </a>
            <% } %>

            <div class="user-info">

                <div class="user-avatar">
                    <%= username.substring(0, 1).toUpperCase() %>
                </div>

                <div>
                    <strong><%= username %></strong>
                    <p><%= role %></p>
                </div>

            </div>

        </header>

        <section class="dashboard-welcome">

            <p class="eyebrow">YOUR LIBRARY AT A GLANCE</p>

            <h2>Welcome back, <%= username %>!</h2>

            <p>
                <%= isAdmin
                        ? "Here is your library management overview."
                        : "Explore books and keep track of your borrowing activity." %>
            </p>

        </section>

        <% if (isAdmin) { %>

        <!-- Admin Statistics -->
        <section class="stats-grid">

            <article class="stat-card">
                <p>Total Books</p>
                <h2>—</h2>
            </article>

            <article class="stat-card">
                <p>Total Members</p>
                <h2>—</h2>
            </article>

            <article class="stat-card">
                <p>Books Issued</p>
                <h2>—</h2>
            </article>

            <article class="stat-card stat-card-accent">
                <p>Overdue Books</p>
                <h2>—</h2>
            </article>

        </section>

        <% } %>

        <!-- Quick Access -->
        <section class="panel">

            <div class="panel-heading">
                <div>
                    <p class="eyebrow">QUICK ACCESS</p>
                    <h2>
                        <%= isAdmin ? "Library Operations" : "Explore Library" %>
                    </h2>
                </div>
            </div>

            <div class="quick-access-grid">

                <% if (isAdmin) { %>

                <a class="quick-access-card"
                   href="${pageContext.request.contextPath}/books">
                    <span class="quick-access-icon">▤</span>
                    <strong>Book Management</strong>
                    <span>Manage library books</span>
                </a>

                <a class="quick-access-card"
                   href="${pageContext.request.contextPath}/members">
                    <span class="quick-access-icon">♙</span>
                    <strong>Member Management</strong>
                    <span>View and manage members</span>
                </a>

                <a class="quick-access-card" href="#issue-return">
                    <span class="quick-access-icon">⇄</span>
                    <strong>Issue &amp; Return</strong>
                    <span>Manage book transactions</span>
                </a>

                <% } else { %>

                <a class="quick-access-card" href="#books">
                    <span class="quick-access-icon">▤</span>
                    <strong>View Books</strong>
                    <span>Explore available books</span>
                </a>

                <a class="quick-access-card" href="#my-borrowing">
                    <span class="quick-access-icon">⇄</span>
                    <strong>My Borrowing</strong>
                    <span>Track your borrowed books</span>
                </a>

                <% } %>

            </div>

        </section>

        <footer class="dashboard-footer">
            Library Management System
        </footer>

    </main>

</div>

</body>
</html>