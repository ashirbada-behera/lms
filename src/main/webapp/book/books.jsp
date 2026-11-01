<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Book Catalogue | LMS</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/book-management.css">

    <style>
        .book-info-cell {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 210px;
        }

        .book-cover-thumb,
        .book-cover-placeholder {
            width: 48px;
            height: 64px;
            flex-shrink: 0;
            border: 1px solid var(--ref-border);
            border-radius: 6px;
            background: var(--ref-cream);
        }

        .book-cover-thumb {
            object-fit: cover;
        }

        .book-cover-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--ref-muted);
            font-size: 10px;
            text-align: center;
        }

        .book-info-text {
            min-width: 0;
        }

        .book-info-text strong {
            display: block;
            overflow-wrap: anywhere;
        }

        .book-info-text .table-subtitle {
            display: block;
            margin-top: 4px;
        }

        .table-actions form {
            margin: 0;
        }

        .action-link:focus-visible,
        .btn:focus-visible {
            outline: 2px solid var(--ref-terracotta);
            outline-offset: 3px;
        }

        @media (max-width: 760px) {
            .book-info-cell {
                min-width: 190px;
            }
        }
    </style>
</head>

<body>
<div class="app-shell">

    <main class="main-content">

        <header class="topbar">
            <div>
                <p class="eyebrow">LIBRARY MANAGEMENT / CATALOGUE</p>
                <h1>Book Management</h1>
                <p>Manage titles, authors and book availability.</p>
            </div>

            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/"
                   class="btn btn-quiet">
                    &larr; Back to Dashboard
                </a>

                <a class="btn btn-primary"
                   href="${pageContext.request.contextPath}/books?action=new">
                    + Add Book
                </a>
            </div>
        </header>

        <c:if test="${not empty error}">
            <div class="alert alert-error" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <section class="panel">

            <div class="panel-heading">
                <div>
                    <p class="eyebrow">COLLECTION</p>
                    <h2>Book Catalogue</h2>
                </div>

                <span class="result-count">
                    <c:out value="${empty books ? 0 : books.size()}"/> records
                </span>
            </div>

            <form class="filter-form"
                  method="get"
                  action="${pageContext.request.contextPath}/books">

                <label class="visually-hidden" for="keyword">
                    Search books
                </label>

                <input id="keyword"
                       type="search"
                       name="keyword"
                       placeholder="Search by title, author, ISBN or category..."
                       value="<c:out value='${keyword}'/>">

                <button class="btn btn-secondary" type="submit">
                    Search
                </button>

                <a class="btn btn-quiet"
                   href="${pageContext.request.contextPath}/books">
                    Reset
                </a>
            </form>

            <div class="table-wrap">

                <table class="data-table">

                    <thead>
                    <tr>
                        <th>ISBN</th>
                        <th>Book / Author</th>
                        <th>Category</th>
                        <th>Total Copies</th>
                        <th>Available</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:choose>

                        <c:when test="${empty books}">
                            <tr>
                                <td colspan="7" class="empty-state">
                                    No books found. Add a book or try another search.
                                </td>
                            </tr>
                        </c:when>

                        <c:otherwise>

                            <c:forEach var="book" items="${books}">

                                <tr>

                                    <td>
                                        <c:out value="${book.isbn}"/>
                                    </td>

                                    <td>
                                        <div class="book-info-cell">

                                            <c:choose>
                                                <c:when test="${not empty book.coverImagePath}">
                                                    <img
                                                            class="book-cover-thumb"
                                                            src="<c:out value='${pageContext.request.contextPath}${book.coverImagePath}'/>"
                                                            alt="Book cover"
                                                            loading="lazy"
                                                            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">

                                                    <div class="book-cover-placeholder"
                                                         style="display:none;">
                                                        No Cover
                                                    </div>
                                                </c:when>

                                                <c:otherwise>
                                                    <div class="book-cover-placeholder">
                                                        No Cover
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="book-info-text">
                                                <strong>
                                                    <c:out value="${book.title}"/>
                                                </strong>

                                                <span class="table-subtitle">
                                                    <c:out value="${book.author}"/>
                                                </span>
                                            </div>

                                        </div>
                                    </td>

                                    <td>
                                        <c:out value="${book.category}"/>
                                    </td>

                                    <td>
                                        <c:out value="${book.totalCopies}"/>
                                    </td>

                                    <td>
                                        <c:out value="${book.availableCopies}"/>
                                    </td>

                                    <td>
                                        <c:choose>

                                            <c:when test="${book.availableCopies == 0}">
                                                <span class="status-pill status-empty">
                                                    Out of Stock
                                                </span>
                                            </c:when>

                                            <c:when test="${book.availableCopies <= 2}">
                                                <span class="status-pill status-low">
                                                    Low Stock
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status-pill status-available">
                                                    Available
                                                </span>
                                            </c:otherwise>

                                        </c:choose>
                                    </td>

                                    <td>
                                        <div class="table-actions">

                                            <a class="action-link"
                                               href="${pageContext.request.contextPath}/books?action=edit&amp;id=${book.id}"
                                               aria-label="Edit book">
                                                Edit
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/books"
                                                  onsubmit="return confirm('Are you sure you want to delete this book?');">

                                                <input type="hidden"
                                                       name="action"
                                                       value="delete">

                                                <input type="hidden"
                                                       name="id"
                                                       value="<c:out value='${book.id}'/>">

                                                <button class="action-link action-delete"
                                                        type="submit"
                                                        aria-label="Delete book">
                                                    Delete
                                                </button>

                                            </form>

                                        </div>
                                    </td>

                                </tr>

                            </c:forEach>

                        </c:otherwise>

                    </c:choose>

                    </tbody>

                </table>

            </div>

        </section>

        <footer class="page-footer">
            <span>Library Management System</span>
            <span>Book Catalogue</span>
        </footer>

    </main>

</div>
</body>
</html>
