<%@ page import="java.util.List" %>
<%@ page import="org.example.lms.model.User" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    // Admin access protection
    if (username == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");

    if (users == null) {
        response.sendRedirect(request.getContextPath() + "/admin/users");
        return;
    }

    String initial = username.substring(0, 1).toUpperCase();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>User Management | LMS</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/assets/css/dashboard.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .app-shell {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            min-width: 250px;
            background: #173d30;
            color: white;
            padding: 28px 20px;
            display: flex;
            flex-direction: column;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 45px;
        }

        .brand-mark {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            background: #e58b45;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 21px;
            font-weight: bold;
            color: white;
        }

        .brand-name {
            font-size: 19px;
            font-weight: bold;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .nav-link {
            display: block;
            padding: 13px 15px;
            color: #e5eee8;
            text-decoration: none;
            border-radius: 7px;
            transition: 0.2s;
        }

        .nav-link:hover,
        .nav-link.active {
            background: #315b49;
            color: white;
        }

        .sidebar-bottom {
            margin-top: auto;
        }

        .logout-link {
            display: block;
            padding: 13px 15px;
            color: #f5c3ad;
            text-decoration: none;
            border-radius: 7px;
        }

        .logout-link:hover {
            background: #315b49;
        }

        /* Main content */
        .main-content {
            flex: 1;
            min-width: 0;
            padding: 30px 38px;
            background: #f6f5ef;
        }

        /* Topbar */
        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 35px;
        }

        .topbar-heading .eyebrow {
            color: #8b927f;
            font-size: 12px;
            font-weight: bold;
            letter-spacing: 1.5px;
        }

        .topbar-heading h1 {
            margin: 8px 0 0;
            color: #244b3b;
            font-size: 29px;
        }

        /* Admin profile - separate from dashboard button */
        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #244b3b;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 17px;
        }

        .user-details {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .user-details strong {
            color: #244b3b;
            font-size: 14px;
        }

        .user-details span {
            color: #858b80;
            font-size: 12px;
        }

        /* Back to Dashboard - independent topbar element */
        .back-link {
            display: inline-block;
            padding: 11px 17px;
            background: #244b3b;
            color: white;
            border-radius: 7px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;
            transition: 0.2s;
        }

        .back-link:hover {
            background: #315b49;
        }

        /* Management content */
        .management-content {
            background: white;
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.04);
        }

        .section-heading {
            color: #244b3b;
            font-size: 20px;
            margin: 0 0 8px;
        }

        .section-description {
            color: #858b80;
            font-size: 13px;
            margin: 0 0 25px;
        }

        /* Messages */
        .message {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .success-message {
            background: #e5f4e9;
            color: #246b3b;
        }

        .error-message {
            background: #fbe9e7;
            color: #a33227;
        }

        /* Add user form */
        .add-user-section {
            background: #f8f8f3;
            border: 1px solid #e8e8df;
            border-radius: 9px;
            padding: 22px;
            margin-bottom: 30px;
        }

        .add-user-section h3 {
            color: #244b3b;
            margin: 0 0 18px;
            font-size: 17px;
        }

        .add-user-form {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 15px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            color: #46574c;
            font-size: 13px;
            font-weight: bold;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 11px;
            border: 1px solid #d9ddd5;
            border-radius: 6px;
            background: white;
            font-size: 13px;
            outline: none;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #315b49;
        }

        .primary-btn {
            padding: 12px 18px;
            background: #244b3b;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 13px;
        }

        .primary-btn:hover {
            background: #315b49;
        }

        /* Users table */
        .table-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 17px;
        }

        .table-heading h3 {
            color: #244b3b;
            margin: 0;
            font-size: 17px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 650px;
        }

        .users-table th {
            background: #f2f3ed;
            color: #526456;
            padding: 14px;
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .users-table td {
            padding: 14px;
            border-bottom: 1px solid #eeeeea;
            color: #455349;
            font-size: 13px;
        }

        .role-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            background: #e8f0e9;
            color: #315b49;
            font-size: 11px;
            font-weight: bold;
        }

        .row-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .row-actions form {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin: 0;
        }

        .row-actions select {
            padding: 7px;
            border: 1px solid #d9ddd5;
            border-radius: 5px;
            font-size: 12px;
        }

        .update-btn {
            padding: 8px 11px;
            border: none;
            border-radius: 5px;
            background: #315b49;
            color: white;
            cursor: pointer;
            font-size: 11px;
        }

        .delete-btn {
            padding: 8px 11px;
            border: none;
            border-radius: 5px;
            background: #a94438;
            color: white;
            cursor: pointer;
            font-size: 11px;
        }

        .delete-btn:hover {
            background: #87362d;
        }

        .current-user-label {
            color: #858b80;
            font-size: 12px;
            font-style: italic;
        }

        .empty-message {
            text-align: center;
            padding: 25px;
            color: #858b80;
        }

        /* Responsive layout */
        @media (max-width: 1000px) {
            .main-content {
                padding: 25px;
            }

            .add-user-form {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 700px) {
            .app-shell {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                min-width: 0;
            }

            .sidebar-nav {
                flex-direction: row;
                flex-wrap: wrap;
            }

            .sidebar-bottom {
                margin-top: 15px;
            }

            .main-content {
                padding: 20px 14px;
            }

            .topbar {
                flex-wrap: wrap;
            }

            .topbar-heading {
                width: 100%;
            }

            .management-content {
                padding: 18px;
            }

            .add-user-form {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<div class="app-shell">

    <!-- Sidebar -->
    <aside class="sidebar">

        <div class="brand">
            <div class="brand-mark">L</div>
            <div class="brand-name">Library LMS</div>
        </div>

        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/index.jsp"
               class="nav-link">
                Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/admin/users"
               class="nav-link active">
                User Management
            </a>
        </nav>

        <div class="sidebar-bottom">
            <a href="<%= request.getContextPath() %>/logout"
               class="logout-link">
                Logout
            </a>
        </div>

    </aside>

    <!-- Main content -->
    <main class="main-content">

        <!-- Topbar -->
        <header class="topbar">

            <div class="topbar-heading">
                <span class="eyebrow">ADMINISTRATION</span>
                <h1>User Management</h1>
            </div>

            <!-- Admin profile box -->
            <div class="user-info">
                <div class="user-avatar">
                    <%= initial %>
                </div>

                <div class="user-details">
                    <strong><%= username %></strong>
                    <span>Administrator</span>
                </div>
            </div>

            <!-- Separate button outside the profile box -->
            <a href="<%= request.getContextPath() %>/index.jsp"
               class="back-link">
                Back to Dashboard
            </a>

        </header>

        <!-- User management area -->
        <section class="management-content">

            <h2 class="section-heading">Manage System Users</h2>

            <p class="section-description">
                Add new users, manage their roles, and remove accounts.
            </p>

            <!-- Success and error messages -->
            <% if ("1".equals(success)) { %>
            <div class="message success-message">
                Operation completed successfully.
            </div>
            <% } %>

            <% if ("invalid".equals(error)) { %>
            <div class="message error-message">
                Please enter valid user details and select a valid role.
            </div>
            <% } else if ("self".equals(error)) { %>
            <div class="message error-message">
                You cannot change your own role.
            </div>
            <% } else if ("operation".equals(error)) { %>
            <div class="message error-message">
                Operation failed. Please check the information and try again.
            </div>
            <% } %>

            <!-- Add User -->
            <div class="add-user-section">

                <h3>Add New User</h3>

                <form action="<%= request.getContextPath() %>/admin/users"
                      method="post"
                      class="add-user-form">

                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label for="newUsername">Username</label>
                        <input type="text"
                               id="newUsername"
                               name="username"
                               placeholder="Enter username"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="newPassword">Password</label>
                        <input type="password"
                               id="newPassword"
                               name="password"
                               placeholder="Enter password"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="newRole">Role</label>
                        <select id="newRole" name="role" required>
                            <option value="MEMBER">MEMBER</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                    </div>

                    <button type="submit" class="primary-btn">
                        + Add User
                    </button>

                </form>

            </div>

            <!-- Existing users -->
            <div class="table-heading">
                <h3>All Registered Users</h3>
            </div>

            <div class="table-wrapper">

                <table class="users-table">

                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>

                    <% if (users.isEmpty()) { %>

                    <tr>
                        <td colspan="4" class="empty-message">
                            No users found.
                        </td>
                    </tr>

                    <% } else { %>

                    <% for (User user : users) { %>

                    <tr>
                        <td><%= user.getId() %></td>

                        <td><%= user.getUsername() %></td>

                        <td>
                                    <span class="role-badge">
                                        <%= user.getRole() %>
                                    </span>
                        </td>

                        <td>

                            <div class="row-actions">

                                <% if (!username.equalsIgnoreCase(user.getUsername())) { %>

                                <!-- Update role -->
                                <form action="<%= request.getContextPath() %>/admin/users"
                                      method="post">

                                    <input type="hidden"
                                           name="action"
                                           value="update">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= user.getId() %>">

                                    <select name="role" required>
                                        <option value="ADMIN"
                                                <%= "ADMIN".equalsIgnoreCase(user.getRole()) ? "selected" : "" %>>
                                            ADMIN
                                        </option>

                                        <option value="MEMBER"
                                                <%= "MEMBER".equalsIgnoreCase(user.getRole()) ? "selected" : "" %>>
                                            MEMBER
                                        </option>
                                    </select>

                                    <button type="submit"
                                            class="update-btn">
                                        Update
                                    </button>

                                </form>

                                <!-- Delete user -->
                                <form action="<%= request.getContextPath() %>/admin/users"
                                      method="post"
                                      onsubmit="return confirm('Are you sure you want to delete this user?');">

                                    <input type="hidden"
                                           name="action"
                                           value="delete">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= user.getId() %>">

                                    <button type="submit"
                                            class="delete-btn">
                                        Delete
                                    </button>

                                </form>

                                <% } else { %>

                                <span class="current-user-label">
                                                Current Admin
                                            </span>

                                <% } %>

                            </div>

                        </td>
                    </tr>

                    <% } %>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

</body>
</html>
