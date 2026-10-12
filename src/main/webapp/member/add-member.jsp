
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Member | LMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member-management.css">
</head>
<body>
<div class="app-shell">
    <aside class="sidebar">
        <a class="brand" href="${pageContext.request.contextPath}/members">
            <span class="brand-mark">L</span>
            <span><strong>LIBRARY</strong><small>MANAGEMENT SYSTEM</small></span>
        </a>
        <div class="sidebar-caption">WORKSPACE</div>
        <nav class="sidebar-nav">
            <a class="nav-link active" href="${pageContext.request.contextPath}/members">
                <span class="nav-icon">▦</span> Member Management
            </a>
        </nav>
        <div class="sidebar-bottom">
            <div class="sidebar-avatar">LM</div>
            <div><strong>Library Management</strong><small>Member workspace</small></div>
        </div>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <div class="eyebrow">WORKSPACE / MEMBERS / NEW</div>
                <h1>Add a member</h1>
                <p class="page-subtitle">Create a member profile with the required contact and membership details.</p>
            </div>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/members">← Back to members</a>
        </header>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error" role="alert"><c:out value="${errorMessage}"/></div>
        </c:if>

        <form class="panel form-panel" method="post" action="${pageContext.request.contextPath}/members/create">
            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}'/>">

            <div class="panel-heading">
                <div>
                    <h2>Personal information</h2>
                    <p>Enter accurate information for the member record.</p>
                </div>
                <span class="required-note"><span class="required-star">*</span> Required fields</span>
            </div>

            <div class="form-grid">
                <div class="field field-span-2">
                    <label for="fullName">Full name <span class="required-star">*</span></label>
                    <input id="fullName" name="fullName" type="text" maxlength="120"
                           autocomplete="name" required
                           value="<c:out value='${fullName}'/>"
                           placeholder="Enter full name">
                </div>

                <div class="field">
                    <label for="email">Email address <span class="required-star">*</span></label>
                    <input id="email" name="email" type="email" maxlength="254"
                           autocomplete="email" required
                           value="<c:out value='${email}'/>"
                           placeholder="name@example.com">
                </div>

                <div class="field">
                    <label for="phone">Phone number <span class="required-star">*</span></label>
                    <input id="phone" name="phone" type="tel" maxlength="30"
                           autocomplete="tel" required
                           value="<c:out value='${phone}'/>"
                           placeholder="Enter phone number">
                </div>

                <div class="field">
                    <label for="dateOfBirth">Date of birth</label>
                    <input id="dateOfBirth" name="dateOfBirth" type="date"
                           value="<c:out value='${dateOfBirth}'/>">
                </div>

                <div class="field">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="">Select gender</option>
                        <option value="MALE" ${gender eq 'MALE' ? 'selected' : ''}>Male</option>
                        <option value="FEMALE" ${gender eq 'FEMALE' ? 'selected' : ''}>Female</option>
                        <option value="OTHER" ${gender eq 'OTHER' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <div class="field field-span-2">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" rows="3" maxlength="1000"
                              placeholder="Enter residential address"><c:out value="${address}"/></textarea>
                </div>
            </div>

            <div class="form-divider"></div>

            <div class="panel-heading">
                <div>
                    <h2>Membership details</h2>
                    <p>Choose the category that applies to this member.</p>
                </div>
            </div>

            <div class="form-grid">
                <div class="field field-span-2">
                    <label for="membershipType">Membership type <span class="required-star">*</span></label>
                    <select id="membershipType" name="membershipType" required>
                        <option value="">Select membership type</option>
                        <option value="STUDENT" ${membershipType eq 'STUDENT' ? 'selected' : ''}>Student</option>
                        <option value="FACULTY" ${membershipType eq 'FACULTY' ? 'selected' : ''}>Faculty</option>
                        <option value="STAFF" ${membershipType eq 'STAFF' ? 'selected' : ''}>Staff</option>
                        <option value="GENERAL" ${membershipType eq 'GENERAL' ? 'selected' : ''}>General</option>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/members">Cancel</a>
                <button class="btn btn-primary" type="submit">Create member</button>
            </div>
        </form>

        <footer class="page-footer">Library Management System <span>•</span> Member workspace</footer>
    </main>
</div>
</body>
</html>
