
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#f7f9fc">
    <meta name="description"
          content="A modern Library Management System for organized member records and efficient library administration.">
    <title>LMS — Library Management System</title>

    <style>
        :root {
            --background: #f7f9fc;
            --surface: #ffffff;
            --ink: #101828;
            --muted: #667085;
            --blue: #315efb;
            --blue-dark: #2449d8;
            --blue-soft: #edf2ff;
            --border: #e7ebf2;
            --dark: #101828;
            --green: #16845a;
            --radius: 16px;
            --shadow: 0 20px 60px rgba(20, 35, 70, .08);
        }

        * { box-sizing: border-box; }

        html {
            scroll-behavior: smooth;
            scroll-padding-top: 90px;
        }

        body {
            margin: 0;
            background: var(--background);
            color: var(--ink);
            font-family: Inter, -apple-system, BlinkMacSystemFont,
                         "Segoe UI", Roboto, Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        a { color: inherit; text-decoration: none; }

        button, input { font: inherit; }

        a:focus-visible,
        button:focus-visible,
        input:focus-visible {
            outline: 3px solid rgba(49, 94, 251, .55);
            outline-offset: 4px;
        }

        .container {
            width: min(1160px, calc(100% - 48px));
            margin-inline: auto;
        }

        .icon {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
        }

        /* Navigation */

        .navbar {
            position: sticky;
            top: 0;
            z-index: 20;
            background: rgba(247, 249, 252, .90);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            border-bottom: 1px solid rgba(231, 235, 242, .9);
        }

        .nav-inner {
            min-height: 78px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            flex-shrink: 0;
            font-size: 17px;
            font-weight: 800;
            letter-spacing: -.7px;
        }

        .brand-mark {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 13px;
            color: #fff;
            background: var(--blue);
            box-shadow: 0 7px 18px rgba(49, 94, 251, .22);
        }

        .brand-mark svg { width: 23px; height: 23px; }

        .brand-subtitle {
            display: block;
            margin-top: 3px;
            color: var(--muted);
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 1.35px;
            text-transform: uppercase;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 30px;
            color: #475467;
            font-size: 13px;
            font-weight: 600;
        }

        .nav-links > a:not(.nav-cta):hover,
        .footer-link:hover {
            color: var(--blue);
        }

        .nav-cta {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 44px;
            padding: 0 16px;
            border-radius: 11px;
            color: #fff;
            background: var(--dark);
            transition: transform .2s ease, background .2s ease;
        }

        .nav-cta:hover {
            background: var(--blue);
            transform: translateY(-1px);
        }

        /* Hero */

        .hero {
            position: relative;
            overflow: hidden;
            padding: 82px 0 76px;
        }

        .hero::before {
            content: "";
            position: absolute;
            top: -180px;
            right: -130px;
            width: 580px;
            height: 580px;
            border-radius: 50%;
            background: radial-gradient(
                circle, rgba(49, 94, 251, .10), transparent 68%
            );
            pointer-events: none;
        }

        .hero-grid {
            position: relative;
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            align-items: center;
            gap: 60px;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 24px;
            color: #344054;
            font-size: 11px;
            font-weight: 750;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .eyebrow-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--blue);
            box-shadow: 0 0 0 4px #e7edff;
        }

        h1 {
            max-width: 590px;
            margin: 0;
            font-size: clamp(44px, 5.2vw, 70px);
            line-height: 1.045;
            font-weight: 780;
            letter-spacing: -4px;
        }

        .hero-highlight { color: var(--blue); }

        .hero-description {
            max-width: 465px;
            margin: 23px 0 25px;
            color: var(--muted);
            font-size: 15px;
            line-height: 1.85;
        }

        /* Quick search */

        .quick-search {
            width: 100%;
            max-width: 475px;
            margin: 0 0 22px;
        }

        .quick-search-label {
            display: block;
            margin-bottom: 10px;
            color: #344054;
            font-size: 12px;
            font-weight: 750;
        }

        .quick-search-box {
            display: flex;
            align-items: center;
            gap: 10px;
            min-height: 58px;
            padding: 6px 7px 6px 15px;
            border: 1px solid #e0e6f0;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 5px 18px rgba(16, 24, 40, .035);
            transition: border-color .2s ease, box-shadow .2s ease;
        }

        .quick-search-box:focus-within {
            border-color: var(--blue);
            box-shadow: 0 0 0 4px rgba(49, 94, 251, .10);
        }

        .quick-search-icon {
            width: 20px;
            height: 20px;
            flex-shrink: 0;
            color: #8a94a6;
        }

        .quick-search-input {
            width: 100%;
            min-width: 0;
            padding: 10px 0;
            border: 0;
            outline: none;
            color: var(--ink);
            background: transparent;
            font-size: 13px;
        }

        .quick-search-input:focus-visible { outline: none; }

        .quick-search-input::placeholder { color: #98a2b3; }

        .quick-search-button {
            display: inline-flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: center;
            gap: 7px;
            min-height: 42px;
            padding: 0 14px;
            border: 0;
            border-radius: 10px;
            color: #fff;
            background: var(--blue);
            font-size: 12px;
            font-weight: 750;
            cursor: pointer;
            transition: background .2s ease, transform .2s ease;
        }

        .quick-search-button:hover {
            background: var(--blue-dark);
            transform: translateY(-1px);
        }

        .quick-search-button svg {
            width: 15px;
            height: 15px;
        }

        .quick-search-hint {
            margin: 9px 0 0;
            color: #8a94a6;
            font-size: 10px;
            line-height: 1.65;
        }

        .hero-actions {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .button-primary,
        .button-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 48px;
            padding: 0 18px;
            border: 1px solid transparent;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 750;
            transition: transform .2s ease, box-shadow .2s ease,
                        background .2s ease;
        }

        .button-primary {
            color: #fff;
            background: var(--blue);
            box-shadow: 0 9px 22px rgba(49, 94, 251, .19);
        }

        .button-primary:hover {
            background: var(--blue-dark);
            box-shadow: 0 12px 26px rgba(49, 94, 251, .25);
            transform: translateY(-2px);
        }

        .button-secondary {
            color: #344054;
            background: #fff;
            border-color: var(--border);
        }

        .button-secondary:hover {
            border-color: #cbd5e1;
            transform: translateY(-2px);
        }

        .button-primary svg,
        .button-secondary svg {
            width: 16px;
            height: 16px;
        }

        .hero-note {
            display: flex;
            align-items: center;
            gap: 9px;
            margin-top: 23px;
            color: #7a8495;
            font-size: 11px;
            line-height: 1.6;
        }

        .hero-note svg {
            width: 15px;
            height: 15px;
            color: #16a36a;
        }

        /* Illustrative dashboard preview */

        .preview-wrap {
            position: relative;
            min-width: 0;
            padding: 0 0 20px 20px;
        }

        .preview-glow {
            position: absolute;
            inset: 12% 0 0 12%;
            border-radius: 32px;
            background: #dfe7ff;
            filter: blur(40px);
            opacity: .7;
            pointer-events: none;
        }

        .dashboard {
            position: relative;
            overflow: hidden;
            border: 1px solid #e4e8f0;
            border-radius: 19px;
            background: #fff;
            box-shadow: 0 28px 70px rgba(24, 39, 75, .13);
            transform: perspective(1200px) rotateY(-2deg) rotateX(1deg);
        }

        .dashboard-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            padding: 17px 19px;
            border-bottom: 1px solid #edf0f5;
        }

        .dashboard-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 12px;
            font-weight: 750;
        }

        .mini-brand {
            display: grid;
            place-items: center;
            width: 29px;
            height: 29px;
            border-radius: 9px;
            color: #fff;
            background: var(--blue);
        }

        .mini-brand svg { width: 16px; height: 16px; }

        .preview-label {
            padding: 6px 9px;
            border-radius: 7px;
            color: #53627b;
            background: #f2f5fa;
            font-size: 9px;
            font-weight: 750;
            letter-spacing: .5px;
        }

        .dashboard-body { padding: 22px 19px 20px; }

        .preview-heading {
            margin: 0;
            font-size: 19px;
            font-weight: 760;
            letter-spacing: -.65px;
        }

        .preview-subheading {
            margin: 7px 0 19px;
            color: #8a94a6;
            font-size: 10px;
            line-height: 1.6;
        }

        .preview-stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
        }

        .preview-stat {
            min-width: 0;
            padding: 13px 11px;
            border: 1px solid #edf0f5;
            border-radius: 12px;
            background: #fff;
        }

        .preview-stat-label {
            display: block;
            color: #8a94a6;
            font-size: 9px;
            font-weight: 600;
        }

        .preview-stat-value {
            display: block;
            margin-top: 10px;
            color: #202a3b;
            font-size: 22px;
            font-weight: 780;
            letter-spacing: -.8px;
        }

        .preview-stat-icon {
            display: grid;
            place-items: center;
            width: 27px;
            height: 27px;
            margin-bottom: 13px;
            border-radius: 8px;
            color: var(--blue);
            background: var(--blue-soft);
        }

        .preview-stat-icon svg { width: 15px; height: 15px; }

        .preview-table {
            margin-top: 20px;
            overflow: hidden;
            border: 1px solid #edf0f5;
            border-radius: 12px;
        }

        .preview-table-heading {
            padding: 13px;
            border-bottom: 1px solid #edf0f5;
            font-size: 10px;
            font-weight: 750;
        }

        .preview-row {
            display: grid;
            grid-template-columns: minmax(0, 1.6fr) minmax(55px, .8fr) auto;
            align-items: center;
            gap: 8px;
            padding: 11px 13px;
            border-bottom: 1px solid #f0f2f6;
        }

        .preview-row:last-child { border-bottom: 0; }

        .person {
            display: flex;
            min-width: 0;
            align-items: center;
            gap: 8px;
        }

        .person-avatar {
            display: grid;
            flex: 0 0 27px;
            place-items: center;
            width: 27px;
            height: 27px;
            border-radius: 9px;
            color: #4255a6;
            background: #edf0ff;
            font-size: 9px;
            font-weight: 800;
        }

        .person-copy { min-width: 0; }

        .person-name {
            display: block;
            overflow: hidden;
            color: #344054;
            font-size: 10px;
            font-weight: 700;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .person-email {
            display: block;
            overflow: hidden;
            margin-top: 3px;
            color: #98a2b3;
            font-size: 8px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .member-type {
            color: #667085;
            font-size: 9px;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 7px;
            border-radius: 6px;
            color: var(--green);
            background: #eaf8f1;
            font-size: 8px;
            font-weight: 750;
        }

        .status-pill::before {
            content: "";
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background: #1fa971;
        }

        .preview-footnote {
            display: flex;
            align-items: flex-start;
            gap: 7px;
            margin-top: 13px;
            color: #8a94a6;
            font-size: 9px;
            line-height: 1.6;
        }

        .preview-footnote svg {
            width: 13px;
            height: 13px;
            flex-shrink: 0;
            color: var(--blue);
        }

        .floating-note {
            position: absolute;
            right: -12px;
            bottom: 0;
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 13px 16px;
            border: 1px solid #e8ecf4;
            border-radius: 13px;
            background: #fff;
            box-shadow: 0 12px 32px rgba(24, 39, 75, .11);
        }

        .floating-note-icon {
            display: grid;
            place-items: center;
            width: 34px;
            height: 34px;
            border-radius: 10px;
            color: var(--blue);
            background: var(--blue-soft);
        }

        .floating-note-icon svg { width: 17px; height: 17px; }

        .floating-note strong {
            display: block;
            font-size: 10px;
        }

        .floating-note-copy {
            display: block;
            margin-top: 4px;
            color: #8a94a6;
            font-size: 9px;
        }

        /* Features */

        .feature-section {
            padding: 58px 0 83px;
            border-top: 1px solid #e9edf4;
            background: #fff;
        }

        .section-heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 28px;
            margin-bottom: 29px;
        }

        .section-kicker {
            margin-bottom: 11px;
            color: var(--blue);
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1.8px;
            text-transform: uppercase;
        }

        h2 {
            margin: 0;
            font-size: clamp(27px, 3vw, 37px);
            line-height: 1.2;
            letter-spacing: -1.6px;
        }

        .section-description {
            max-width: 390px;
            margin: 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.8;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 17px;
        }

        .feature-card {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            padding: 25px 23px 23px;
            border: 1px solid var(--border);
            border-radius: 16px;
            background: #fff;
            transition: border-color .2s ease, transform .2s ease,
                        box-shadow .2s ease;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            border-color: #cbd7ff;
            box-shadow: 0 15px 35px rgba(24, 39, 75, .06);
        }

        .feature-icon {
            display: grid;
            place-items: center;
            width: 45px;
            height: 45px;
            margin-bottom: 21px;
            border: 1px solid #e4eaff;
            border-radius: 13px;
            color: var(--blue);
            background: #f1f4ff;
        }

        .feature-icon svg { width: 21px; height: 21px; }

        .feature-card h3 {
            margin: 0 0 10px;
            font-size: 15px;
            letter-spacing: -.3px;
        }

        .feature-card p {
            margin: 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.8;
        }

        .feature-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-top: 21px;
            color: var(--blue);
            font-size: 11px;
            font-weight: 750;
        }

        .feature-link svg { width: 14px; height: 14px; }

        .feature-link:hover { color: var(--blue-dark); }

        /* Closing CTA */

        .closing {
            padding: 0 0 74px;
            background: #fff;
        }

        .closing-panel {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 30px;
            overflow: hidden;
            padding: 37px 40px;
            border-radius: 20px;
            color: #fff;
            background: #101828;
        }

        .closing-panel::after {
            content: "";
            position: absolute;
            top: -160px;
            right: 8%;
            width: 340px;
            height: 340px;
            border: 1px solid rgba(255, 255, 255, .09);
            border-radius: 50%;
            box-shadow: 0 0 0 35px rgba(255, 255, 255, .025),
                        0 0 0 70px rgba(255, 255, 255, .02);
            pointer-events: none;
        }

        .closing-copy {
            position: relative;
            z-index: 1;
        }

        .closing-copy h2 {
            font-size: clamp(25px, 3vw, 34px);
            letter-spacing: -1.2px;
        }

        .closing-copy p {
            max-width: 490px;
            margin: 12px 0 0;
            color: #b8c1d1;
            font-size: 12px;
            line-height: 1.8;
        }

        .closing-panel .button-primary {
            position: relative;
            z-index: 1;
            flex-shrink: 0;
        }

        /* Footer */

        .footer {
            padding: 24px 0;
            border-top: 1px solid #e9edf4;
            background: #fff;
        }

        .footer-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .footer-brand {
            color: #475467;
            font-size: 11px;
            font-weight: 750;
        }

        .footer-copy {
            color: #98a2b3;
            font-size: 10px;
        }

        .footer-link {
            color: #667085;
            font-size: 10px;
            font-weight: 650;
        }

        /* Responsive layouts */

        @media (min-width: 1400px) {
            .hero {
                padding-top: 100px;
                padding-bottom: 92px;
            }
        }

        @media (max-width: 950px) {
            .hero-grid { gap: 35px; }

            h1 {
                font-size: clamp(42px, 6vw, 58px);
                letter-spacing: -3px;
            }

            .preview-wrap { padding-left: 0; }

            .floating-note { right: -6px; }

            .section-heading {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 720px) {
            .container { width: min(calc(100% - 34px), 560px); }

            .nav-inner { min-height: 69px; }

            .nav-links { gap: 12px; }

            .nav-links > a:not(.nav-cta) { display: none; }

            .nav-cta {
                min-height: 40px;
                padding: 0 12px;
                font-size: 11px;
            }

            .brand { font-size: 15px; }

            .brand-mark {
                width: 38px;
                height: 38px;
            }

            .hero { padding: 56px 0 60px; }

            .hero-grid {
                grid-template-columns: minmax(0, 1fr);
                gap: 45px;
            }

            h1 {
                max-width: 540px;
                font-size: clamp(43px, 11vw, 61px);
                letter-spacing: -2.9px;
            }

            .hero-description { font-size: 14px; }

            .quick-search { max-width: none; }

            .preview-wrap { width: 100%; }

            .dashboard { transform: none; }

            .floating-note { right: 5px; }

            .feature-section { padding: 48px 0 58px; }

            .feature-grid {
                grid-template-columns: minmax(0, 1fr);
                gap: 12px;
            }

            .feature-card { padding: 21px; }

            .feature-icon { margin-bottom: 15px; }

            .closing { padding-bottom: 48px; }

            .closing-panel {
                align-items: flex-start;
                flex-direction: column;
                padding: 29px 24px;
            }

            .footer-inner { flex-wrap: wrap; }
        }

        @media (max-width: 390px) {
            .container { width: calc(100% - 28px); }

            .brand-subtitle { font-size: 9px; }

            .quick-search-box {
                gap: 7px;
                padding-left: 10px;
            }

            .quick-search-button {
                gap: 5px;
                padding: 0 10px;
            }

            .quick-search-input { font-size: 12px; }

            .hero-actions {
                align-items: stretch;
                flex-direction: column;
            }

            .hero-actions a { width: 100%; }

            .preview-stats { gap: 6px; }

            .preview-stat { padding: 10px 7px; }

            .preview-stat-value { font-size: 19px; }

            .preview-stat-label { font-size: 8px; }

            .dashboard-body { padding: 17px 11px; }

            .dashboard-top { padding: 13px 11px; }

            .preview-row {
                gap: 5px;
                padding: 10px 8px;
            }

            .person { gap: 5px; }

            .person-name { font-size: 9px; }

            .person-email { font-size: 7px; }

            .member-type { font-size: 8px; }

            .status-pill {
                gap: 4px;
                padding: 4px 5px;
                font-size: 7px;
            }

            .floating-note { right: 0; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                scroll-behavior: auto !important;
                transition-duration: .01ms !important;
                animation-duration: .01ms !important;
            }
        }
    </style>
</head>

<body>
<%
    String base = request.getContextPath();
%>

<header class="navbar">
    <div class="container nav-inner">
        <a class="brand" href="<%= base %>/" aria-label="LMS home">
            <span class="brand-mark">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.8" stroke-linecap="round"
                     stroke-linejoin="round" aria-hidden="true">
                    <path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v16H6.5A2.5 2.5 0 0 0 4 21.5z"/>
                    <path d="M4 5.5v16M8 7h8M8 11h7"/>
                </svg>
            </span>
            <span>
                LMS
                <span class="brand-subtitle">Library management</span>
            </span>
        </a>

        <nav class="nav-links" aria-label="Main navigation">
            <a href="#features">Features</a>
            <a href="#about">About LMS</a>
            <a class="nav-cta" href="<%= base %>/members">
                Open member directory
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round"
                     stroke-linejoin="round" aria-hidden="true">
                    <path d="M5 12h14M13 6l6 6-6 6"/>
                </svg>
            </a>
        </nav>
    </div>
</header>

<main>
    <section class="hero" id="about">
        <div class="container hero-grid">
            <div class="hero-copy">
                <div class="eyebrow">
                    <span class="eyebrow-dot"></span>
                    A smarter library experience
                </div>

                <h1>
                    Library management,
                    <span class="hero-highlight">made simpler.</span>
                </h1>

                <p class="hero-description">
                    Bring clarity to member records, simplify everyday
                    administration, and manage your library's membership
                    experience through one focused workspace.
                </p>

                <!-- Quick Search: uses the existing MemberListServlet -->
                <form class="quick-search"
                      action="<%= base %>/members"
                      method="get"
                      role="search">

                    <label class="quick-search-label" for="memberSearch">
                        Find a member
                    </label>

                    <div class="quick-search-box">
                        <svg class="quick-search-icon"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             aria-hidden="true">
                            <circle cx="11" cy="11" r="7"/>
                            <path d="m20 20-4-4"/>
                        </svg>

                        <input
                            class="quick-search-input"
                            type="search"
                            id="memberSearch"
                            name="search"
                            placeholder="Name, email or member code..."
                            maxlength="150"
                            autocomplete="off"
                            aria-describedby="memberSearchHint">

                        <button class="quick-search-button" type="submit">
                            Search
                            <svg viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="2"
                                 stroke-linecap="round"
                                 stroke-linejoin="round"
                                 aria-hidden="true">
                                <path d="M5 12h14M13 6l6 6-6 6"/>
                            </svg>
                        </button>
                    </div>

                    <p class="quick-search-hint" id="memberSearchHint">
                        Search the directory using the member search available in LMS.
                    </p>
                </form>

                <div class="hero-actions">
                    <a class="button-primary" href="<%= base %>/members">
                        Explore member directory
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M5 12h14M13 6l6 6-6 6"/>
                        </svg>
                    </a>

                    <a class="button-secondary" href="#features">
                        Discover the platform
                    </a>
                </div>

                <div class="hero-note">
                    <svg viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <path d="m5 12 4 4L19 6"/>
                    </svg>
                    Focused workflows. Clear records. Less friction.
                </div>
            </div>

            <!-- Illustrative UI preview; not connected to live statistics -->
            <div class="preview-wrap"
                 aria-label="Illustrative member management dashboard preview">
                <div class="preview-glow"></div>

                <div class="dashboard">
                    <div class="dashboard-top">
                        <div class="dashboard-title">
                            <span class="mini-brand">
                                <svg viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="1.8"
                                     stroke-linecap="round"
                                     stroke-linejoin="round"
                                     aria-hidden="true">
                                    <path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v16H6.5A2.5 2.5 0 0 0 4 21.5z"/>
                                    <path d="M4 5.5v16M8 7h8M8 11h7"/>
                                </svg>
                            </span>
                            Member workspace
                        </div>
                        <span class="preview-label">UI PREVIEW</span>
                    </div>

                    <div class="dashboard-body">
                        <h2 class="preview-heading">Member overview</h2>
                        <p class="preview-subheading">
                            A clear view of your membership workspace.
                        </p>

                        <div class="preview-stats">
                            <div class="preview-stat">
                                <span class="preview-stat-icon">
                                    <svg viewBox="0 0 24 24" fill="none"
                                         stroke="currentColor" stroke-width="1.8"
                                         stroke-linecap="round"
                                         stroke-linejoin="round"
                                         aria-hidden="true">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                                        <circle cx="9" cy="7" r="4"/>
                                        <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
                                    </svg>
                                </span>
                                <span class="preview-stat-label">Members</span>
                                <span class="preview-stat-value">—</span>
                            </div>

                            <div class="preview-stat">
                                <span class="preview-stat-icon">
                                    <svg viewBox="0 0 24 24" fill="none"
                                         stroke="currentColor" stroke-width="1.8"
                                         stroke-linecap="round"
                                         stroke-linejoin="round"
                                         aria-hidden="true">
                                        <path d="M20 7v10M4 7v10M4 12h16"/>
                                        <path d="M7 7V4h10v3M7 17v3h10v-3"/>
                                    </svg>
                                </span>
                                <span class="preview-stat-label">Records</span>
                                <span class="preview-stat-value">—</span>
                            </div>

                            <div class="preview-stat">
                                <span class="preview-stat-icon">
                                    <svg viewBox="0 0 24 24" fill="none"
                                         stroke="currentColor" stroke-width="1.8"
                                         stroke-linecap="round"
                                         stroke-linejoin="round"
                                         aria-hidden="true">
                                        <circle cx="12" cy="12" r="9"/>
                                        <path d="m8 12 2.5 2.5L16 9"/>
                                    </svg>
                                </span>
                                <span class="preview-stat-label">Status</span>
                                <span class="preview-stat-value"
                                      style="font-size:15px;letter-spacing:-.3px;">
                                    Tracked
                                </span>
                            </div>
                        </div>

                        <div class="preview-table">
                            <div class="preview-table-heading">
                                Member record preview
                            </div>

                            <div class="preview-row">
                                <div class="person">
                                    <span class="person-avatar">AM</span>
                                    <span class="person-copy">
                                        <span class="person-name">Member record</span>
                                        <span class="person-email">Name and contact details</span>
                                    </span>
                                </div>
                                <span class="member-type">Membership</span>
                                <span class="status-pill">Status</span>
                            </div>

                            <div class="preview-row">
                                <div class="person">
                                    <span class="person-avatar"
                                          style="color:#8b5a20;background:#fff2d9;">
                                        MR
                                    </span>
                                    <span class="person-copy">
                                        <span class="person-name">Member record</span>
                                        <span class="person-email">Registration information</span>
                                    </span>
                                </div>
                                <span class="member-type">Details</span>
                                <span class="status-pill">Status</span>
                            </div>

                            <div class="preview-row">
                                <div class="person">
                                    <span class="person-avatar"
                                          style="color:#23765c;background:#e3f7ee;">
                                        LR
                                    </span>
                                    <span class="person-copy">
                                        <span class="person-name">Member record</span>
                                        <span class="person-email">Membership information</span>
                                    </span>
                                </div>
                                <span class="member-type">Records</span>
                                <span class="status-pill">Status</span>
                            </div>
                        </div>

                        <div class="preview-footnote">
                            <svg viewBox="0 0 24 24" fill="none"
                                 stroke="currentColor" stroke-width="1.8"
                                 stroke-linecap="round"
                                 stroke-linejoin="round"
                                 aria-hidden="true">
                                <circle cx="12" cy="12" r="9"/>
                                <path d="M12 11v5M12 8h.01"/>
                            </svg>
                            Illustrative interface — not live database data
                        </div>
                    </div>
                </div>

                <div class="floating-note">
                    <span class="floating-note-icon">
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M9 12l2 2 4-4"/>
                            <circle cx="12" cy="12" r="9"/>
                        </svg>
                    </span>
                    <span>
                        <strong>Designed for clarity</strong>
                        <span class="floating-note-copy">
                            Member details in one place
                        </span>
                    </span>
                </div>
            </div>
        </div>
    </section>

    <section class="feature-section" id="features">
        <div class="container">
            <div class="section-heading">
                <div>
                    <div class="section-kicker">A focused workspace</div>
                    <h2>Everything starts with clarity.</h2>
                </div>
                <p class="section-description">
                    Thoughtful tools for the essential work of managing
                    library membership, organized around the tasks that matter.
                </p>
            </div>

            <div class="feature-grid">
                <article class="feature-card">
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </span>
                    <h3>Member Directory</h3>
                    <p>
                        Access member records in a structured workspace
                        designed for quick scanning and everyday use.
                    </p>
                    <a class="feature-link" href="<%= base %>/members">
                        Open directory
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M5 12h14M13 6l6 6-6 6"/>
                        </svg>
                    </a>
                </article>

                <article class="feature-card">
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <circle cx="11" cy="11" r="7"/>
                            <path d="m20 20-4-4"/>
                        </svg>
                    </span>
                    <h3>Member Search</h3>
                    <p>
                        Find records using the search workflow available
                        in the member directory.
                    </p>
                    <a class="feature-link" href="<%= base %>/members">
                        Find a member
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M5 12h14M13 6l6 6-6 6"/>
                        </svg>
                    </a>
                </article>

                <article class="feature-card">
                    <span class="feature-icon">
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="1.8"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M7 3h8l5 5v13H7a3 3 0 0 1-3-3V6a3 3 0 0 1 3-3z"/>
                            <path d="M15 3v6h5M8 13h7M8 17h7"/>
                        </svg>
                    </span>
                    <h3>Membership Records</h3>
                    <p>
                        Keep registration details, membership types, and
                        status information organized in member records.
                    </p>
                    <a class="feature-link" href="<%= base %>/members">
                        View records
                        <svg viewBox="0 0 24 24" fill="none"
                             stroke="currentColor" stroke-width="2"
                             stroke-linecap="round" stroke-linejoin="round"
                             aria-hidden="true">
                            <path d="M5 12h14M13 6l6 6-6 6"/>
                        </svg>
                    </a>
                </article>
            </div>
        </div>
    </section>

    <section class="closing">
        <div class="container">
            <div class="closing-panel">
                <div class="closing-copy">
                    <h2>Your library workspace starts here.</h2>
                    <p>
                        Open the member directory and work with the
                        membership records available in LMS.
                    </p>
                </div>

                <a class="button-primary" href="<%= base %>/members">
                    Go to member management
                    <svg viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round"
                         aria-hidden="true">
                        <path d="M5 12h14M13 6l6 6-6 6"/>
                    </svg>
                </a>
            </div>
        </div>
    </section>
</main>

<footer class="footer">
    <div class="container footer-inner">
        <span class="footer-brand">LMS · Library Management System</span>
        <span class="footer-copy">A focused, modern library experience.</span>
        <a class="footer-link" href="<%= base %>/members">
            Member Management →
        </a>
    </div>
</footer>

</body>
</html>
