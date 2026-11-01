<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Return Book | LMS</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/book-management.css">

    <style>
        .return-form {
            display: flex;
            align-items: end;
            gap: 12px;
            flex-wrap: wrap;
            max-width: 650px;
        }

        .return-form .form-group {
            flex: 1;
            min-width: 220px;
        }

        .return-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .return-form input {
            width: 100%;
            box-sizing: border-box;
        }

        .issue-search-panel {
            margin-bottom: 24px;
        }

        .table-actions form {
            margin: 0;
        }

        .return-button {
            border: none;
            background: none;
            padding: 0;
            cursor: pointer;
            font: inherit;
        }

        .fine-note {
            margin-top: 14px;
            color: var(--ref-muted);
            font-size: 13px;
        }

        @media (max-width: 600px) {
            .return-form {
                align-items: stretch;
            }

            .return-form .form-group {
                min-width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="app-shell">
    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="eyebrow">LIBRARY MANAGEMENT / CIRCULATION</p>
                <h1>Return Book</h1>
                <p>Find a member's active loans and process book returns.</p>
            </div>

            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/"
                   class="btn btn-quiet">
                    &larr; Back to Dashboard
                </a>
            </div>
        </header>

        <c:if test="${not empty error}">
            <div class="alert alert-error" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <c:if test="${param.success == '1'}">
            <div class="alert alert-success" role="status">
                Book returned successfully.
            </div>
        </c:if>

        <section class="panel issue-search-panel">

            <div class="panel-heading">
                <div>
                    <p class="eyebrow">MEMBER LOOKUP</p>
                    <h2>Find Issued Books</h2>
                </div>
            </div>

            <form class="return-form"
                  method="get"
                  action="${pageContext.request.contextPath}/return">

                <div class="form-group">
                    <label for="memberCode">Member Code</label>
                    <input
                            type="text"
                            id="memberCode"
                            name="memberCode"
                            value="<c:out value='${memberCode}'/>"
                            placeholder="Enter member code"
                            required>
                </div>

                <button type="submit" class="btn btn-primary">
                    Search
                </button>

            </form>
        </section>

        <c:if test="${not empty memberCode}">
            <section class="panel">

                <div class="panel-heading">
                    <div>
                        <p class="eyebrow">ACTIVE TRANSACTIONS</p>
                        <h2>Issued Books</h2>
                    </div>

                    <span class="result-count">
                        <c:out value="${empty issues ? 0 : issues.size()}"/>
                        active issues
                    </span>
                </div>

                <div class="table-wrap">
                    <table class="data-table">

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
                        <c:choose>

                            <c:when test="${empty issues}">
                                <tr>
                                    <td colspan="5" class="empty-state">
                                        No active issued books found for this member.
                                    </td>
                                </tr>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="issue" items="${issues}">
                                    <tr>

                                        <td>
                                            <c:out value="${issue.issueId}"/>
                                        </td>

                                        <td>
                                            <c:out value="${issue.bookId}"/>
                                        </td>

                                        <td>
                                            <c:out value="${issue.issueDate}"/>
                                        </td>

                                        <td>
                                            <c:out value="${issue.dueDate}"/>
                                        </td>

                                        <td>
                                            <form
                                                    method="post"
                                                    action="${pageContext.request.contextPath}/return"
                                                    onsubmit="return confirm('Are you sure you want to return this book?');">

                                                <input
                                                        type="hidden"
                                                        name="memberCode"
                                                        value="<c:out value='${memberCode}'/>">

                                                <input
                                                        type="hidden"
                                                        name="issueId"
                                                        value="<c:out value='${issue.issueId}'/>">

                                                <button
                                                        type="submit"
                                                        class="action-link return-button">
                                                    Return Book
                                                </button>
                                            </form>
                                        </td>

                                    </tr>
                                </c:forEach>
                            </c:otherwise>

                        </c:choose>
                        </tbody>

                    </table>
                </div>

                <p class="fine-note">
                    Fine policy: The first 3 overdue days are free.
                    From the 4th overdue day, the fine is ₹5 per additional day.
                </p>

            </section>
        </c:if>

        <footer class="page-footer">
            <span>Library Management System</span>
            <span>Return Book</span>
        </footer>

    </main>
</div>
</body>
</html>