<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Back - ShopWithUs</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            position: relative;
            overflow-x: hidden;
        }

        /* Animated Background with Moving Platform Name */
        .animated-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            overflow: hidden;
        }

        /* Moving Platform Name */
        .moving-platform {
            position: absolute;
            font-size: 120px;
            font-weight: 800;
            white-space: nowrap;
            background: linear-gradient(135deg, rgba(255,255,255,0.15), rgba(255,255,255,0.05));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            pointer-events: none;
            animation: movePlatform 20s ease-in-out infinite;
            text-transform: uppercase;
            letter-spacing: 20px;
        }

        @keyframes movePlatform {
            0% {
                transform: translateX(-10%) translateY(10%) rotate(0deg);
            }
            25% {
                transform: translateX(20%) translateY(-10%) rotate(2deg);
            }
            50% {
                transform: translateX(40%) translateY(20%) rotate(-2deg);
            }
            75% {
                transform: translateX(20%) translateY(30%) rotate(1deg);
            }
            100% {
                transform: translateX(-10%) translateY(10%) rotate(0deg);
            }
        }

        .moving-platform-2 {
            position: absolute;
            font-size: 80px;
            font-weight: 700;
            white-space: nowrap;
            background: linear-gradient(135deg, rgba(255,255,255,0.1), rgba(255,255,255,0.03));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            pointer-events: none;
            animation: movePlatformReverse 25s ease-in-out infinite;
            text-transform: uppercase;
            letter-spacing: 15px;
        }

        @keyframes movePlatformReverse {
            0% {
                transform: translateX(50%) translateY(50%) rotate(0deg);
            }
            25% {
                transform: translateX(-20%) translateY(30%) rotate(-2deg);
            }
            50% {
                transform: translateX(-40%) translateY(60%) rotate(2deg);
            }
            75% {
                transform: translateX(-10%) translateY(70%) rotate(-1deg);
            }
            100% {
                transform: translateX(50%) translateY(50%) rotate(0deg);
            }
        }

        /* Bubbles */
        .bubble {
            position: absolute;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            backdrop-filter: blur(3px);
            border: 1px solid rgba(255,255,255,0.2);
            animation: floatBubble linear infinite;
        }

        @keyframes floatBubble {
            0% {
                transform: translateY(100vh) scale(0.3);
                opacity: 0;
            }
            20% {
                opacity: 0.5;
            }
            80% {
                opacity: 0.5;
            }
            100% {
                transform: translateY(-20vh) scale(1);
                opacity: 0;
            }
        }

        /* Floating Products */
        .floating-product {
            position: absolute;
            font-size: 40px;
            opacity: 0.15;
            pointer-events: none;
            animation: floatProduct 15s ease-in-out infinite;
        }

        @keyframes floatProduct {
            0%, 100% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-30px) rotate(10deg);
            }
        }

        /* Blur Overlay */
        .blur-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            backdrop-filter: blur(4px);
            z-index: 1;
            background: rgba(0, 0, 0, 0.2);
        }

        /* Main Container */
        .container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 100px 20px;
            position: relative;
            z-index: 2;
        }

        /* Glassmorphism Card */
        .login-card {
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(10px);
            border-radius: 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 480px;
            overflow: hidden;
            animation: slideInRight 0.6s ease;
            transition: all 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        .login-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3);
        }

        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(50px); }
            to { opacity: 1; transform: translateX(0); }
        }

        /* Card Header */
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .wave {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 40px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 120" preserveAspectRatio="none"><path d="M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V0H0V27.35A600.21,600.21,0,0,0,321.39,56.44Z" fill="white" opacity="0.5"></path></svg>');
            background-size: cover;
        }

        .logo-icon {
            font-size: 60px;
            animation: pulse 2s infinite;
            display: inline-block;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .card-header h2 {
            color: white;
            font-size: 32px;
            margin-top: 12px;
            font-weight: 700;
        }

        .card-header p {
            color: rgba(255, 255, 255, 0.9);
            margin-top: 8px;
            font-size: 13px;
        }

        /* Social Login */
        .social-login {
            padding: 25px 35px 0;
            background: white;
        }

        .social-buttons {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }

        .social-btn {
            flex: 1;
            padding: 10px;
            border: 2px solid #e0e8f0;
            border-radius: 12px;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            color: #4a5568;
        }

        .social-btn i { font-size: 18px; }
        .social-btn.google i { color: #ea4335; }
        .social-btn.facebook i { color: #1877f2; }

        .social-btn:hover {
            transform: translateY(-2px);
            border-color: #667eea;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .divider {
            text-align: center;
            margin: 20px 0;
            position: relative;
        }

        .divider::before, .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: #e0e8f0;
        }
        .divider::before { left: 0; }
        .divider::after { right: 0; }
        .divider span { background: white; padding: 0 15px; color: #7a8c9e; font-size: 13px; }

        /* Card Body */
        .card-body {
            padding: 0 35px 35px;
            background: white;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group i.input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            font-size: 16px;
            transition: all 0.3s;
            z-index: 1;
        }

        .form-group input {
            width: 100%;
            padding: 12px 40px 12px 42px;
            border: 2px solid #e0e8f0;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s;
            outline: none;
            background: #f8fafc;
        }

        .form-group input:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .form-group input:focus + .input-icon {
            transform: translateY(-50%) scale(1.1);
            color: #764ba2;
        }

        /* Currency Selector - Compact */
        .currency-selector {
            width: 100%;
            padding: 12px 15px 12px 42px;
            border: 2px solid #e0e8f0;
            border-radius: 12px;
            font-size: 14px;
            background: #f8fafc;
            cursor: pointer;
            outline: none;
            transition: all 0.3s;
        }

        .currency-selector:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        /* Password Toggle Button */
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #7a8c9e;
            font-size: 16px;
            padding: 5px;
            z-index: 2;
            transition: color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .password-toggle:hover {
            color: #667eea;
        }

        /* Options Row */
        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            color: #4a5568;
        }

        .checkbox-label input {
            width: 16px;
            height: 16px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .forgot-link {
            color: #667eea;
            text-decoration: none;
            transition: 0.3s;
        }

        .forgot-link:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        /* Login Button */
        .login-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .login-btn::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .login-btn:active::after {
            width: 300px;
            height: 300px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        /* Register Link */
        .register-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e0e8f0;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }

        .register-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        /* Alert */
        .alert {
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: shake 0.5s ease;
            font-size: 14px;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }

        .alert i { font-size: 18px; }

        /* Loading Spinner */
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .optional-text {
            font-size: 11px;
            color: #999;
            text-align: right;
            margin-top: 5px;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .card-header { padding: 30px 25px; }
            .card-body, .social-login { padding-left: 25px; padding-right: 25px; }
            .logo-icon { font-size: 45px; }
            .card-header h2 { font-size: 24px; }
            .social-buttons { flex-direction: column; }
            .moving-platform { font-size: 60px; letter-spacing: 10px; }
            .moving-platform-2 { font-size: 40px; letter-spacing: 8px; }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="animated-bg">
        <!-- Moving Platform Names -->
        <div class="moving-platform">SHOPWITHUS</div>
        <div class="moving-platform-2">SHOPWITHUS</div>

        <!-- Bubbles will be added via JavaScript -->

        <!-- Floating Products -->
        <div class="floating-product" style="top: 10%; left: 5%; animation-duration: 12s;">🛍️</div>
        <div class="floating-product" style="top: 20%; right: 8%; animation-duration: 14s; animation-delay: 2s;">👗</div>
        <div class="floating-product" style="bottom: 15%; left: 10%; animation-duration: 16s; animation-delay: 4s;">👟</div>
        <div class="floating-product" style="top: 60%; right: 12%; animation-duration: 13s; animation-delay: 1s;">📱</div>
        <div class="floating-product" style="bottom: 30%; right: 20%; animation-duration: 18s; animation-delay: 3s;">💄</div>
        <div class="floating-product" style="top: 40%; left: 15%; animation-duration: 15s; animation-delay: 5s;">⌚</div>
        <div class="floating-product" style="bottom: 50%; left: 25%; animation-duration: 20s; animation-delay: 2.5s;">🎧</div>
        <div class="floating-product" style="top: 75%; right: 25%; animation-duration: 17s; animation-delay: 6s;">👜</div>
    </div>

    <!-- Blur Overlay -->
    <div class="blur-overlay"></div>

    <div class="container">
        <div class="login-card">
            <div class="card-header">
                <div class="logo-icon">🛍️</div>
                <h2>Welcome Back!</h2>
                <p>Sign in to continue your shopping journey</p>
                <div class="wave"></div>
            </div>

            <div class="social-login">
                <p style="color: #7a8c9e; font-size: 13px; text-align: center;">Quick access</p>
                <div class="social-buttons">
                    <button class="social-btn google" onclick="alert('Google login coming soon!')">
                        <i class="fab fa-google"></i> Google
                    </button>
                    <button class="social-btn facebook" onclick="alert('Facebook login coming soon!')">
                        <i class="fab fa-facebook-f"></i> Facebook
                    </button>
                </div>
                <div class="divider"><span>or sign in with email</span></div>
            </div>

            <div class="card-body">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <!-- Currency Selector - Optional, Compact -->
                <div class="form-group">
                    <i class="fas fa-money-bill-wave input-icon"></i>
                    <select name="currency" id="currencySelect" class="currency-selector">
                        <option value="CNY" selected>🇨🇳 Chinese Yuan (CNY) - Default</option>
                        <option value="XAF">🇨🇲 CFA Franc (XAF)</option>
                        <option value="USD">🇺🇸 US Dollar (USD)</option>
                        <option value="GBP">🇬🇧 British Pound (GBP)</option>
                        <option value="EUR">🇪🇺 Euro (EUR)</option>
                        <option value="NGN">🇳🇬 Nigerian Naira (NGN)</option>
                        <option value="JPY">🇯🇵 Japanese Yen (JPY)</option>
                        <option value="INR">🇮🇳 Indian Rupee (INR)</option>
                        <option value="CAD">🇨🇦 Canadian Dollar (CAD)</option>
                        <option value="AUD">🇦🇺 Australian Dollar (AUD)</option>
                        <option value="BRL">🇧🇷 Brazilian Real (BRL)</option>
                        <option value="ZAR">🇿🇦 South African Rand (ZAR)</option>
                        <option value="KES">🇰🇪 Kenyan Shilling (KES)</option>
                        <option value="GHS">🇬🇭 Ghanaian Cedi (GHS)</option>
                    </select>
                </div>
                <div class="optional-text">Optional - Your preferred currency</div>

                <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                    <div class="form-group">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" name="email" id="email" required placeholder="Email Address">
                    </div>

                    <div class="form-group">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" name="password" id="password" required placeholder="Password">
                        <button type="button" class="password-toggle" id="togglePassword">
                            <i class="fas fa-eye-slash"></i>
                        </button>
                    </div>

                    <div class="options-row">
                        <label class="checkbox-label">
                            <input type="checkbox" name="remember_me">
                            <span>Remember me for 30 days</span>
                        </label>
                        <a href="#" class="forgot-link" onclick="alert('Password reset link sent to your email!')">Forgot Password?</a>
                    </div>

                    <button type="submit" class="login-btn" id="loginBtn">
                        Sign In
                    </button>
                </form>

                <div class="register-link">
                    New to ShopWithUs? <a href="register.jsp">Create an account <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Generate Bubbles
        function createBubbles() {
            var container = document.querySelector('.animated-bg');
            var bubbleCount = 40;

            for (var i = 0; i < bubbleCount; i++) {
                var bubble = document.createElement('div');
                bubble.className = 'bubble';

                var size = Math.random() * 80 + 15;
                bubble.style.width = size + 'px';
                bubble.style.height = size + 'px';

                bubble.style.left = Math.random() * 100 + '%';

                var duration = Math.random() * 12 + 10;
                bubble.style.animationDuration = duration + 's';

                bubble.style.animationDelay = Math.random() * 15 + 's';

                container.appendChild(bubble);
            }
        }

        createBubbles();

        // Save currency preference to localStorage
        var currencySelect = document.getElementById('currencySelect');
        if (currencySelect) {
            // Load saved currency
            var savedCurrency = localStorage.getItem('preferredCurrency');
            if (savedCurrency) {
                currencySelect.value = savedCurrency;
            }

            // Save currency when changed
            currencySelect.addEventListener('change', function() {
                localStorage.setItem('preferredCurrency', this.value);
            });
        }

        // Password Toggle Functionality
        var togglePassword = document.getElementById('togglePassword');
        var passwordInput = document.getElementById('password');

        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function() {
                var type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.querySelector('i').classList.toggle('fa-eye');
                this.querySelector('i').classList.toggle('fa-eye-slash');
            });
        }

        // Form submission loading effect
        var loginForm = document.getElementById('loginForm');
        if (loginForm) {
            loginForm.addEventListener('submit', function(e) {
                var btn = document.getElementById('loginBtn');
                btn.innerHTML = '<span class="loading-spinner"></span> Signing in...';
                btn.disabled = true;
            });
        }

        // Input focus animations
        var inputs = document.querySelectorAll('.form-group input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateX(3px)';
            });
            inputs[i].addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateX(0)';
            });
        }
    </script>
</body>
</html>