```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Update library member information">
    <title>Edit Member | Library Management System</title>

    <style>
        :root {
            --primary: #173b67;
            --primary-dark: #102b4c;
            --text: #172337;
            --muted: #66758a;
            --surface: #ffffff;
            --background: #f4f7fb;
            --border: #dce4ee;
            --error: #a93226;
            --error-bg: #fff0ee;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: var(--background);
        }

        .topbar {
            min-height: 72px;
            padding: 16px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }

        .brand,
        .back-link {
            color: var(--primary);
            font-weight: 700;
            text-decoration: none;
        }

        .back-link {
            font-size: 14px;
        }

        .container {
            width: min(900px, 92%);
            margin: 38px auto;
        }

        .eyebrow {
            color: var(--muted);
            font-size: 12px;
            font-weight: 750;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        h1 {
            margin: 8px 0;
            font-size: clamp(28px, 4vw, 36px);
            letter-spacing: -1px;
        }

        .intro {
            margin: 0 0 26px;
            color: var(--muted);
            line-height: 1.7;
        }

        .form-card {
            padding: clamp(22px, 4vw, 36px);
            border: 1px solid var(--border);
            border-radius: 18px;
            background: var(--surface);
            box-shadow: 0 12px 35px rgba(16, 43, 76, 0.05);
        }

        .section-title {
            margin: 0 0 20px;
            font-size: 17px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .field {
            display: flex;
            min-width: 0;
            flex-direction: column;
            gap: 8px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        label {
            font-size: 13px;
            font-weight: 700;
        }

        .required {
            color: var(--error);
        }

        input,
        select,
        textarea {
            width: 100%;
            min-height: 44px;
            padding: 11px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            background: #fff;
            color: var(--text);
            font: inherit;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: var(--primary);
            outline: 3px solid rgba(23, 59, 103, 0.13);
        }

        .help {
            color: var(--muted);
            font-size: 12px;
            line-height: 1.5;
        }

        .error-box {
            margin-bottom: 24px;
            padding: 14px 16px;
            border: 1px solid #f3c6c0;
            border-radius: 10px;
            background: var(--error-bg);
            color: var(--error);
            font-size: 14px;
            line-height: 1.6;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
            padding-top: 24px;
            border-top: 1px solid var(--border);
        }

        .button {
            display: inline-flex;
            min-height: 44px;
            align-items: center;
            justify-content: center;
            padding: 0 18px;
            border: 1px solid transparent;
            border-radius: 9px;
            background: var(--primary);
            color: #fff;
            font: inherit;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .button:hover {
            background: var(--primary-dark);
        }

        .button-secondary {
            border-color: var(--border);
            background: #fff;
            color: var(--primary);
        }

        .button-secondary:hover {
            background: #f1f5f9;
        }

        .button:focus-visible {
            outline: 3px solid rgba(23, 59, 103, 0.25);
            outline-offset: 3px;
        }

        footer {
            padding: 24px;
            color: var(--muted);
            text-align: center;
            font-size: 12px;
        }

        @media (max-width: 620px) {
            .topbar {
                flex-wrap: wrap;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .full-width {
                grid-column: auto;
            }

            .container {
                margin: 26px auto;
            }

            .actions > * {
                flex: 1;
            }
        }
    </style>
</head>

<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">
        Library Management System
    </a>

    <a class="back-link"
       href="${pageContext.request.contextPath}/members">
        &larr; Member Directory
    </a>
</header>

<main class="container">
    <div class="eyebrow">Member Management</div>
    <h1>Edit Member</h1>

    <p class="intro">
        Update the member's information and membership validity.
        Fields marked with <span class="required">*</span> are required.
    </p>

    <section class="form-card">
        <c:if test="${not empty errorMessage}">
            <div class="error-box" role="alert">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <form method="post"
              action="${pageContext.request.contextPath}/members/edit"
              accept-charset="UTF-8">

            <%-- CSRF protection --%>
            <input type="hidden"
                   name="csrfToken"
                   value="<c:out value='${csrfToken}'/>">

            <%-- Member identifier --%>
            <input type="hidden"
                   name="id"
                   value="<c:out value='${memberId != null ? memberId : member.id}'/>">

            <h2 class="section-title">Personal Information</h2>

            <div class="form-grid">
                <div class="field full-width">
                    <label for="fullName">
                        Full Name <span class="required">*</span>
                    </label>
                    <input id="fullName"
                           name="fullName"
                           type="text"
                           maxlength="120"
                           autocomplete="name"
                           value="<c:out value='${param.fullName != null ? param.fullName : member.fullName}'/>"
                           required>
                </div>

                <div class="field">
                    <label for="email">
                        Email Address <span class="required">*</span>
                    </label>
                    <input id="email"
                           name="email"
                           type="email"
                           maxlength="150"
                           autocomplete="email"
                           value="<c:out value='${param.email != null ? param.email : member.email}'/>"
                           required>
                </div>

                <div class="field">
                    <label for="phone">
                        Phone Number <span class="required">*</span>
                    </label>
                    <input id="phone"
                           name="phone"
                           type="tel"
                           maxlength="20"
                           autocomplete="tel"
                           value="<c:out value='${param.phone != null ? param.phone : member.phone}'/>"
                           required>
                </div>

                <div class="field">
                    <label for="dateOfBirth">Date of Birth</label>
                    <input id="dateOfBirth"
                           name="dateOfBirth"
                           type="date"
                           value="<c:out value='${param.dateOfBirth != null ? param.dateOfBirth : member.dateOfBirth}'/>">
                </div>

                <div class="field">
                    <label for="gender">Gender</label>

                    <c:set var="selectedGender"
                           value="${param.gender != null ? param.gender : member.gender}"/>

                    <select id="gender" name="gender">
                        <option value="">Prefer not to specify</option>
                        <option value="MALE"
                            ${selectedGender eq 'MALE' ? 'selected' : ''}>Male</option>
                        <option value="FEMALE"
                            ${selectedGender eq 'FEMALE' ? 'selected' : ''}>Female</option>
                        <option value="OTHER"
                            ${selectedGender eq 'OTHER' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <div class="field full-width">
                    <label for="address">Address</label>
                    <textarea id="address"
                              name="address"
                              maxlength="500"
                              autocomplete="street-address"><c:out value="${param.address != null ? param.address : member.address}"/></textarea>
                </div>
            </div>

            <h2 class="section-title" style="margin-top: 32px;">
                Membership Information
            </h2>

            <div class="form-grid">
                <div class="field full-width">
                    <label for="membershipType">
                        Membership Type <span class="required">*</span>
                    </label>

                    <c:set var="selectedMembershipType"
                           value="${param.membershipType != null ? param.membershipType : member.membershipType}"/>

                    <select id="membershipType"
                            name="membershipType"
                            required>
                        <option value="">Select membership type</option>
                        <option value="STUDENT"
                            ${selectedMembershipType eq 'STUDENT' ? 'selected' : ''}>Student</option>
                        <option value="FACULTY"
                            ${selectedMembershipType eq 'FACULTY' ? 'selected' : ''}>Faculty</option>
                        <option value="STAFF"
                            ${selectedMembershipType eq 'STAFF' ? 'selected' : ''}>Staff</option>
                        <option value="GENERAL"
                            ${selectedMembershipType eq 'GENERAL' ? 'selected' : ''}>General</option>
                    </select>
                </div>

                <div class="field">
                    <label for="registrationDate">
                        Registration Date <span class="required">*</span>
                    </label>
                    <input id="registrationDate"
                           name="registrationDate"
                           type="date"
                           value="<c:out value='${param.registrationDate != null ? param.registrationDate : member.registrationDate}'/>"
                           required>
                </div>

                <div class="field">
                    <label for="validUntil">
                        Valid Until <span class="required">*</span>
                    </label>
                    <input id="validUntil"
                           name="validUntil"
                           type="date"
                           value="<c:out value='${param.validUntil != null ? param.validUntil : member.validUntil}'/>"
                           required>
                    <span class="help">
                        The validity date cannot be earlier than the registration date.
                    </span>
                </div>
            </div>

            <div class="actions">
                <a class="button button-secondary"
                   href="${pageContext.request.contextPath}/members">
                    Cancel
                </a>

                <button class="button" type="submit">
                    Save Changes
                </button>
            </div>
        </form>
    </section>
</main>

<footer>
    Library Management System &middot; Member Management
</footer>
</body>
</html>
```