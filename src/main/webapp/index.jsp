<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

            <a class="nav-link" href="#books">
                ▤ &nbsp; Book Management
            </a>

            <a class="nav-link" href="${pageContext.request.contextPath}/member/members.jsp">
                ♙ &nbsp; Member Management
            </a>

            <a class="nav-link" href="#issue-return">
                ⇄ &nbsp; Issue &amp; Return
            </a>
        </nav>

        <div class="sidebar-bottom">
            <p>Library Management System</p>
            <small>Admin Workspace</small>
        </div>
    </aside>

    <!-- Main Dashboard -->
    <main class="main-content" id="overview">

        <header class="topbar">
            <div>
                <p class="eyebrow">LIBRARY </p>
                <h1>Dashboard</h1>
                <p>Manage your library from one place.</p>
            </div>

            <div class="user-info">
                <div class="user-avatar">A</div>
                <div>
                    <strong>
                        <%= session.getAttribute("username") != null
                                ? session.getAttribute("username") : "Admin" %>
                    </strong>
                    <p>
                        <%= session.getAttribute("role") != null
                                ? session.getAttribute("role") : "Administrator" %>
                    </p>
                </div>
            </div>
        </header>

        <section class="dashboard-welcome">
            <p class="eyebrow">YOUR LIBRARY AT A GLANCE</p>
            <h2>Welcome back!</h2>
            <p>Here is your library management overview.</p>
        </section>

        <!-- Statistics -->
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

        <!-- Quick Access -->
        <section class="panel">
            <div class="panel-heading">
                <div>
                    <p class="eyebrow">QUICK ACCESS</p>
                    <h2>Library Operations</h2>
                </div>
            </div>

            <div class="quick-access-grid">
                <a class="quick-access-card" href="#books">
                    <span class="quick-access-icon">▤</span>
                    <strong>Book Management</strong>
                    <span>Manage library books</span>
                </a>

                <a class="quick-access-card"
                   href="${pageContext.request.contextPath}/member/members.jsp">
                    <span class="quick-access-icon">♙</span>
                    <strong>Member Management</strong>
                    <span>View and manage members</span>
                </a>

                <a class="quick-access-card" href="#issue-return">
                    <span class="quick-access-icon">⇄</span>
                    <strong>Issue &amp; Return</strong>
                    <span>Manage book transactions</span>
                </a>
            </div>
        </section>

        <footer class="dashboard-footer">
            Library Management System
        </footer>

    </main>
</div>

</body>
</html>
