<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Issue Book | LMS</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/book-management.css">

    <style>
        .issue-form {
            max-width: 620px;
        }

        .issue-form .form-group {
            margin-bottom: 22px;
        }

        .issue-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .issue-form input {
            width: 100%;
            box-sizing: border-box;
        }

        .issue-note {
            margin-top: 8px;
            color: var(--ref-muted);
            font-size: 13px;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 26px;
        }
    </style>
</head>

<body>
<div class="app-shell">
    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="eyebrow">LIBRARY MANAGEMENT / CIRCULATION</p>
                <h1>Issue Book</h1>
                <p>Assign an available book to an active library member.</p>
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
                Book issued successfully.
                Issue ID:
                <c:out value="${param.issueId}"/>
            </div>
        </c:if>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <p class="eyebrow">NEW TRANSACTION</p>
                    <h2>Issue Details</h2>
                </div>
            </div>

            <form class="issue-form"
                  method="post"
                  action="${pageContext.request.contextPath}/issue">

                <div class="form-group">
                    <label for="memberCode">Member Code</label>
                    <input
                            type="text"
                            id="memberCode"
                            name="memberCode"
                            value="<c:out value='${memberCode}'/>"
                            placeholder="Enter member code"
                            required>
                    <p class="issue-note">
                        Enter the code of an active registered member.
                    </p>
                </div>

                <div class="form-group">
                    <label for="bookId">Book ID</label>
                    <input
                            type="number"
                            id="bookId"
                            name="bookId"
                            value="<c:out value='${bookId}'/>"
                            min="1"
                            placeholder="Enter book ID"
                            required>
                    <p class="issue-note">
                        You can find the Book ID in Book Management.
                    </p>
                </div>

                <div class="form-group">
                    <label for="dueDate">Due Date</label>
                    <input
                            type="date"
                            id="dueDate"
                            name="dueDate"
                            value="<c:out value='${dueDate}'/>"
                            min="<%= java.time.LocalDate.now() %>"
                            required>
                    <p class="issue-note">
                        Select the date by which the book should be returned.
                    </p>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        Issue Book
                    </button>

                    <a href="${pageContext.request.contextPath}/"
                       class="btn btn-quiet">
                        Cancel
                    </a>
                </div>

            </form>
        </section>

        <footer class="page-footer">
            <span>Library Management System</span>
            <span>Issue Book</span>
        </footer>

    </main>
</div>
</body>
</html>