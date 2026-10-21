<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>LMS Login</title>

    <style>
        :root {
            --forest: #193b2d;
            --dark-green: #153326;
            --green-accent: #285640;
            --cream: #f5f1e9;
            --surface: #fffdf9;
            --terracotta: #bd6949;
            --text: #292821;
            --muted: #79776e;
            --border: #e4dfd4;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px 18px;
            background: var(--cream);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .login-card {
            width: 100%;
            max-width: 900px;
            min-height: 520px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 20px 60px rgba(25, 59, 45, 0.10);
        }

        .brand-panel {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 48px 40px;
            color: var(--surface);
            background:
                    radial-gradient(
                            circle at 90% 15%,
                            rgba(189, 105, 73, 0.25),
                            transparent 32%
                    ),
                    linear-gradient(145deg, var(--forest), var(--dark-green));
        }

        .brand-name {
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 3px;
            text-transform: uppercase;
        }

        .brand-content {
            margin: 45px 0;
        }

        .brand-label {
            margin-bottom: 18px;
            color: #e5b49d;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .brand-panel h1 {
            margin-bottom: 22px;
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(32px, 4vw, 46px);
            font-weight: 400;
            line-height: 1.18;
        }

        .brand-description {
            max-width: 300px;
            color: #d7e0d8;
            font-size: 14px;
            line-height: 1.9;
        }

        .brand-footer {
            color: #c1d0c5;
            font-size: 12px;
            line-height: 1.8;
        }

        .form-panel {
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 48px 42px;
        }

        .form-eyebrow {
            margin-bottom: 12px;
            color: var(--terracotta);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .form-panel h2 {
            margin-bottom: 12px;
            color: var(--forest);
            font-family: Georgia, "Times New Roman", serif;
            font-size: 34px;
            font-weight: 400;
        }

        .form-description {
            margin-bottom: 32px;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.7;
        }

        .error-message {
            margin-bottom: 22px;
            padding: 13px 15px;
            border: 1px solid #e7b8a8;
            border-radius: 8px;
            background: #fff0eb;
            color: #963e2b;
            font-size: 13px;
            line-height: 1.5;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            color: var(--text);
            font-size: 13px;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 14px 15px;
            border: 1px solid var(--border);
            border-radius: 8px;
            outline: none;
            background: #fff;
            color: var(--text);
            font: inherit;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input::placeholder {
            color: #aaa69b;
        }

        .form-group input:focus {
            border-color: var(--green-accent);
            box-shadow: 0 0 0 3px rgba(40, 86, 64, 0.12);
        }

        .login-button {
            width: 100%;
            margin-top: 5px;
            padding: 15px 18px;
            border: none;
            border-radius: 8px;
            background: var(--forest);
            color: #fffdf9;
            font: inherit;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .login-button:hover {
            background: var(--green-accent);
            transform: translateY(-1px);
        }

        .login-button:focus-visible {
            outline: 3px solid var(--terracotta);
            outline-offset: 3px;
        }

        .form-note {
            margin-top: 25px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.7;
            text-align: center;
        }

        @media (max-width: 680px) {
            body {
                align-items: flex-start;
                padding: 18px 12px;
            }

            .login-card {
                max-width: 440px;
                grid-template-columns: 1fr;
            }

            .brand-panel {
                min-height: 235px;
                padding: 28px;
            }

            .brand-content {
                margin: 30px 0 15px;
            }

            .brand-panel h1 {
                font-size: 34px;
            }

            .brand-description {
                font-size: 13px;
            }

            .brand-footer {
                display: none;
            }

            .form-panel {
                padding: 35px 28px;
            }

            .form-panel h2 {
                font-size: 30px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                transition: none !important;
                animation: none !important;
            }
        }
    </style>

</head>
<body>

<div class="login-card">

    <section class="brand-panel">
        <div class="brand-label">LMS . Library</div>

        <div class="brand-content">
            <p class="brand-label">Welcome to your library</p>

            <h1>Every book opens a new door.</h1>

            <p class="brand-description">
                Discover knowledge, explore new ideas, and manage your library experience in one place.
            </p>
        </div>

        <div class="brand-footer">
            A space for readers, learners, and knowledge seekers.
        </div>
    </section>

    <section class="form-panel">

        <p class="form-eyebrow">Member access</p>

        <h2>Welcome back.</h2>

        <p class="form-description">
            Sign in with your username and password to continue.
        </p>

<% String error = request.getParameter("error"); %>

<% if ("empty".equals(error)) { %>
    <div class="error-message" role="alert">
        Please enter both username and password.
    </div>
<% } else if ("invalid".equals(error)) { %>
    <div class="error-message" role="alert">
        Invalid username or password.
    </div>
<% } %>

<form action="login" method="post">

    <div class="form-group">
        <label for="username">Username</label>
        <input
                type="text"
                id="username"
                name="username"
                placeholder="Enter your username"
                autocomplete="username"
                required
        >
    </div>

    <div class="form-group">
        <label for="password">Password</label>
        <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your password"
                autocomplete="current-password"
                required
        >
    </div>

    <button type="submit" class="login-button">
        Sign In
    </button>

</form>

        <p class="form-note">
            Library Management System<br>
            Secure access to your library account.
        </p>

    </section>

</div>

</body>
</html>