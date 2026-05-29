<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join ShopWithUs - Create Account</title>
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
            background: linear-gradient(135deg, #0b4f3c 0%, #1a7a5c 50%, #2a9d8f 100%);
            position: relative;
            overflow-x: hidden;
        }

        /* Animated Background */
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
            0% { transform: translateX(-10%) translateY(10%) rotate(0deg); }
            25% { transform: translateX(20%) translateY(-10%) rotate(2deg); }
            50% { transform: translateX(40%) translateY(20%) rotate(-2deg); }
            75% { transform: translateX(20%) translateY(30%) rotate(1deg); }
            100% { transform: translateX(-10%) translateY(10%) rotate(0deg); }
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
            0% { transform: translateX(50%) translateY(50%) rotate(0deg); }
            25% { transform: translateX(-20%) translateY(30%) rotate(-2deg); }
            50% { transform: translateX(-40%) translateY(60%) rotate(2deg); }
            75% { transform: translateX(-10%) translateY(70%) rotate(-1deg); }
            100% { transform: translateX(50%) translateY(50%) rotate(0deg); }
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
            0% { transform: translateY(100vh) scale(0.3); opacity: 0; }
            20% { opacity: 0.5; }
            80% { opacity: 0.5; }
            100% { transform: translateY(-20vh) scale(1); opacity: 0; }
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
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
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
            padding: 100px 20px 40px;
            position: relative;
            z-index: 2;
        }

        /* Glassmorphism Card */
        .register-card {
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(10px);
            border-radius: 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 600px;
            overflow: hidden;
            animation: slideUp 0.6s ease;
            transition: transform 0.3s;
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        .register-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.25);
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Card Header */
        .card-header {
            background: linear-gradient(135deg, #0b8f5c 0%, #0a7a4d 100%);
            padding: 35px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: shine 3s infinite;
        }

        @keyframes shine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .logo {
            font-size: 42px;
            font-weight: 800;
            color: white;
            margin-bottom: 8px;
            display: inline-block;
            animation: gentleBounce 2s infinite;
        }

        @keyframes gentleBounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-3px); }
        }

        .card-header h2 {
            color: white;
            font-size: 28px;
            margin-top: 8px;
            font-weight: 600;
        }

        .card-header p {
            color: rgba(255, 255, 255, 0.9);
            margin-top: 6px;
            font-size: 13px;
        }

        /* Card Body */
        .card-body {
            padding: 35px;
            background: white;
        }

        /* Two Column Layout */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 5px;
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
            color: #0b8f5c;
            font-size: 16px;
            z-index: 1;
        }

        .form-group textarea + .input-icon {
            top: 22px;
            transform: translateY(-50%);
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 15px 12px 42px;
            border: 2px solid #e0e8f0;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s;
            outline: none;
            background: #f8fafc;
        }

        .form-group textarea {
            padding-top: 12px;
            resize: vertical;
            min-height: 70px;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #0b8f5c;
            background: white;
            box-shadow: 0 0 0 4px rgba(11, 143, 92, 0.1);
        }

        .form-group input:focus + .input-icon,
        .form-group textarea:focus + .input-icon {
            transform: translateY(-50%) scale(1.1);
            color: #0b8f5c;
        }

        /* Optional Field Badge */
        .optional-badge {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 10px;
            color: #999;
            background: #f0f0f0;
            padding: 2px 8px;
            border-radius: 20px;
            pointer-events: none;
            z-index: 1;
        }

        textarea + .optional-badge {
            top: 22px;
            transform: translateY(-50%);
        }

        /* Location Button */
        .location-btn {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #0b8f5c;
            cursor: pointer;
            font-size: 18px;
            padding: 5px;
            z-index: 2;
            transition: 0.3s;
        }

        .location-btn:hover {
            color: #087a4c;
            transform: translateY(-50%) scale(1.1);
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
            color: #0b8f5c;
        }

        /* Password Requirements */
        .password-requirements {
            margin-top: 8px;
            font-size: 11px;
            color: #7a8c9e;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .req-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .req-item i {
            font-size: 9px;
            color: #7a8c9e;
            position: static;
            transform: none;
        }

        .req-item.valid i {
            color: #0b8f5c;
        }

        /* Loading Spinner for Location */
        .location-loading {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            border: 2px solid #e0e8f0;
            border-top-color: #0b8f5c;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            z-index: 2;
        }

        @keyframes spin {
            to { transform: translateY(-50%) rotate(360deg); }
        }

        /* Submit Button */
        .register-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #0b8f5c 0%, #0a7a4d 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            margin-top: 10px;
        }

        .register-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .register-btn:hover::before {
            left: 100%;
        }

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(11, 143, 92, 0.3);
        }

        /* Login Link */
        .login-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #e0e8f0;
        }

        .login-link a {
            color: #0b8f5c;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }

        .login-link a:hover {
            color: #087a4c;
            text-decoration: underline;
        }

        /* Alert Messages */
        .alert {
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.3s ease;
            font-size: 14px;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }

        .alert-success {
            background: #dcfce7;
            color: #16a34a;
            border-left: 4px solid #16a34a;
        }

        .alert-info {
            background: #dbeafe;
            color: #2563eb;
            border-left: 4px solid #2563eb;
        }

        .alert i { font-size: 18px; }

        /* Responsive */
        @media (max-width: 600px) {
            .card-header { padding: 25px; }
            .card-body { padding: 25px; }
            .logo { font-size: 32px; }
            .card-header h2 { font-size: 22px; }
            .form-row { grid-template-columns: 1fr; gap: 0; }
            .moving-platform { font-size: 60px; letter-spacing: 10px; }
            .moving-platform-2 { font-size: 40px; letter-spacing: 8px; }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="animated-bg">
        <div class="moving-platform">SHOPWITHUS</div>
        <div class="moving-platform-2">SHOPWITHUS</div>

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

    <div class="blur-overlay"></div>

    <div class="container">
        <div class="register-card">
            <div class="card-header">
                <div class="logo">🛍️ ShopWithUs!</div>
                <h2>Create Account</h2>
                <p>Join our premium shopping community</p>
            </div>

            <div class="card-body">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                    <!-- Full Name - Required -->
                    <div class="form-group">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" name="fullname" id="fullname" required placeholder="Full Name *">
                    </div>

                    <!-- Nickname/Username - Optional -->
                    <div class="form-group">
                        <i class="fas fa-user-tag input-icon"></i>
                        <input type="text" name="nickname" id="nickname" placeholder="Nickname / Username (optional)">
                        <span class="optional-badge">Optional</span>
                    </div>

                    <!-- Email - Required -->
                    <div class="form-group">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" name="email" id="email" required placeholder="Email Address *">
                    </div>

                    <!-- Password Fields -->
                    <div class="form-row">
                        <div class="form-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" name="password" id="password" required placeholder="Password *">
                            <button type="button" class="password-toggle" id="togglePassword">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>

                        <div class="form-group">
                            <i class="fas fa-check-circle input-icon"></i>
                            <input type="password" name="confirm_password" id="confirmPassword" required placeholder="Confirm Password *">
                        </div>
                    </div>

                    <!-- Password Requirements -->
                    <div class="password-requirements">
                        <span class="req-item" id="lengthReq"><i class="fas fa-circle"></i> Min 6 chars</span>
                        <span class="req-item" id="upperReq"><i class="fas fa-circle"></i> Uppercase</span>
                        <span class="req-item" id="numberReq"><i class="fas fa-circle"></i> Number</span>
                    </div>

                    <!-- Contact Info -->
                    <div class="form-row">
                        <div class="form-group">
                            <i class="fas fa-phone input-icon"></i>
                            <input type="tel" name="phone" id="phone" placeholder="Phone Number">
                            <span class="optional-badge">Optional</span>
                        </div>

                        <div class="form-group">
                            <i class="fas fa-city input-icon"></i>
                            <input type="text" name="city" id="city" placeholder="City">
                            <span class="optional-badge">Optional</span>
                        </div>
                    </div>

                    <!-- Address with Real-time Location -->
                    <div class="form-group">
                        <i class="fas fa-location-dot input-icon"></i>
                        <textarea name="address" id="address" placeholder="Full Delivery Address (Optional - Can be added later)"></textarea>
                        <span class="optional-badge">Optional</span>
                        <button type="button" class="location-btn" id="getLocationBtn" title="Use my current location">
                            <i class="fas fa-map-marker-alt"></i>
                        </button>
                    </div>

                    <!-- Location Status Message -->
                    <div id="locationStatus" style="font-size: 12px; color: #666; margin-top: -10px; margin-bottom: 10px; display: none;"></div>

                    <button type="submit" class="register-btn" id="registerBtn">
                        <i class="fas fa-user-plus"></i> Create Account
                    </button>
                </form>

                <div class="login-link">
                    Already have an account? <a href="login.jsp">Sign in here <i class="fas fa-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Generate Bubbles
        function createBubbles() {
            const container = document.querySelector('.animated-bg');
            const bubbleCount = 50;

            for (let i = 0; i < bubbleCount; i++) {
                const bubble = document.createElement('div');
                bubble.className = 'bubble';
                const size = Math.random() * 80 + 15;
                bubble.style.width = size + 'px';
                bubble.style.height = size + 'px';
                bubble.style.left = Math.random() * 100 + '%';
                const duration = Math.random() * 12 + 10;
                bubble.style.animationDuration = duration + 's';
                bubble.style.animationDelay = Math.random() * 15 + 's';
                container.appendChild(bubble);
            }
        }

        createBubbles();

        // Password Toggle Functionality
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');

        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.querySelector('i').classList.toggle('fa-eye');
                this.querySelector('i').classList.toggle('fa-eye-slash');
            });
        }

        // Password validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const lengthReq = document.getElementById('lengthReq');
        const upperReq = document.getElementById('upperReq');
        const numberReq = document.getElementById('numberReq');

        if (password) {
            password.addEventListener('input', function() {
                if (this.value.length >= 6) {
                    lengthReq.classList.add('valid');
                    lengthReq.querySelector('i').className = 'fas fa-check-circle';
                } else {
                    lengthReq.classList.remove('valid');
                    lengthReq.querySelector('i').className = 'fas fa-circle';
                }
                if (/[A-Z]/.test(this.value)) {
                    upperReq.classList.add('valid');
                    upperReq.querySelector('i').className = 'fas fa-check-circle';
                } else {
                    upperReq.classList.remove('valid');
                    upperReq.querySelector('i').className = 'fas fa-circle';
                }
                if (/[0-9]/.test(this.value)) {
                    numberReq.classList.add('valid');
                    numberReq.querySelector('i').className = 'fas fa-check-circle';
                } else {
                    numberReq.classList.remove('valid');
                    numberReq.querySelector('i').className = 'fas fa-circle';
                }
            });
        }

        if (confirmPassword) {
            confirmPassword.addEventListener('input', function() {
                if (this.value !== password.value) {
                    this.style.borderColor = '#dc2626';
                } else {
                    this.style.borderColor = '#0b8f5c';
                }
            });
        }

        // Real-time Location Detection
        const getLocationBtn = document.getElementById('getLocationBtn');
        const addressField = document.getElementById('address');
        const locationStatus = document.getElementById('locationStatus');

        function getCurrentLocation() {
            if (!navigator.geolocation) {
                showLocationStatus('Geolocation is not supported by your browser', 'error');
                return;
            }

            // Show loading state
            const originalIcon = getLocationBtn.innerHTML;
            getLocationBtn.innerHTML = '<div class="location-loading"></div>';
            getLocationBtn.disabled = true;

            navigator.geolocation.getCurrentPosition(
                function(position) {
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;

                    // Get address from coordinates using reverse geocoding
                    fetchAddressFromCoordinates(lat, lng);
                    getLocationBtn.innerHTML = originalIcon;
                    getLocationBtn.disabled = false;
                },
                function(error) {
                    getLocationBtn.innerHTML = originalIcon;
                    getLocationBtn.disabled = false;

                    let errorMessage = '';
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            errorMessage = 'Location permission denied. Please enable location services.';
                            break;
                        case error.POSITION_UNAVAILABLE:
                            errorMessage = 'Location information unavailable.';
                            break;
                        case error.TIMEOUT:
                            errorMessage = 'Location request timed out.';
                            break;
                        default:
                            errorMessage = 'An unknown error occurred.';
                    }
                    showLocationStatus(errorMessage, 'error');
                },
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 0
                }
            );
        }

        function fetchAddressFromCoordinates(lat, lng) {
            showLocationStatus('Getting your address...', 'info');

            // Using OpenStreetMap Nominatim API (free, no API key required)
            const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&addressdetails=1`;

            fetch(url, {
                headers: {
                    'User-Agent': 'ShopWithUs E-commerce Platform'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data && data.display_name) {
                    const address = data.display_name;
                    const city = data.address?.city || data.address?.town || data.address?.village || '';
                    const country = data.address?.country || '';

                    // Format the address nicely
                    let formattedAddress = address;

                    // Update address field
                    addressField.value = formattedAddress;

                    // Update city field if empty
                    const cityField = document.getElementById('city');
                    if (cityField && !cityField.value && city) {
                        cityField.value = city;
                    }

                    showLocationStatus('✓ Location detected successfully! Address filled.', 'success');

                    // Auto-hide status after 3 seconds
                    setTimeout(() => {
                        locationStatus.style.display = 'none';
                    }, 3000);
                } else {
                    showLocationStatus('Could not get address. Please enter manually.', 'error');
                }
            })
            .catch(error => {
                console.error('Error fetching address:', error);
                // Fallback: Just show coordinates
                addressField.value = `Latitude: ${lat}, Longitude: ${lng}`;
                showLocationStatus('Address lookup failed. Coordinates added. You can edit manually.', 'info');
            });
        }

        function showLocationStatus(message, type) {
            locationStatus.style.display = 'block';
            locationStatus.innerHTML = message;
            locationStatus.style.color = type === 'error' ? '#dc2626' : (type === 'success' ? '#16a34a' : '#2563eb');

            // Auto-hide after 5 seconds for success/info
            if (type !== 'error') {
                setTimeout(() => {
                    if (locationStatus.style.display !== 'none') {
                        locationStatus.style.opacity = '0';
                        setTimeout(() => {
                            locationStatus.style.display = 'none';
                            locationStatus.style.opacity = '1';
                        }, 500);
                    }
                }, 5000);
            }
        }

        if (getLocationBtn) {
            getLocationBtn.addEventListener('click', getCurrentLocation);
        }

        // Form submission validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const registerBtn = document.getElementById('registerBtn');

            // Validate password match
            if (password.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Passwords do not match!');
                return;
            }

            // Validate password length
            if (password.value.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters!');
                return;
            }

            // Validate email format
            const email = document.getElementById('email').value;
            if (!email.match(/^[A-Za-z0-9+_.-]+@(.+)$/)) {
                e.preventDefault();
                alert('Please enter a valid email address!');
                return;
            }

            // Show loading state on button
            registerBtn.innerHTML = '<i class="fas fa-spinner fa-pulse"></i> Creating account...';
            registerBtn.disabled = true;
        });

        // Input focus animations
        const inputs = document.querySelectorAll('.form-group input, .form-group textarea');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateX(3px)';
            });
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateX(0)';
            });
        });

        // Check if browser supports geolocation and show hint
        if (navigator.geolocation && getLocationBtn) {
            getLocationBtn.title = "Click to use your current location";
        } else if (getLocationBtn) {
            getLocationBtn.style.display = 'none';
        }
    </script>
</body>
</html>