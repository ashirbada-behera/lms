<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light">
    <title>Search Members | Library Management System</title>

    <style>
        :root {
            --navy: #142b4a;
            --navy-deep: #0d1f38;
            --blue: #2859a6;
            --blue-soft: #edf4ff;
            --ink: #192638;
            --muted: #68778b;
            --border: #e0e7f0;
            --surface: #ffffff;
            --canvas: #f5f7fb;
            --green: #18794e;
            --green-soft: #e9f7ef;
            --red: #b42318;
            --red-soft: #fff0ee;
            --shadow: 0 12px 36px rgba(24, 42, 70, 0.06);
            --radius: 16px;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--canvas);
            color: var(--ink);
            font-family: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI",
                         Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.55;
        }

        a {
            color: var(--blue);
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        a:focus-visible,
        button:focus-visible,
        input:focus-visible {
            outline: 3px solid #8ab4ff;
            outline-offset: 3px;
        }

        .topbar {
            background: var(--navy-deep);
            color: #fff;
        }

        .topbar-inner {
            width: min(1180px, calc(100% - 40px));
            min-height: 72px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #fff;
            font-weight: 750;
            letter-spacing: -0.02em;
        }

        .brand:hover {
            text-decoration: none;
        }

        .brand-mark {
            display: grid;
            place-items: center;
            width: 42px;
            height: 42px;
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.09);
            font-size: 19px;
        }

        .brand-subtitle {
            display: block;
            color: #bdcde2;
            font-size: 11px;
            font-weight: 500;
            letter-spacing: 0.07em;
            text-transform: uppercase;
        }

        .topnav {
            display: flex;
            align-items: center;
            gap: 22px;
        }

        .topnav a {
            color: #dce6f4;
            font-size: 13px;
            font-weight: 600;
        }

        .topnav a[aria-current="page"] {
            color: #fff;
        }

        .container {
            width: min(1180px, calc(100% - 40px));
            margin: 0 auto;
            padding: 34px 0 56px;
        }

        .breadcrumb {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 9px;
            margin-bottom: 22px;
            color: var(--muted);
            font-size: 13px;
        }

        .breadcrumb span {
            color: #a2adbc;
        }

        .page-heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 28px;
        }

        .eyebrow {
            margin: 0 0 8px;
            color: var(--blue);
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.12em;
            text-transform: uppercase;
        }

        h1 {
            margin: 0;
            color: var(--navy);
            font-size: clamp(27px, 4vw, 36px);
            letter-spacing: -0.045em;
            line-height: 1.2;
        }

        .subtitle {
            max-width: 650px;
            margin: 11px 0 0;
            color: var(--muted);
            font-size: 14px;
        }

        .button {
            display: inline-flex;
            min-height: 42px;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 10px 16px;
            border: 1px solid transparent;
            border-radius: 10px;
            background: var(--blue);
            color: #fff;
            font: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            white-space: nowrap;
        }

        .button:hover {
            background: #204a8c;
            color: #fff;
            text-decoration: none;
        }

        .button-secondary {
            border-color: var(--border);
            background: #fff;
            color: var(--navy);
        }

        .button-secondary:hover {
            background: #f7f9fc;
            color: var(--navy);
        }

        .search-panel {
            padding: 24px;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            background: var(--surface);
            box-shadow: var(--shadow);
        }

        .panel-title {
            margin: 0 0 5px;
            color: var(--navy);
            font-size: 17px;
            font-weight: 750;
        }

        .panel-description {
            margin: 0 0 18px;
            color: var(--muted);
            font-size: 13px;
        }

        .search-form {
            display: flex;
            align-items: stretch;
            gap: 10px;
        }

        .search-input-wrap {
            position: relative;
            flex: 1;
            min-width: 0;
        }

        .search-input {
            width: 100%;
            min-height: 46px;
            padding: 12px 14px;
            border: 1px solid #cbd6e4;
            border-radius: 10px;
            background: #fff;
            color: var(--ink);
            font: inherit;
            font-size: 14px;
        }

        .search-input::placeholder {
            color: #8995a5;
        }

        .search-hint {
            margin: 11px 0 0;
            color: var(--muted);
            font-size: 12px;
        }

        .alert {
            margin-top: 18px;
            padding: 13px 15px;
            border: 1px solid #f1c7c3;
            border-radius: 10px;
            background: var(--red-soft);
            color: var(--red);
            font-size: 13px;
        }

        .results-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin: 30px 0 15px;
        }

        .results-heading h2 {
            margin: 0;
            color: var(--navy);
            font-size: 20px;
            letter-spacing: -0.025em;
        }

        .result-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 28px;
            padding: 4px 10px;
            border-radius: 999px;
            background: var(--blue-soft);
            color: var(--blue);
            font-size: 12px;
            font-weight: 750;
            white-space: nowrap;
        }

        .table-card {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            background: var(--surface);
            box-shadow: var(--shadow);
        }

        .table-scroll {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        thead {
            background: #f8fafd;
        }

        th {
            padding: 14px 18px;
            border-bottom: 1px solid var(--border);
            color: #68778b;
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 0.09em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        td {
            padding: 16px 18px;
            border-bottom: 1px solid #edf1f6;
            color: #344258;
            font-size: 13px;
            vertical-align: middle;
        }

        tbody tr:last-child td {
            border-bottom: 0;
        }

        tbody tr:hover {
            background: #fbfcff;
        }

        .member-name {
            display: block;
            color: var(--navy);
            font-weight: 750;
        }

        .member-code {
            display: block;
            margin-top: 3px;
            color: var(--muted);
            font-size: 11px;
        }

        .email {
            overflow-wrap: anywhere;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 9px;
            border-radius: 999px;
            background: #f0f3f8;
            color: #536278;
            font-size: 11px;
            font-weight: 750;
            white-space: nowrap;
        }

        .status-active {
            background: var(--green-soft);
            color: var(--green);
        }

        .status-inactive {
            background: #f0f2f5;
            color: #596579;
        }

        .status-suspended {
            background: #fff3dc;
            color: #946200;
        }

        .view-link {
            font-size: 12px;
            font-weight: 750;
            white-space: nowrap;
        }

        .empty-state {
            padding: 46px 22px;
            text-align: center;
        }

        .empty-icon {
            display: grid;
            width: 54px;
            height: 54px;
            margin: 0 auto 15px;
            place-items: center;
            border-radius: 16px;
            background: var(--blue-soft);
            color: var(--blue);
            font-size: 24px;
        }

        .empty-state h3 {
            margin: 0;
            color: var(--navy);
            font-size: 17px;
        }

        .empty-state p {
            max-width: 440px;
            margin: 8px auto 18px;
            color: var(--muted);
            font-size: 13px;
        }

        .footer {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            gap: 12px;
            margin-top: 28px;
            color: #7b8798;
            font-size: 11px;
        }

        @media (max-width: 760px) {
            .topbar-inner {
                min-height: 64px;
            }

            .topnav {
                gap: 12px;
            }

            .topnav a {
                font-size: 12px;
            }

            .container {
                padding-top: 25px;
            }

            .page-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .search-panel {
                padding: 18px;
            }

            .search-form {
                flex-direction: column;
            }

            .search-form .button {
                width: 100%;
            }

            .results-heading {
                align-items: flex-start;
            }
        }

        @media (max-width: 430px) {
            .topbar-inner,
            .container {
                width: min(100% - 28px, 1180px);
            }

            .brand-subtitle {
                display: none;
            }

            .topnav {
                gap: 10px;
            }

            .topnav a {
                font-size: 11px;
            }

            .results-heading h2 {
                font-size: 18px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
</head>

<body>
<header class="topbar">
    <div class="topbar-inner">
        <a class="brand"
           href="${pageContext.request.contextPath}/index.jsp"
           aria-label="Library Management System home">
            <span class="brand-mark" aria-hidden="true">▤</span>
            <span>
                Library Management
                <span class="brand-subtitle">Member administration</span>
            </span>
        </a>

        <nav class="topnav" aria-label="Main navigation">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/members">Members</a>
            <a href="${pageContext.request.contextPath}/members/search"
               aria-current="page">Search</a>
        </nav>
    </div>
</header>

<main class="container">
    <nav class="breadcrumb" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <span aria-hidden="true">/</span>
        <a href="${pageContext.request.contextPath}/members">Members</a>
        <span aria-hidden="true">/</span>
        <span aria-current="page">Search</span>
    </nav>

    <section class="page-heading">
        <div>
            <p class="eyebrow">Member directory</p>
            <h1>Search members</h1>
            <p class="subtitle">
                Find registered members by their name, member code,
                email address, or other supported search fields.
            </p>
        </div>

        <a class="button button-secondary"
           href="${pageContext.request.contextPath}/members">
            &larr; Back to directory
        </a>
    </section>

    <section class="search-panel" aria-labelledby="search-panel-title">
        <h2 class="panel-title" id="search-panel-title">Find a member</h2>
        <p class="panel-description">
            Enter a search term to view matching member records.
        </p>

        <form class="search-form"
              action="${pageContext.request.contextPath}/members/search"
              method="get"
              role="search">
            <div class="search-input-wrap">
                <label for="member-query"
                       style="position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0;">
                    Search by name, member code, or email
                </label>
                <input class="search-input"
                       id="member-query"
                       type="search"
                       name="q"
                       maxlength="150"
                       placeholder="Enter name, member code, or email..."
                       value="<c:out value='${searchQuery}'/>"
                       autocomplete="off">
            </div>

            <button class="button" type="submit">
                Search members
            </button>
        </form>

        <p class="search-hint">
            Search results depend on the fields supported by the member service.
        </p>

        <c:if test="${not empty errorMessage}">
            <div class="alert" role="alert">
                <strong>Search could not be completed.</strong>
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>
    </section>

    <c:if test="${not empty searchQuery or not empty errorMessage}">
        <section aria-labelledby="results-title">
            <div class="results-heading">
                <h2 id="results-title">Search results</h2>
                <span class="result-count">
                    <c:out value="${memberCount}"/> result(s)
                </span>
            </div>

            <div class="table-card">
                <c:choose>
                    <c:when test="${not empty members}">
                        <div class="table-scroll">
                            <table>
                                <thead>
                                <tr>
                                    <th scope="col">Member</th>
                                    <th scope="col">Contact</th>
                                    <th scope="col">Membership</th>
                                    <th scope="col">Status</th>
                                    <th scope="col">Valid until</th>
                                    <th scope="col">Action</th>
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
                                                ID:
                                                <c:out value="${member.memberCode}"/>
                                            </span>
                                        </td>

                                        <td>
                                            <span class="email">
                                                <c:out value="${member.email}"/>
                                            </span>
                                            <br>
                                            <c:out value="${member.phone}"/>
                                        </td>

                                        <td>
                                            <span class="badge">
                                                <c:out value="${member.membershipType}"/>
                                            </span>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${member.status == 'ACTIVE'}">
                                                    <span class="badge status-active">Active</span>
                                                </c:when>
                                                <c:when test="${member.status == 'INACTIVE'}">
                                                    <span class="badge status-inactive">Inactive</span>
                                                </c:when>
                                                <c:when test="${member.status == 'SUSPENDED'}">
                                                    <span class="badge status-suspended">Suspended</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge">
                                                        <c:out value="${member.status}"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:out value="${member.validUntil}"/>
                                        </td>

                                        <td>
                                            <a class="view-link"
                                               href="${pageContext.request.contextPath}/members/details?id=${member.id}">
                                                View details &rarr;
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon" aria-hidden="true">⌕</div>

                            <h3>
                                <c:choose>
                                    <c:when test="${not empty errorMessage}">
                                        Search needs attention
                                    </c:when>
                                    <c:when test="${empty searchQuery}">
                                        Start with a search term
                                    </c:when>
                                    <c:otherwise>
                                        No matching members found
                                    </c:otherwise>
                                </c:choose>
                            </h3>

                            <p>
                                <c:choose>
                                    <c:when test="${not empty errorMessage}">
                                        Correct the search input and try again.
                                    </c:when>
                                    <c:when test="${empty searchQuery}">
                                        Enter a name, member code, or email above
                                        to search the member directory.
                                    </c:when>
                                    <c:otherwise>
                                        Try a different spelling or a shorter
                                        search term, then search again.
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <a class="button button-secondary"
                               href="${pageContext.request.contextPath}/members">
                                Browse all members
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </c:if>

    <footer class="footer">
        <span>Library Management System</span>
        <span>Member Management · Search</span>
    </footer>
</main>
</body>
</html>