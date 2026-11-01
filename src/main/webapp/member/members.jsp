```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta name="description"
          content="Manage library members, contact details, and membership status.">

    <meta name="theme-color" content="#f5f1e9">

    <title>Member Management | LMS</title>

    <!-- Load shared theme first -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/lms-editorial-theme.css">

    <!-- Load Member Management styles last -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/member-management.css">
</head>

<body class="members-page">

<div class="app-shell">

    <main class="main-content">

        <!-- PAGE HEADER -->
        <header class="topbar">
            <div>
                <div class="eyebrow">WORKSPACE / MEMBERS</div>

                <h1>Member Management</h1>

                <p class="page-subtitle">
                    Manage member records and membership information.
                </p>
            </div>

            <a class="btn btn-primary"
               href="${pageContext.request.contextPath}/members/create">
                <span aria-hidden="true">＋</span>
                Add member
            </a>
        </header>

        <!-- ERROR MESSAGE -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <!-- MEMBER SUMMARY -->
        <section class="stats-grid" aria-label="Member summary">

            <article class="stat-card stat-card-members">

                <div class="stat-card-icon stat-card-icon-blue"
                     aria-hidden="true">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.8"
                         stroke-linecap="round"
                         stroke-linejoin="round">
                        <circle cx="9" cy="8" r="3.5"/>
                        <path d="M2 20v-1.5a7 7 0 0 1 14 0V20"/>
                        <path d="M16 5a3.5 3.5 0 0 1 0 7"/>
                        <path d="M18 14a5.5 5.5 0 0 1 4 5.3V20"/>
                    </svg>
                </div>

                <div class="stat-card-copy">
                    <div class="stat-label">MATCHING MEMBERS</div>

                    <div class="stat-value">
                        <c:out value="${memberCount}" default="0"/>
                    </div>

                    <div class="stat-note">
                        Records in the current result
                    </div>
                </div>

                <div class="stat-card-decoration stat-decoration-people"
                     aria-hidden="true">
                    <svg viewBox="0 0 100 70" fill="currentColor">
                        <circle cx="36" cy="17" r="12"/>
                        <circle cx="64" cy="14" r="11"/>
                        <path d="M12 60c0-17 9-27 24-27s24 10 24 27z"/>
                        <path d="M49 59c1-15 8-25 19-25 13 0 20 10 20 25z"/>
                    </svg>
                </div>

            </article>

            <article class="stat-card stat-card-accent">

                <div class="stat-card-icon stat-card-icon-purple"
                     aria-hidden="true">
                    <svg viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.8"
                         stroke-linecap="round"
                         stroke-linejoin="round">
                        <path d="M4 5h16l-6.5 7.5v5L10 20v-7.5z"/>
                    </svg>
                </div>

                <div class="stat-card-copy">
                    <div class="stat-label">CURRENT VIEW</div>

                    <div class="stat-value stat-value-text">
                        <c:choose>
                            <c:when test="${selectedStatus eq 'ACTIVE'}">
                                Active members
                            </c:when>

                            <c:when test="${selectedStatus eq 'INACTIVE'}">
                                Inactive members
                            </c:when>

                            <c:when test="${selectedStatus eq 'SUSPENDED'}">
                                Suspended members
                            </c:when>

                            <c:otherwise>
                                All statuses
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="stat-note">
                        Use filters to narrow the list
                    </div>
                </div>

                <div class="stat-card-decoration stat-decoration-filter"
                     aria-hidden="true">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>

            </article>

        </section>

        <!-- MEMBER DIRECTORY -->
        <section class="panel" aria-labelledby="directory-title">

            <div class="panel-heading">

                <div class="directory-heading">

                    <div class="directory-heading-icon"
                         aria-hidden="true">
                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8"
                             stroke-linecap="round"
                             stroke-linejoin="round">
                            <circle cx="9" cy="8" r="3.5"/>
                            <path d="M2 20v-1.5a7 7 0 0 1 14 0V20"/>
                            <path d="M16 5a3.5 3.5 0 0 1 0 7"/>
                            <path d="M18 14a5.5 5.5 0 0 1 4 5.3V20"/>
                        </svg>
                    </div>

                    <div>
                        <h2 id="directory-title">Member directory</h2>
                        <p>
                            Search, filter and open individual member records.
                        </p>
                    </div>

                </div>

            </div>

            <!-- SEARCH AND FILTER -->
            <form class="filter-form"
                  method="get"
                  action="${pageContext.request.contextPath}/members">

                <div class="field filter-search">

                    <label for="search">Search members</label>

                    <div class="search-input-wrap">

                        <span class="search-icon" aria-hidden="true">
                            <svg viewBox="0 0 24 24"
                                 fill="none"
                                 stroke="currentColor"
                                 stroke-width="2"
                                 stroke-linecap="round">
                                <circle cx="10.8" cy="10.8" r="6.5"/>
                                <path d="m16 16 4.5 4.5"/>
                            </svg>
                        </span>

                        <input
                            id="search"
                            name="q"
                            type="search"
                            maxlength="150"
                            placeholder="Name, code, email or phone"
                            value="<c:out value='${searchQuery}'/>"
                            autocomplete="off">

                    </div>

                </div>

                <div class="field filter-status">

                    <label for="status">Membership status</label>

                    <select id="status" name="status">

                        <option value=""
                            <c:if test="${empty selectedStatus}">
                                selected="selected"
                            </c:if>>
                            All statuses
                        </option>

                        <option value="ACTIVE"
                            <c:if test="${selectedStatus eq 'ACTIVE'}">
                                selected="selected"
                            </c:if>>
                            Active
                        </option>

                        <option value="INACTIVE"
                            <c:if test="${selectedStatus eq 'INACTIVE'}">
                                selected="selected"
                            </c:if>>
                            Inactive
                        </option>

                        <option value="SUSPENDED"
                            <c:if test="${selectedStatus eq 'SUSPENDED'}">
                                selected="selected"
                            </c:if>>
                            Suspended
                        </option>

                    </select>

                </div>

                <div class="filter-actions">

                    <button class="btn btn-primary" type="submit">
                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M4 5h16l-6.5 7.5v5L10 20v-7.5z"/>
                        </svg>
                        Apply filters
                    </button>

                    <a class="btn btn-secondary"
                       href="${pageContext.request.contextPath}/members">
                        <svg viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M20 7v5h-5"/>
                            <path d="M20 12a8 8 0 1 0 2 5"/>
                        </svg>
                        Reset
                    </a>

                </div>

            </form>

            <!-- MEMBER TABLE -->
            <div class="table-wrap">

                <table class="data-table"
                       aria-label="Library member directory">

                    <caption class="visually-hidden">
                        Library members and their membership information
                    </caption>

                    <thead>
                    <tr>
                        <th scope="col">MEMBER</th>
                        <th scope="col">MEMBER CODE</th>
                        <th scope="col">CONTACT</th>
                        <th scope="col">MEMBERSHIP</th>
                        <th scope="col">STATUS</th>
                        <th scope="col" class="align-right">ACTIONS</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:choose>

                        <c:when test="${not empty members}">

                            <c:forEach var="member" items="${members}">

                                <tr>

                                    <!-- MEMBER INFORMATION -->
                                    <td>
                                        <div class="member-cell">

                                            <div class="member-avatar"
                                                 aria-hidden="true">

                                                <c:choose>
                                                    <c:when test="${not empty member.fullName}">
                                                        <c:out value="${member.fullName.substring(0, 1)}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        M
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>

                                            <div class="member-primary">

                                                <strong>
                                                    <c:out value="${member.fullName}"
                                                           default="Unnamed member"/>
                                                </strong>

                                                <span>
                                                    <c:out value="${member.email}"
                                                           default="No email available"/>
                                                </span>

                                            </div>

                                        </div>
                                    </td>

                                    <!-- MEMBER CODE -->
                                    <td>
                                        <span class="code-pill">
                                            <c:out value="${member.memberCode}"
                                                   default="—"/>
                                        </span>
                                    </td>

                                    <!-- CONTACT -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty member.phone}">
                                                <c:out value="${member.phone}"/>
                                            </c:when>
                                            <c:otherwise>
                                                —
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- MEMBERSHIP TYPE -->
                                    <td>
                                        <c:out value="${member.membershipType}"
                                               default="—"/>
                                    </td>

                                    <!-- MEMBER STATUS -->
                                    <td>
                                        <c:choose>

                                            <c:when test="${member.status eq 'ACTIVE'}">
                                                <span class="status-badge status-active">
                                                    <span class="status-symbol"
                                                          aria-hidden="true">✓</span>
                                                    <span>ACTIVE</span>
                                                </span>
                                            </c:when>

                                            <c:when test="${member.status eq 'INACTIVE'}">
                                                <span class="status-badge status-inactive">
                                                    <span class="status-symbol"
                                                          aria-hidden="true">×</span>
                                                    <span>INACTIVE</span>
                                                </span>
                                            </c:when>

                                            <c:when test="${member.status eq 'SUSPENDED'}">
                                                <span class="status-badge status-suspended">
                                                    <span class="status-symbol"
                                                          aria-hidden="true">!</span>
                                                    <span>SUSPENDED</span>
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status-badge status-inactive">
                                                    <span class="status-symbol"
                                                          aria-hidden="true">?</span>
                                                    <span>UNKNOWN</span>
                                                </span>
                                            </c:otherwise>

                                        </c:choose>
                                    </td>

                                    <!-- ACTIONS -->
                                    <td class="align-right action-cell">

                                        <a class="text-link action-view"
                                           href="${pageContext.request.contextPath}/members/details?id=${member.id}"
                                           aria-label="View details for ${member.fullName}">

                                            <svg viewBox="0 0 24 24"
                                                 fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="1.9"
                                                 stroke-linecap="round"
                                                 stroke-linejoin="round"
                                                 aria-hidden="true">
                                                <path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6-10-6-10-6z"/>
                                                <circle cx="12" cy="12" r="2.5"/>
                                            </svg>

                                            View
                                        </a>

                                        <a class="text-link action-edit"
                                           href="${pageContext.request.contextPath}/members/edit?id=${member.id}"
                                           aria-label="Edit ${member.fullName}">

                                            <svg viewBox="0 0 24 24"
                                                 fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="1.9"
                                                 stroke-linecap="round"
                                                 stroke-linejoin="round"
                                                 aria-hidden="true">
                                                <path d="m14 5 5 5"/>
                                                <path d="M4 20l4.5-1 10-10a2.1 2.1 0 0 0-3-3l-10 10L4 20z"/>
                                            </svg>

                                            Edit
                                        </a>

                                    </td>

                                </tr>

                            </c:forEach>

                        </c:when>

                        <!-- EMPTY STATE -->
                        <c:otherwise>

                            <tr>
                                <td colspan="6">

                                    <div class="empty-state">

                                        <div class="empty-icon"
                                             aria-hidden="true">⌕</div>

                                        <strong>No members found</strong>

                                        <p>
                                            Try changing your search or status filter.
                                        </p>

                                        <a class="text-link"
                                           href="${pageContext.request.contextPath}/members">
                                            Clear filters
                                        </a>

                                    </div>

                                </td>
                            </tr>

                        </c:otherwise>

                    </c:choose>

                    </tbody>

                </table>

            </div>

            <!-- RESULT COUNT -->
            <div class="table-footer">

                Showing

                <strong>
                    <c:out value="${memberCount}" default="0"/>
                </strong>

                matching record(s)

            </div>

        </section>

        <!-- FOOTER -->
        <footer class="page-footer">
            Library Management System
            <span aria-hidden="true">•</span>
            Member workspace
        </footer>

    </main>

</div>

</body>
</html>
```