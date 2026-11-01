<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Member Details | Library Management System</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/book-management.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member-management.css">

  <style>
    .member-details-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 20px;
      padding: 24px 0;
    }

    .detail-item {
      padding: 15px;
      background: var(--ref-cream);
      border: 1px solid var(--ref-border);
      border-radius: 8px;
      min-width: 0;
    }

    .detail-item label {
      display: block;
      color: var(--ref-muted);
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: .7px;
      margin-bottom: 8px;
    }

    .detail-item strong {
      display: block;
      color: var(--ref-text);
      font-size: 14px;
      overflow-wrap: anywhere;
    }

    .details-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 20px;
    }

    @media (max-width: 650px) {
      .member-details-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<div class="app-shell">
  <main class="main-content">

    <header class="topbar">
      <div>
        <p class="eyebrow">LIBRARY MANAGEMENT SYSTEM / MEMBERS</p>
        <h1>Member Details</h1>
        <p>View the complete information of this library member.</p>
      </div>

      <div class="header-actions">
        <a class="btn btn-quiet"
           href="${pageContext.request.contextPath}/members">
          Back to Members
        </a>
        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/members/edit?id=${member.id}">
          Edit Member
        </a>
      </div>
    </header>

    <c:if test="${param.created eq 'true'}">
      <div class="alert alert-success" role="status">
        Member registered successfully.
      </div>
    </c:if>

    <c:if test="${param.updated eq 'true'}">
      <div class="alert alert-success" role="status">
        Member details updated successfully.
      </div>
    </c:if>

    <section class="panel">

      <div class="panel-heading">
        <div>
          <p class="eyebrow">MEMBER PROFILE</p>
          <h2><c:out value="${member.fullName}"/></h2>
        </div>

        <span class="status-pill ${member.status eq 'ACTIVE' ? 'status-active' : member.status eq 'INACTIVE' ? 'status-inactive' : 'status-suspended'}">
                    <c:out value="${member.status}"/>
                </span>
      </div>

      <div class="member-details-grid">

        <div class="detail-item">
          <label>Member Code</label>
          <strong class="member-code">
            <c:out value="${member.memberCode}"/>
          </strong>
        </div>

        <div class="detail-item">
          <label>Full Name</label>
          <strong><c:out value="${member.fullName}"/></strong>
        </div>

        <div class="detail-item">
          <label>Email Address</label>
          <strong><c:out value="${member.email}"/></strong>
        </div>

        <div class="detail-item">
          <label>Phone Number</label>
          <strong><c:out value="${member.phone}"/></strong>
        </div>

        <div class="detail-item">
          <label>Date of Birth</label>
          <strong>
            <c:out value="${member.dateOfBirth}" default="Not provided"/>
          </strong>
        </div>

        <div class="detail-item">
          <label>Gender</label>
          <strong>
            <c:out value="${member.gender}" default="Not provided"/>
          </strong>
        </div>

        <div class="detail-item">
          <label>Membership Type</label>
          <strong><c:out value="${member.membershipType}"/></strong>
        </div>

        <div class="detail-item">
          <label>Registration Date</label>
          <strong><c:out value="${member.registrationDate}"/></strong>
        </div>

        <div class="detail-item">
          <label>Membership Valid Until</label>
          <strong><c:out value="${member.validUntil}"/></strong>
        </div>

        <div class="detail-item">
          <label>Account Status</label>
          <strong><c:out value="${member.status}"/></strong>
        </div>

        <div class="detail-item" style="grid-column: 1 / -1;">
          <label>Address</label>
          <strong>
            <c:out value="${member.address}" default="Not provided"/>
          </strong>
        </div>

      </div>

      <div class="details-actions">
        <a class="btn btn-secondary"
           href="${pageContext.request.contextPath}/members">
          Back to Member List
        </a>

        <a class="btn btn-primary"
           href="${pageContext.request.contextPath}/members/edit?id=${member.id}">
          Edit Member Details
        </a>
      </div>

    </section>

    <footer class="page-footer">
      <span>Library Management System</span>
      <span>Member Details</span>
    </footer>

  </main>
</div>

</body>
</html>