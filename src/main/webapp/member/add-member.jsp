<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Member | Library Management System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/book-management.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member-management.css">
</head>
<body>
<div class="app-shell">
  <main class="main-content">

    <header class="topbar">
      <div>
        <p class="eyebrow">LIBRARY MANAGEMENT SYSTEM / MEMBERS</p>
        <h1>Add New Member</h1>
        <p>Register a new member in the library.</p>
      </div>
      <div class="header-actions">
        <a class="btn btn-quiet" href="${pageContext.request.contextPath}/members">Back to Members</a>
      </div>
    </header>

    <c:if test="${not empty errorMessage}">
      <div class="alert alert-error" role="alert">
        <c:out value="${errorMessage}"/>
      </div>
    </c:if>

    <section class="panel">
      <div class="panel-heading">
        <div>
          <p class="eyebrow">MEMBER INFORMATION</p>
          <h2>Personal and Membership Details</h2>
        </div>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/members/create">

        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

        <div class="form-grid">
          <div class="form-group">
            <label for="fullName">Full Name *</label>
            <input type="text" id="fullName" name="fullName" maxlength="120"
                   value="<c:out value='${fullName}'/>" required>
          </div>

          <div class="form-group">
            <label for="email">Email Address *</label>
            <input type="email" id="email" name="email" maxlength="150"
                   value="<c:out value='${email}'/>" required>
          </div>

          <div class="form-group">
            <label for="phone">Phone Number *</label>
            <input type="tel" id="phone" name="phone" maxlength="20"
                   value="<c:out value='${phone}'/>" required>
          </div>

          <div class="form-group">
            <label for="dateOfBirth">Date of Birth</label>
            <input type="date" id="dateOfBirth" name="dateOfBirth"
                   value="<c:out value='${dateOfBirth}'/>">
          </div>

          <div class="form-group">
            <label for="gender">Gender</label>
            <select id="gender" name="gender">
              <option value="">Select Gender</option>
              <option value="MALE" ${gender eq 'MALE' ? 'selected' : ''}>Male</option>
              <option value="FEMALE" ${gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
              <option value="OTHER" ${gender eq 'OTHER' ? 'selected' : ''}>Other</option>
            </select>
          </div>

          <div class="form-group">
            <label for="membershipType">Membership Type *</label>
            <select id="membershipType" name="membershipType" required>
              <option value="">Select Membership Type</option>
              <option value="STUDENT" ${membershipType eq 'STUDENT' ? 'selected' : ''}>Student</option>
              <option value="FACULTY" ${membershipType eq 'FACULTY' ? 'selected' : ''}>Faculty</option>
              <option value="STAFF" ${membershipType eq 'STAFF' ? 'selected' : ''}>Staff</option>
              <option value="GENERAL" ${membershipType eq 'GENERAL' ? 'selected' : ''}>General</option>
            </select>
          </div>

          <div class="form-group form-group-full">
            <label for="address">Address</label>
            <textarea id="address" name="address" rows="4" maxlength="500"><c:out value="${address}"/></textarea>
          </div>
        </div>

        <div class="form-actions">
          <a class="btn btn-quiet" href="${pageContext.request.contextPath}/members">Cancel</a>
          <button type="submit" class="btn btn-primary">Save Member</button>
        </div>
      </form>
    </section>

    <footer class="page-footer">
      <span>Library Management System</span>
      <span>Add Member</span>
    </footer>

  </main>
</div>
</body>
</html>
