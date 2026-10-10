
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Library Management System - Member Management Portal">
    <title>Library Management System</title>

    <style>
        :root {
            color-scheme: light;
            --primary: #173b67;
            --primary-dark: #102b4c;
            --accent: #d9a441;
            --text: #172337;
            --muted: #66758a;
            --surface: #ffffff;
            --background: #f4f7fb;
            --border: #e1e8f0;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background: var(--background);
            display: flex;
            flex-direction: column;
        }

        .navbar {
            min-height: 76px;
            padding: 16px 6%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--primary);
            font-size: 18px;
            font-weight: 750;
            text-decoration: none;
        }

        .brand-mark {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: var(--primary);
            color: white;
            font-size: 22px;
        }

        .nav-link {
            color: var(--primary);
            font-size: 14px;
            font-weight: 650;
            text-decoration: none;
        }

        .nav-link:hover,
        .nav-link:focus-visible {
            text-decoration: underline;
        }

        main {
            width: min(1120px, 88%);
            margin: auto;
            padding: 64px 0;
            flex: 1;
        }

        .hero {
            position: relative;
            overflow: hidden;
            padding: clamp(32px, 6vw, 72px);
            border-radius: 24px;
            color: white;
            background: linear-gradient(
                125deg,
                var(--primary-dark),
                var(--primary)
            );
            box-shadow: 0 20px 45px rgba(16, 43, 76, 0.14);
        }

        .eyebrow {
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 12px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 999px;
            color: #f5d995;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1.4px;
            text-transform: uppercase;
        }

        h1 {
            max-width: 700px;
            margin: 0;
            font-size: clamp(34px, 5vw, 58px);
            line-height: 1.12;
            letter-spacing: -1.5px;
        }

        .hero p {
            max-width: 600px;
            margin: 22px 0 30px;
            color: #dce7f5;
            font-size: 17px;
            line-height: 1.8;
        }

        .button {
            display: inline-flex;
            min-height: 48px;
            align-items: center;
            justify-content: center;
            padding: 0 20px;
            border: 1px solid transparent;
            border-radius: 10px;
            background: var(--accent);
            color: #172337;
            font-size: 14px;
            font-weight: 750;
            text-decoration: none;
            transition: transform 160ms ease, filter 160ms ease;
        }

        .button:hover {
            transform: translateY(-2px);
            filter: brightness(1.04);
        }

        .button:focus-visible {
            outline: 3px solid white;
            outline-offset: 3px;
        }

        .section-heading {
            margin: 42px 0 18px;
            font-size: 22px;
            letter-spacing: -0.4px;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .feature {
            padding: 24px;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: var(--surface);
        }

        .feature-icon {
            width: 44px;
            height: 44px;
            display: grid;
            place-items: center;
            margin-bottom: 18px;
            border-radius: 12px;
            background: #eaf0f8;
            color: var(--primary);
            font-size: 21px;
        }

        .feature h3 {
            margin: 0 0 10px;
            font-size: 17px;
        }

        .feature p {
            margin: 0;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.7;
        }

        footer {
            padding: 22px 6%;
            border-top: 1px solid var(--border);
            background: var(--surface);
            color: var(--muted);
            text-align: center;
            font-size: 13px;
        }

        @media (max-width: 760px) {
            .navbar {
                padding-inline: 5%;
            }

            .brand {
                font-size: 15px;
            }

            main {
                width: 90%;
                padding: 36px 0;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }

            .hero p {
                font-size: 15px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                transition: none !important;
            }
        }
    </style>
</head>

<body>
<header class="navbar">
    <a class="brand" href="${pageContext.request.contextPath}/">
        <span class="brand-mark" aria-hidden="true">&#128218;</span>
        <span>Library Management System</span>
    </a>

    <a class="nav-link"
       href="${pageContext.request.contextPath}/members">
        Member Management &rarr;
    </a>
</header>

<main>
    <section class="hero" aria-labelledby="hero-title">
        <span class="eyebrow">Library Administration Portal</span>

        <h1 id="hero-title">
            A smarter way to manage your library.
        </h1>

        <p>
            Manage member records, find registered members, and maintain
            membership information through one organized interface.
        </p>

        <a class="button"
           href="${pageContext.request.contextPath}/members">
            Open Member Management &rarr;
        </a>
    </section>

    <h2 class="section-heading">Member Management</h2>

    <section class="feature-grid" aria-label="Available features">
        <article class="feature">
            <div class="feature-icon" aria-hidden="true">&#128101;</div>
            <h3>Member Directory</h3>
            <p>
                View registered members and review their membership
                information in one place.
            </p>
        </article>

        <article class="feature">
            <div class="feature-icon" aria-hidden="true">&#128269;</div>
            <h3>Member Search</h3>
            <p>
                Find members using available identifying details such
                as name, email, phone, or member code.
            </p>
        </article>

        <article class="feature">
            <div class="feature-icon" aria-hidden="true">&#128221;</div>
            <h3>Membership Records</h3>
            <p>
                Access member details and maintain membership status
                through the Member Management module.
            </p>
        </article>
    </section>
</main>

<footer>
    Library Management System &middot; Member Management Portal
</footer>
</body>
</html>
