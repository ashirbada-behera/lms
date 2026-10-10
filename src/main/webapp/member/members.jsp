```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Directory | Library Management System</title>

    <style>
        :root {
            --primary: #173b67;
            --primary-dark: #102b4c;
            --accent: #d9a441;
            --text: #172337;
            --muted: #66758a;
            --surface: #ffffff;
            --background: #f4f7fb;
            --border: #e1e8f0;
            --success-bg: #e5f7ed;
            --success-text: #176b3a;
            --danger-bg: #fff0ee;
            --danger-text: #a93226;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: var(--background);
        }

        a {
            color: inherit;
        }

        .topbar {
            min-height: 72px;
            padding: 16px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }

        .brand {
            color: var(--primary);
            font-weight: 750;
            text-decoration: none;
        }

        .top-link {
            color: var(--primary);
            font-size: 14px;
            font-weight: 650;
            text-decoration: none;
        }

        .container {
            width: min(1200px, 92%);
            margin: 36px auto;
        }

        .page-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 26px;
        }

        .eyebrow {
            color: var(--muted);
            font-size: 12px;
            font-weight: 750;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        h1 {
            margin: 8px 0;
            font-size: clamp(28px, 4vw, 36px);
            letter-spacing: -1px;
        }

        .subtitle {
            margin: 0;
            color: var(--muted);
            line-height: 1.6;
        }

        .button {
            display: inline-flex;
            min-height: 42px;
            align-items: center;
            justify-content: center;
            padding: 0 16px;
            border: 1px solid transparent;
            border-radius: 9px;
            background: var(--primary);
            color: white;
            font-size: 14px;
            font-weight: 650;
            text-decoration: none;
            cursor: pointer;
        }

        .button:hover {
            background: var(--primary-dark);
        }

        .button-secondary {
            border-color: var(--border);
            background: white;
            color: var(--primary);
        }

        .button-secondary:hover {
            background: #eef3f9;
        }

        .notice {
            margin-bottom: 20px;
            padding: 13px 16px;
            border-radius: 10px;
            background: var(--success-bg);
            color: var(--success-text);
            font-size: 14px;
        }

        .toolbar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 12px;
            padding: 18px;
            margin-bottom: 20px;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: var(--surface);
        }

        .search-form {
            display: flex;
            flex: 1 1 300px;
            gap: 10px;
        }

        input,
        select {
            min-width: 0;
            min-height: 42px;
            padding: 10px 12px;
            border: 1px solid #ccd6e2;
            border-radius: 8px;
            background: white;
            color: var(--text);
            font: inherit;
        }

        .search-form input {
            flex: 1;
        }

        input:focus,
        select:focus,
        .button:focus-visible,
        .action-button:focus-visible {
            outline: 3px solid rgba(23, 59, 103, 0.2);
            outline-offset: 2px;
        }

        .count {
            color: var(--muted);
            font-size: 13px;
            white-space: nowrap;
        }

        .table-card {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 14px;
            background: var(--surface);
        }

        .table-scroll {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            white-space: nowrap;
        }

        th {
            padding: 15px 18px;
            background: #f8fafc;
            color: var(--muted);
            font-size: 11px;
            font-weight: 750;
            letter-spacing: 0.8px;
            text-transform: uppercase;
        }

        td {
            padding: 16px 18px;
            border-top: 1px solid var(--border);
            font-size: 13px;
        }

        tbody tr:hover {
            background: #fafcff;
        }

        .member-name {
            font-weight: 700;
            color: var(--primary);
        }

        .member-code {
            display: block;
            margin-top: 4px;
            color: var(--muted);
            font-size: 12px;
        }

        .status {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 750;
        }

        .status-active {
            background: var(--success-bg);
            color: var(--success-text);
        }

        .status-inactive {
            background: #edf0f4;
            color: #536174;
        }

        .status-suspended {
            background: var(--danger-bg);
            color: var(--danger-text);
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .action-link {
            color: var(--primary);
            font-weight: 650;
            text-decoration: none;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .action-button {
            padding: 0;
            border: 0;
            background: transparent;
            color: var(--danger-text);
            font: inherit;
            font-weight: 650;
            cursor: pointer;
        }

        .action-button:hover {
            text-decoration: underline;
        }

        .empty-state {
            padding: 52px 20px;
            text-align: center;
        }

        .empty-state h2 {
            margin: 0 0 10px;
            font-size: 20px;
        }

        .empty-state p {
            margin: 0 0 20px;
            color: var(--muted);
            line-height: 1.6;
        }

        footer {
            padding: 24px;
            color: var(--muted);
            text-align: center;
            font-size: 12px;
        }

        @media (max-width: 600px) {
            .topbar {
                align-items: flex-start;
            }

            .container {
                margin-top: 26px;
            }

            .search-form {
                flex-basis: 100%;
            }

            .search-form .button {
                padding-inline: 12px;
            }

            .toolbar > form:not(.search-form) {
                flex: 1;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
</head>

<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">
        Library Management System
    </a>

    <a class="top-link" href="${pageContext.request.contextPath}/">
        Home &rarr;
    </a>
</header>

<main class="container">
    <section class="page-heading">
        <div>
            <div class="eyebrow">Member Management</div>
            <h1>Member Directory</h1>
            <p class="subtitle">
                View, search, and manage registered library members.
            </p>
        </div>

        <a class="button"
           href="${pageContext.request.contextPath}/members/create">
            + Register Member
        </a>
    </section>

    <c:if test="${param.deactivated eq 'true'}">
        <div class="notice" role="status">
            Member status updated successfully.
        </div>
    </c:if>

    <c:if test="${param.created eq 'true'}">
        <div class="notice" role="status">
            Member registered successfully.
        </div>
    </c:if>

    <c:if test="${param.updated eq 'true'}">
        <div class="notice" role="status">
            Member details updated successfully.
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div class="notice" role="alert">
            <c:out value="${errorMessage}"/>
        </div>
    </c:if>

    <section class="toolbar" aria-label="Member search and filters">
        <form class="search-form"
              method="get"
              action="${pageContext.request.contextPath}/members/search">

            <input type="search"
                   name="q"
                   placeholder="Search name, email, phone or member code"
                   value="<c:out value='${searchQuery}'/>"
                   aria-label="Search members">

            <button class="button" type="submit">Search</button>
        </form>

        <form method="get"
              action="${pageContext.request.contextPath}/members"
              aria-label="Filter members by status">

            <select name="status" aria-label="Member status">
                <option value=""
                    ${empty param.status ? 'selected' : ''}>
                    All statuses
                </option>

                <option value="ACTIVE"
                    ${param.status eq 'ACTIVE' ? 'selected' : ''}>
                    Active
                </option>

                <option value="INACTIVE"
                    ${param.status eq 'INACTIVE' ? 'selected' : ''}>
                    Inactive
                </option>

                <option value="SUSPENDED"
                    ${param.status eq 'SUSPENDED' ? 'selected' : ''}>
                    Suspended
                </option>
            </select>

            <button class="button button-secondary" type="submit">
                Filter
            </button>
        </form>

        <span class="count">
            <c:out value="${memberCount}"/> result(s)
        </span>
    </section>

    <section class="table-card" aria-label="Registered members">
        <c:choose>
            <c:when test="${not empty members}">
                <div class="table-scroll">
                    <table>
                        <thead>
                        <tr>
                            <th>Member</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Membership</th>
                            <th>Valid Until</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:forEach var="member" items="${members}">
                            <tr>
                                <td>
                                    <span class="member-name">
                                        <c:out value="${member.fullName}"/>
                                    </span>

                                    <span class="member-code">
                                        <c:out value="${member.memberCode}"/>
                                    </span>
                                </td>

                                <td>
                                    <c:out value="${member.email}"/>
                                </td>

                                <td>
                                    <c:out value="${member.phone}"/>
                                </td>

                                <td>
                                    <c:out value="${member.membershipType}"/>
                                </td>

                                <td>
                                    <c:out value="${member.validUntil}"/>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${member.status eq 'ACTIVE'}">
                                            <span class="status status-active">
                                                Active
                                            </span>
                                        </c:when>

                                        <c:when test="${member.status eq 'INACTIVE'}">
                                            <span class="status status-inactive">
                                                Inactive
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="status status-suspended">
                                                Suspended
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <div class="actions">
                                        <a class="action-link"
                                           href="${pageContext.request.contextPath}/members/details?id=${member.id}">
                                            View
                                        </a>

                                        <a class="action-link"
                                           href="${pageContext.request.contextPath}/members/edit?id=${member.id}">
                                            Edit
                                        </a>

                                        <c:if test="${member.status eq 'ACTIVE'}">
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/members/deactivate"
                                                  onsubmit="return confirm('Deactivate this member?');">

                                                <%-- CSRF protection --%>
                                                <input type="hidden"
                                                       name="csrfToken"
                                                       value="<c:out value='${csrfToken}'/>">

                                                <input type="hidden"
                                                       name="id"
                                                       value="<c:out value='${member.id}'/>">

                                                <button class="action-button"
                                                        type="submit">
                                                    Deactivate
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <c:otherwise>
                <div class="empty-state">
                    <h2>No members found</h2>

                    <p>
                        No records match the current search or filter.
                        Register a member or adjust your search.
                    </p>

                    <a class="button"
                       href="${pageContext.request.contextPath}/members/create">
                        Register First Member
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<footer>
    Library Management System &middot; Member Management
</footer>
</body>
</html>
```