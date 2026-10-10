```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Details | Library Management System</title>

    <style>
        :root {
            --primary: #4338ca;
            --primary-dark: #3730a3;
            --background: #f5f7fb;
            --surface: #ffffff;
            --text: #172033;
            --muted: #64748b;
            --border: #e2e8f0;
            --success: #15803d;
            --success-bg: #dcfce7;
            --danger: #b91c1c;
            --danger-bg: #fee2e2;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--background);
            color: var(--text);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            line-height: 1.6;
        }

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 18px 5%;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }

        .brand {
            color: var(--primary);
            font-size: 19px;
            font-weight: 800;
            text-decoration: none;
        }

        .topbar-label {
            color: var(--muted);
            font-size: 13px;
        }

        .container {
            width: min(100% - 32px, 1000px);
            margin: 34px auto;
        }

        .breadcrumb {
            margin-bottom: 20px;
            color: var(--muted);
            font-size: 13px;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
        }

        .page-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        h1 {
            margin: 0;
            font-size: clamp(25px, 4vw, 32px);
            letter-spacing: -0.7px;
        }

        .subtitle {
            margin: 7px 0 0;
            color: var(--muted);
            font-size: 14px;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 42px;
            padding: 10px 15px;
            border: 1px solid var(--border);
            border-radius: 9px;
            background: var(--surface);
            color: var(--text);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.2s ease;
        }

        .button:hover {
            transform: translateY(-1px);
            background: #f8fafc;
        }

        .button-primary {
            border-color: var(--primary);
            background: var(--primary);
            color: #ffffff;
        }

        .button-primary:hover {
            background: var(--primary-dark);
            color: #ffffff;
        }

        .notice {
            margin-bottom: 18px;
            padding: 13px 16px;
            border: 1px solid transparent;
            border-radius: 10px;
            font-size: 14px;
        }

        .notice-success {
            border-color: #bbf7d0;
            background: var(--success-bg);
            color: var(--success);
        }

        .card {
            overflow: hidden;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: var(--surface);
            box-shadow: 0 8px 28px rgba(15, 23, 42, 0.04);
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 26px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(135deg, #eef2ff, #ffffff);
        }

        .avatar {
            display: flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: center;
            width: 64px;
            height: 64px;
            border: 1px solid #c7d2fe;
            border-radius: 16px;
            background: #e0e7ff;
            color: var(--primary-dark);
            font-size: 23px;
            font-weight: 800;
        }

        .profile-name {
            margin: 0;
            overflow-wrap: anywhere;
            font-size: 22px;
            font-weight: 800;
        }

        .profile-code {
            margin-top: 4px;
            color: var(--muted);
            font-size: 13px;
        }

        .badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.3px;
        }

        .badge-type {
            background: #e0e7ff;
            color: var(--primary-dark);
        }

        .status-active {
            background: var(--success-bg);
            color: var(--success);
        }

        .status-inactive {
            background: #f1f5f9;
            color: #475569;
        }

        .status-suspended {
            background: var(--danger-bg);
            color: var(--danger);
        }

        .section {
            padding: 25px 26px;
            border-bottom: 1px solid var(--border);
        }

        .section:last-child {
            border-bottom: none;
        }

        .section-title {
            margin: 0 0 20px;
            font-size: 15px;
            font-weight: 800;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 24px 32px;
        }

        .detail {
            min-width: 0;
        }

        .detail-label {
            display: block;
            margin-bottom: 6px;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .detail-value {
            overflow-wrap: anywhere;
            color: var(--text);
            font-size: 14px;
            font-weight: 600;
            white-space: pre-wrap;
        }

        .empty-value {
            color: #94a3b8;
            font-weight: 400;
            font-style: italic;
        }

        .footer {
            padding: 20px 0;
            color: var(--muted);
            font-size: 12px;
            text-align: center;
        }

        @media (max-width: 600px) {
            .topbar {
                padding: 15px 16px;
            }

            .topbar-label {
                display: none;
            }

            .container {
                margin-top: 24px;
            }

            .page-heading {
                flex-direction: column;
            }

            .actions {
                width: 100%;
            }

            .actions .button {
                flex: 1;
            }

            .profile-header {
                align-items: flex-start;
                padding: 20px;
            }

            .avatar {
                width: 52px;
                height: 52px;
                border-radius: 13px;
                font-size: 19px;
            }

            .profile-name {
                font-size: 19px;
            }

            .section {
                padding: 21px 20px;
            }

            .details-grid {
                grid-template-columns: 1fr;
                gap: 19px;
            }
        }
    </style>
</head>

<body>

<header class="topbar">
    <a class="brand"
       href="${pageContext.request.contextPath}/">
        Library Management System
    </a>

    <span class="topbar-label">Member Management</span>
</header>

<main class="container">

    <nav class="breadcrumb" aria-label="Breadcrumb">
        <a href="${pageContext.request.contextPath}/members">Members</a>
        <span aria-hidden="true"> / </span>
        <span>Member Details</span>
    </nav>

    <div class="page-heading">
        <div>
            <h1>Member Details</h1>
            <p class="subtitle">
                View the member's registration and membership information.
            </p>
        </div>

        <div class="actions">
            <a class="button"
               href="${pageContext.request.contextPath}/members">
                Back to Members
            </a>

            <a class="button button-primary"
               href="${pageContext.request.contextPath}/members/edit?id=${member.id}">
                Edit Member
            </a>
        </div>
    </div>

    <c:if test="${param.created eq 'true'}">
        <div class="notice notice-success" role="status">
            Member registered successfully.
        </div>
    </c:if>

    <c:if test="${param.updated eq 'true'}">
        <div class="notice notice-success" role="status">
            Member information updated successfully.
        </div>
    </c:if>

    <section class="card" aria-label="Member profile">

        <div class="profile-header">
            <div class="avatar" aria-hidden="true">
                <c:choose>
                    <c:when test="${not empty member.fullName}">
                        <c:out value="${fn:toUpperCase(fn:substring(member.fullName, 0, 1))}"/>
                    </c:when>
                    <c:otherwise>?</c:otherwise>
                </c:choose>
            </div>

            <div>
                <h2 class="profile-name">
                    <c:out value="${member.fullName}"/>
                </h2>

                <div class="profile-code">
                    Member Code:
                    <c:out value="${member.memberCode}"/>
                </div>

                <div class="badges">
                    <span class="badge badge-type">
                        <c:out value="${member.membershipType}"/>
                    </span>

                    <c:choose>
                        <c:when test="${member.status eq 'ACTIVE'}">
                            <span class="badge status-active">ACTIVE</span>
                        </c:when>
                        <c:when test="${member.status eq 'SUSPENDED'}">
                            <span class="badge status-suspended">SUSPENDED</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge status-inactive">
                                <c:out value="${member.status}"/>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <section class="section">
            <h3 class="section-title">Personal Information</h3>

            <div class="details-grid">
                <div class="detail">
                    <span class="detail-label">Full Name</span>
                    <div class="detail-value">
                        <c:out value="${member.fullName}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Email Address</span>
                    <div class="detail-value">
                        <c:out value="${member.email}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Phone Number</span>
                    <div class="detail-value">
                        <c:out value="${member.phone}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Date of Birth</span>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty member.dateOfBirth}">
                                <c:out value="${member.dateOfBirth}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">Not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Gender</span>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty member.gender}">
                                <c:out value="${member.gender}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">Not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Membership Type</span>
                    <div class="detail-value">
                        <c:out value="${member.membershipType}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Address</span>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty member.address}">
                                <c:out value="${member.address}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">Not provided</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>

        <section class="section">
            <h3 class="section-title">Membership Information</h3>

            <div class="details-grid">
                <div class="detail">
                    <span class="detail-label">Registration Date</span>
                    <div class="detail-value">
                        <c:out value="${member.registrationDate}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Membership Valid Until</span>
                    <div class="detail-value">
                        <c:out value="${member.validUntil}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Account Status</span>
                    <div class="detail-value">
                        <c:out value="${member.status}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Internal Database ID</span>
                    <div class="detail-value">
                        <c:out value="${member.id}"/>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Created At</span>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty member.createdAt}">
                                <c:out value="${member.createdAt}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">Unavailable</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail">
                    <span class="detail-label">Last Updated</span>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty member.updatedAt}">
                                <c:out value="${member.updatedAt}"/>
                            </c:when>
                            <c:otherwise>
                                <span class="empty-value">Unavailable</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </section>

    </section>

    <footer class="footer">
        Library Management System · Member Management
    </footer>

</main>

</body>
</html>
```