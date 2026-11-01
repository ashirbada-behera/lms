<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Member Management | Library Management System</title>

  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/assets/css/book-management.css">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/assets/css/member-management.css">
</head>
<body>

<div class="app-shell">
  <main class="main-content">

    <header class="topbar">
      <div>
        <p class="eyebrow">LIBRARY MANAGEMENT SYSTEM / MEMBERS</p>
        <h1>Member Management</h1>
        <p>Manage library members, membership details and account status.</p>
      </div>

      <div class="header-actions">
        <a class="btn btn-quiet"
           href="${pageContext.request.contextPath}/index.jsp">
          Back to Dashboard
        </a>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/members/create">
          + Add Member
        </a>
      </div>
    </header>

    <c:if test="${not empty errorMessage}">
      <div class="alert alert-error" role="alert">
        <c:out value="${errorMessage}"/>
      </div>
    </c:if>

    <c:if test="${param.deactivated eq 'true'}">
      <div class="alert alert-success" role="status">
        Member deactivated successfully.
      </div>
    </c:if>

    <c:if test="${param.activated eq 'true'}">
      <div class="alert alert-success" role="status">
        Member activated successfully.
      </div>
    </c:if>

    <section class="panel">

      <div class="panel-heading">
        <div>
          <p class="eyebrow">DIRECTORY</p>
          <h2>Registered Members</h2>
        </div>
        <span class="result-count">
                    Total members:
                    <strong><c:out value="${memberCount}"/></strong>
                </span>
      </div>

      <form class="filter-form member-filter"
            method="get"
            action="${pageContext.request.contextPath}/members">

        <label class="visually-hidden" for="memberSearch">
          Search members
        </label>

        <input type="search"
               id="memberSearch"
               name="search"
               placeholder="Search by name, email, phone or member code..."
               value="<c:out value='${searchQuery}'/>">

        <label class="visually-hidden" for="memberStatus">
          Filter by status
        </label>

        <select id="memberStatus" name="status">
          <option value="">All Statuses</option>
          <option value="ACTIVE"
          ${selectedStatus eq 'ACTIVE' ? 'selected' : ''}>
            Active
          </option>
          <option value="INACTIVE"
          ${selectedStatus eq 'INACTIVE' ? 'selected' : ''}>
            Inactive
          </option>
          <option value="SUSPENDED"
          ${selectedStatus eq 'SUSPENDED' ? 'selected' : ''}>
            Suspended
          </option>
        </select>

        <button type="submit" class="btn btn-secondary">Search</button>

        <a class="btn btn-quiet"
           href="${pageContext.request.contextPath}/members">
          Reset
        </a>
      </form>

      <div class="table-wrap">
        <table class="data-table member-table">
          <thead>
          <tr>
            <th>Member Code</th>
            <th>Member</th>
            <th>Contact</th>
            <th>Membership</th>
            <th>Registered</th>
            <th>Valid Until</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
          </thead>

          <tbody>
          <c:choose>
            <c:when test="${not empty members}">
              <c:forEach var="member" items="${members}">
                <tr>
                  <td>
                                        <span class="member-code">
                                            <c:out value="${member.memberCode}"/>
                                        </span>
                  </td>

                  <td>
                    <div class="member-info-cell">
                      <strong>
                        <c:out value="${member.fullName}"/>
                      </strong>
                    </div>
                  </td>

                  <td>
                    <span><c:out value="${member.email}"/></span>
                    <span class="member-info-text">
                                            <c:out value="${member.phone}"/>
                                        </span>
                  </td>

                  <td>
                                        <span class="membership-label">
                                            <c:out value="${member.membershipType}"/>
                                        </span>
                  </td>

                  <td><c:out value="${member.registrationDate}"/></td>
                  <td><c:out value="${member.validUntil}"/></td>

                  <td>
                                        <span class="status-pill ${member.status eq 'ACTIVE' ? 'status-active' : member.status eq 'INACTIVE' ? 'status-inactive' : 'status-suspended'}">
                                            <c:out value="${member.status}"/>
                                        </span>
                  </td>

                  <td>
                    <div class="table-actions">
                      <a class="action-link"
                         href="${pageContext.request.contextPath}/members/details?id=${member.id}">
                        View
                      </a>

                      <a class="action-link"
                         href="${pageContext.request.contextPath}/members/edit?id=${member.id}">
                        Edit
                      </a>

                      <c:choose>

                        <c:when test="${member.status eq 'ACTIVE'}">
                          <form method="post"
                                action="${pageContext.request.contextPath}/members/deactivate"
                                onsubmit="return confirm('Are you sure you want to deactivate this member?');">

                            <input type="hidden" name="id"
                                   value="<c:out value='${member.id}'/>">

                            <input type="hidden" name="csrfToken"
                                   value="<c:out value='${csrfToken}'/>">

                            <button type="submit" class="action-link action-delete">
                              Deactivate
                            </button>
                          </form>
                        </c:when>

                        <c:otherwise>
                          <form method="post"
                                action="${pageContext.request.contextPath}/members/activate"
                                onsubmit="return confirm('Are you sure you want to activate this member?');">

                            <input type="hidden" name="id"
                                   value="<c:out value='${member.id}'/>">

                            <input type="hidden" name="csrfToken"
                                   value="<c:out value='${csrfToken}'/>">

                            <button type="submit" class="action-link action-activate">
                              Activate
                            </button>

                          </form>

                        </c:otherwise>

                      </c:choose>

                    </div>
                  </td>
                </tr>
              </c:forEach>
            </c:when>

            <c:otherwise>
              <tr>
                <td colspan="8" class="empty-state">
                  <strong>No members found.</strong>
                  <p>Try changing your search or add a new member.</p>
                </td>
              </tr>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </section>

    <footer class="page-footer">
      <span>Library Management System</span>
      <span>Member Management</span>
    </footer>

  </main>
</div>

</body>
</html>