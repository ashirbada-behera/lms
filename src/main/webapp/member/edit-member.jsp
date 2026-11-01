<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Member | Library Management System</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/book-management.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member-management.css">

  <style>
    .member-form-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 20px;
      padding: 24px 0;
    }

    .form-field {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .form-field.full-width {
      grid-column: 1 / -1;
    }

    .form-field label {
      color: var(--ref-text);
      font-size: 12px;
      font-weight: 700;
    }

    .form-field input,
    .form-field select,
    .form-field textarea {
      width: 100%;
      box-sizing: border-box;
      padding: 12px;
      border: 1px solid var(--ref-border);
      border-radius: 7px;
      background: var(--ref-surface);
      color: var(--ref-text);
      font: inherit;
    }

    .form-field textarea {
      min-height: 90px;
      resize: vertical;
    }

    .form-field input:focus,
    .form-field select:focus,
    .form-field textarea:focus {
      outline: 2px solid var(--ref-light-green);
      border-color: var(--ref-green);
    }

    .form-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 10px;
    }

    .required-mark {
      color: var(--ref-terracotta);
    }

    @media (max-width: 650px) {
      .member-form-grid {
        grid-template-columns: 1fr;
      }

      .form-field.full-width {
        grid-column: auto;
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
        <h1>Edit Member</h1>
        <p>Update the member's personal and membership information.</p>
      </div>

      <a class="btn btn-quiet"
         href="${pageContext.request.contextPath}/members">
        Back to Members
      </a>
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
          <h2>Update Member Details</h2>
        </div>
        <span class="member-code">
                    <c:out value="${member.memberCode}"/>
                </span>
      </div>

      <form method="post"
            action="${pageContext.request.contextPath}/members/edit">

        <input type="hidden" name="id" value="<c:out value='${member.id}'/>">
        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

        <div class="member-form-grid">

          <div class="form-field">
            <label for="fullName">Full Name <span class="required-mark">*</span></label>
            <input type="text" id="fullName" name="fullName"
                   maxlength="120" required
                   value="<c:out value='${member.fullName}'/>">
          </div>

          <div class="form-field">
            <label for="email">Email Address <span class="required-mark">*</span></label>
            <input type="email" id="email" name="email"
                   maxlength="150" required
                   value="<c:out value='${member.email}'/>">
          </div>

          <div class="form-field">
            <label for="phone">Phone Number <span class="required-mark">*</span></label>
            <input type="tel" id="phone" name="phone"
                   maxlength="20" required
                   value="<c:out value='${member.phone}'/>">
          </div>

          <div class="form-field">
            <label for="dateOfBirth">Date of Birth</label>
            <input type="date" id="dateOfBirth" name="dateOfBirth"
                   value="<c:out value='${member.dateOfBirth}'/>">
          </div>

          <div class="form-field">
            <label for="gender">Gender</label>
            <select id="gender" name="gender">
              <option value="">Select Gender</option>
              <option value="MALE" ${member.gender eq 'MALE' ? 'selected' : ''}>Male</option>
              <option value="FEMALE" ${member.gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
              <option value="OTHER" ${member.gender eq 'OTHER' ? 'selected' : ''}>Other</option>
            </select>
          </div>

          <div class="form-field">
            <label for="membershipType">Membership Type <span class="required-mark">*</span></label>
            <select id="membershipType" name="membershipType" required>
              <option value="">Select Membership Type</option>
              <option value="STUDENT" ${member.membershipType eq 'STUDENT' ? 'selected' : ''}>Student</option>
              <option value="FACULTY" ${member.membershipType eq 'FACULTY' ? 'selected' : ''}>Faculty</option>
              <option value="STAFF" ${member.membershipType eq 'STAFF' ? 'selected' : ''}>Staff</option>
              <option value="GENERAL" ${member.membershipType eq 'GENERAL' ? 'selected' : ''}>General</option>
            </select>
          </div>

          <div class="form-field">
            <label for="registrationDate">Registration Date <span class="required-mark">*</span></label>
            <input type="date" id="registrationDate" name="registrationDate"
                   required value="<c:out value='${member.registrationDate}'/>">
          </div>

          <div class="form-field">
            <label for="validUntil">Valid Until <span class="required-mark">*</span></label>
            <input type="date" id="validUntil" name="validUntil"
                   required value="<c:out value='${member.validUntil}'/>">
          </div>

          <div class="form-field full-width">
            <label for="address">Address</label>
            <textarea id="address" name="address"
                      maxlength="500"><c:out value="${member.address}"/></textarea>
          </div>

        </div>

        <div class="form-actions">
          <button type="submit" class="btn btn-primary">Save Changes</button>

          <a class="btn btn-secondary"
             href="${pageContext.request.contextPath}/members/details?id=${member.id}">
            Cancel
          </a>
        </div>

      </form>
    </section>

    <footer class="page-footer">
      <span>Library Management System</span>
      <span>Edit Member</span>
    </footer>

  </main>
</div>

</body>
</html>