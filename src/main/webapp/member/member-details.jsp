
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Member Details | LMS</title>
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
                <div class="eyebrow">WORKSPACE / MEMBERS / PROFILE</div>
                <h1>Member profile</h1>
                <p class="page-subtitle">Review the member's contact and membership details.</p>
            </div>
            <div class="header-actions">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/members">← Back to members</a>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/members/edit?id=${member.id}">Edit member</a>
            </div>
        </header>

        <c:if test="${param.created eq 'true'}">
            <div class="alert alert-success" role="status">Member created successfully.</div>
        </c:if>
        <c:if test="${param.updated eq 'true'}">
            <div class="alert alert-success" role="status">Member details updated successfully.</div>
        </c:if>

        <section class="profile-hero panel">
            <div class="profile-identity">
                <div class="profile-avatar">
                    <c:out value="${empty member.fullName ? 'M' : member.fullName.substring(0,1).toUpperCase()}"/>
                </div>
                <div>
                    <div class="eyebrow">MEMBER PROFILE</div>
                    <h2><c:out value="${member.fullName}"/></h2>
                    <p><c:out value="${member.email}"/></p>
                    <span class="code-pill"><c:out value="${member.memberCode}"/></span>
                </div>
            </div>
            <span class="status-badge
                ${member.status eq 'ACTIVE' ? 'status-active' :
                  member.status eq 'INACTIVE' ? 'status-inactive' : 'status-suspended'}">
                <c:out value="${member.status}"/>
            </span>
        </section>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2>Personal information</h2>
                    <p>Contact information registered for this member.</p>
                </div>
            </div>
            <div class="detail-grid">
                <div class="detail-item"><span>Full name</span><strong><c:out value="${member.fullName}"/></strong></div>
                <div class="detail-item"><span>Email address</span><strong><c:out value="${member.email}"/></strong></div>
                <div class="detail-item"><span>Phone number</span><strong><c:out value="${member.phone}"/></strong></div>
                <div class="detail-item"><span>Date of birth</span><strong><c:out value="${member.dateOfBirth != null ? member.dateOfBirth : '—'}"/></strong></div>
                <div class="detail-item"><span>Gender</span><strong><c:out value="${member.gender != null ? member.gender : '—'}"/></strong></div>
                <div class="detail-item detail-item-wide"><span>Address</span><strong class="detail-address"><c:out value="${not empty member.address ? member.address : '—'}"/></strong></div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-heading">
                <div>
                    <h2>Membership information</h2>
                    <p>Category, status and membership validity.</p>
                </div>
            </div>
            <div class="detail-grid">
                <div class="detail-item"><span>Member code</span><strong><c:out value="${member.memberCode}"/></strong></div>
                <div class="detail-item"><span>Membership type</span><strong><c:out value="${member.membershipType}"/></strong></div>
                <div class="detail-item"><span>Registration date</span><strong><c:out value="${member.registrationDate != null ? member.registrationDate : '—'}"/></strong></div>
                <div class="detail-item"><span>Valid until</span><strong><c:out value="${member.validUntil != null ? member.validUntil : '—'}"/></strong></div>
                <div class="detail-item"><span>Record created</span><strong><c:out value="${member.createdAt != null ? member.createdAt : '—'}"/></strong></div>
                <div class="detail-item"><span>Last updated</span><strong><c:out value="${member.updatedAt != null ? member.updatedAt : '—'}"/></strong></div>
            </div>
        </section>

        <footer class="page-footer">Library Management System <span>•</span> Member workspace</footer>
    </main>
</div>
</body>
</html>
