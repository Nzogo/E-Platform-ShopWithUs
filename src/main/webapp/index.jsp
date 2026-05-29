<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopWithUs - Smart Shopping Platform</title>
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
            background: #f6f8fb;
            overflow-x: hidden;
            color: #111;
        }

        html {
            scroll-behavior: smooth;
        }

        a {
            text-decoration: none;
        }

        /* NAVBAR */
        .navbar {
            width: 100%;
            height: 90px;
            background: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 7%;
            position: fixed;
            top: 0;
            z-index: 999;
            box-shadow: 0 2px 20px rgba(0,0,0,0.05);
        }

        .logo {
            font-size: 38px;
            font-weight: 800;
            color: #0b8f5c;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
        }

        .nav-buttons a {
            padding: 12px 28px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

        .login-btn {
            border: 2px solid #0b8f5c;
            color: #0b8f5c;
            background: white;
        }

        .register-btn {
            background: #0b8f5c;
            color: white;
        }

        .nav-buttons a:hover {
            transform: translateY(-2px);
        }

        /* HERO SECTION */
        .hero {
            min-height: 100vh;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 140px 7% 80px;
            position: relative;
        }

        .hero-left {
            width: 50%;
            animation: fadeLeft 1s ease;
        }

        .small-badge {
            display: inline-block;
            background: #dff7eb;
            color: #0b8f5c;
            padding: 10px 18px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 25px;
        }

        .hero-left h1 {
            font-size: 82px;
            line-height: 95px;
            font-weight: 800;
            color: #111;
        }

        .green {
            color: #0b8f5c;
            position: relative;
        }

        .green::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 12px;
            width: 100%;
            height: 18px;
            background: rgba(11,143,92,0.18);
            z-index: -1;
            border-radius: 20px;
        }

        .hero-left p {
            margin-top: 30px;
            font-size: 20px;
            line-height: 38px;
            color: #555;
            width: 90%;
        }

        .hero-buttons {
            margin-top: 40px;
            display: flex;
            gap: 20px;
        }

        .primary-btn {
            background: #0b8f5c;
            color: white;
            padding: 18px 38px;
            border-radius: 14px;
            font-size: 18px;
            font-weight: 600;
            box-shadow: 0 12px 25px rgba(11,143,92,0.25);
            transition: 0.3s;
        }

        .secondary-btn {
            background: white;
            color: #111;
            padding: 18px 35px;
            border-radius: 14px;
            font-size: 18px;
            font-weight: 600;
            border: 1px solid #ddd;
            transition: 0.3s;
        }

        .primary-btn:hover,
        .secondary-btn:hover {
            transform: translateY(-3px);
        }

        /* RIGHT VISUAL */
        .hero-right {
            width: 46%;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeRight 1s ease;
        }

        .visual-wrapper {
            width: 560px;
            height: 560px;
            position: relative;
        }

        .main-screen {
            width: 460px;
            height: 300px;
            background: #111;
            border-radius: 28px;
            position: absolute;
            top: 70px;
            left: 40px;
            padding: 15px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.2);
        }

        .screen-content {
            width: 100%;
            height: 100%;
            background: white;
            border-radius: 18px;
            overflow: hidden;
        }

        .screen-top {
            background: #0b8f5c;
            color: white;
            padding: 14px 20px;
            font-size: 20px;
            font-weight: 700;
        }

        .product-slider {
            display: flex;
            gap: 14px;
            padding: 20px;
            animation: slideProducts 18s linear infinite;
            width: max-content;
        }

        .product {
            width: 140px;
            background: #f5f7fb;
            border-radius: 18px;
            padding: 12px;
            flex-shrink: 0;
            transition: 0.3s;
        }

        .product:hover {
            transform: translateY(-5px);
        }

        .product img {
            width: 100%;
            height: 90px;
            object-fit: cover;
            border-radius: 12px;
        }

        .product h4 {
            margin-top: 10px;
            font-size: 14px;
        }

        .product p {
            color: #0b8f5c;
            font-weight: 700;
            margin-top: 5px;
            font-size: 14px;
        }

        /* FLOATING CARDS */
        .floating-card {
            position: absolute;
            background: white;
            padding: 18px 22px;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
            animation: float 4s ease-in-out infinite;
        }

        .card1 {
            top: 10px;
            right: 0;
        }

        .card2 {
            bottom: 60px;
            left: 0;
        }

        .card3 {
            top: 320px;
            right: 30px;
        }

        /* PERSON */
        .person {
            position: absolute;
            bottom: 0;
            right: 40px;
            animation: bounce 3s infinite;
        }

        .head {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #f2c18d;
            margin: auto;
        }

        .body {
            width: 120px;
            height: 150px;
            background: #0b8f5c;
            border-radius: 35px;
            margin-top: -8px;
            position: relative;
        }

        .arm {
            width: 90px;
            height: 18px;
            background: #f2c18d;
            position: absolute;
            top: 40px;
            left: -35px;
            border-radius: 20px;
            transform: rotate(-2deg);
        }

        .legs {
            display: flex;
            justify-content: center;
            gap: 18px;
            margin-top: -4px;
        }

        .leg {
            width: 20px;
            height: 90px;
            background: #222;
            border-radius: 10px;
        }

        /* STATS */
        .stats {
            width: 100%;
            padding: 20px 7% 100px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
        }

        .stat-card {
            background: white;
            padding: 35px;
            border-radius: 24px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            transition: 0.3s;
            text-align: center;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card h2 {
            color: #0b8f5c;
            font-size: 42px;
        }

        .stat-card p {
            margin-top: 10px;
            color: #666;
            line-height: 28px;
        }

        /* MOVING FEATURES */
        .features-section {
            padding: 70px 0;
            overflow: hidden;
            background: white;
        }

        .section-title {
            text-align: center;
            font-size: 56px;
            margin-bottom: 55px;
            font-weight: 800;
        }

        .moving-track {
            display: flex;
            gap: 25px;
            width: max-content;
            animation: moveCards 25s linear infinite;
        }

        .feature-box {
            min-width: 300px;
            background: #f6f8fb;
            padding: 35px;
            border-radius: 25px;
            text-align: center;
            transition: 0.3s;
        }

        .feature-box:hover {
            transform: translateY(-5px);
            background: #0b8f5c;
            color: white;
        }

        .feature-box h3 {
            font-size: 24px;
            margin-top: 18px;
        }

        .feature-box p {
            margin-top: 12px;
            line-height: 28px;
            font-size: 15px;
        }

        /* DARK SHOWCASE */
        .dark-section {
            background: #07131d;
            color: white;
            padding: 100px 7%;
        }

        .dark-section h2 {
            font-size: 60px;
            margin-bottom: 60px;
        }

        .dark-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
        }

        .dark-card {
            background: #111c26;
            border-radius: 24px;
            overflow: hidden;
            transition: 0.3s;
        }

        .dark-card:hover {
            transform: translateY(-6px);
        }

        .dark-card img {
            width: 100%;
            height: 240px;
            object-fit: cover;
        }

        .dark-content {
            padding: 25px;
        }

        .dark-content h3 {
            font-size: 26px;
            margin-bottom: 10px;
        }

        .dark-content p {
            color: #c8d1db;
            line-height: 30px;
        }

        /* FREE TRIAL */
        .trial-section {
            padding: 110px 7%;
            text-align: center;
        }

        .trial-section h2 {
            font-size: 62px;
            font-weight: 800;
        }

        .trial-section p {
            margin-top: 20px;
            color: #666;
            font-size: 18px;
        }

        .trial-box {
            margin-top: 40px;
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .trial-box input {
            width: 420px;
            padding: 20px;
            border-radius: 15px;
            border: 1px solid #ccc;
            font-size: 16px;
            outline: none;
        }

        .trial-box button {
            background: #111;
            color: white;
            border: none;
            padding: 20px 38px;
            border-radius: 15px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        /* FAQ */
        .faq-section {
            background: #07131d;
            color: white;
            padding: 90px 7%;
        }

        .faq-title {
            font-size: 20px;
            color: #d0d8e0;
            line-height: 38px;
            margin-bottom: 40px;
        }

        .faq-title span {
            color: #00d084;
            font-weight: 700;
        }

        .faq-item {
            padding: 24px 0;
            border-bottom: 1px solid rgba(255,255,255,0.12);
            cursor: pointer;
        }

        .faq-question {
            display: flex;
            justify-content: space-between;
            font-size: 22px;
            font-weight: 500;
        }

        .faq-answer {
            display: none;
            margin-top: 15px;
            color: #d3dbe3;
            line-height: 30px;
            font-size: 16px;
        }

        /* CONTACT */
        .contact {
            padding: 60px 7%;
            background: white;
            text-align: center;
        }

        .contact h2 {
            font-size: 50px;
            margin-bottom: 25px;
        }

        .contact-row {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 25px;
            color: #555;
            font-size: 17px;
        }

        /* FOOTER */
        footer {
            background: #111;
            color: white;
            text-align: center;
            padding: 35px;
        }

        /* TIME BOX */
        .time-box {
            position: fixed;
            right: 20px;
            bottom: 20px;
            background: #111;
            color: white;
            padding: 15px 18px;
            border-radius: 18px;
            z-index: 1000;
            line-height: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
            font-size: 13px;
        }

        .time-box span {
            color: #00ff9d;
            font-weight: 600;
        }

        /* ANIMATIONS */
        @keyframes moveCards {
            from { transform: translateX(0); }
            to { transform: translateX(-50%); }
        }

        @keyframes slideProducts {
            from { transform: translateX(0); }
            to { transform: translateX(-40%); }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes fadeLeft {
            from { opacity: 0; transform: translateX(-60px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes fadeRight {
            from { opacity: 0; transform: translateX(60px); }
            to { opacity: 1; transform: translateX(0); }
        }

        /* RESPONSIVE */
        @media (max-width: 1000px) {
            .hero {
                flex-direction: column;
                gap: 80px;
            }
            .hero-left, .hero-right {
                width: 100%;
                text-align: center;
            }
            .hero-left h1 {
                font-size: 60px;
                line-height: 72px;
            }
            .hero-left p {
                width: 100%;
            }
            .hero-buttons {
                justify-content: center;
            }
            .stats {
                grid-template-columns: 1fr;
            }
            .dark-grid {
                grid-template-columns: 1fr;
            }
            .section-title, .trial-section h2, .dark-section h2 {
                font-size: 42px;
            }
            .navbar {
                padding: 0 20px;
            }
            .logo {
                font-size: 28px;
            }
            .visual-wrapper {
                transform: scale(0.75);
            }
        }
    </style>
</head>
<body>
    <!-- NAVBAR -->
    <div class="navbar">
        <div class="logo">ShopWithUs! 🛍️</div>
        <div class="nav-buttons">
            <a href="user/login.jsp" class="login-btn">Login</a>
            <a href="user/register.jsp" class="register-btn">Register</a>
        </div>
    </div>

    <!-- HERO -->
    <section class="hero">
        <div class="hero-left">
            <div class="small-badge">Smarter Shopping Starts Here</div>
            <h1>A smarter and more convenient way of placing your orders: <span class="green">Shop With Us!</span></h1>
            <p>Discover elegant fashion, premium electronics, delicious food, trending gadgets, beauty products, shoes, and more — all in one beautiful shopping experience designed for speed, convenience, and trust.</p>
            <div class="hero-buttons">
                <a href="user/register.jsp" class="primary-btn">Start Shopping</a>
                <a href="#trial" class="secondary-btn">Free Trial</a>
            </div>
        </div>

        <!-- RIGHT VISUAL -->
        <div class="hero-right">
            <div class="visual-wrapper">
                <div class="floating-card card1">✅ Order Confirmed</div>
                <div class="floating-card card2">🚚 Fast Worldwide Delivery</div>
                <div class="floating-card card3">🔒 Secure Checkout</div>
                <div class="main-screen">
                    <div class="screen-content">
                        <div class="screen-top">ShopWithUs! 🛍️</div>
                        <div class="product-slider">
                            <div class="product">
                                <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff">
                                <h4>Running Shoes</h4>
                                <p>$89</p>
                            </div>
                            <div class="product">
                                <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30">
                                <h4>Smart Watch</h4>
                                <p>$149</p>
                            </div>
                            <div class="product">
                                <img src="https://images.unsplash.com/photo-1512436991641-6745cdb1723f">
                                <h4>Fashion Wear</h4>
                                <p>$65</p>
                            </div>
                            <div class="product">
                                <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e">
                                <h4>Headphones</h4>
                                <p>$99</p>
                            </div>
                            <div class="product">
                                <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c">
                                <h4>Healthy Food</h4>
                                <p>$19</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="person">
                    <div class="head"></div>
                    <div class="body"><div class="arm"></div></div>
                    <div class="legs"><div class="leg"></div><div class="leg"></div></div>
                </div>
            </div>
        </div>
    </section>

    <!-- STATS -->
    <section class="stats">
        <div class="stat-card"><h2>50K+</h2><p>Products available across multiple categories worldwide.</p></div>
        <div class="stat-card"><h2>24/7</h2><p>Customer support available day and night for assistance.</p></div>
        <div class="stat-card"><h2>99%</h2><p>Secure and trusted checkout experience for all customers.</p></div>
        <div class="stat-card"><h2>120+</h2><p>Countries connected through our growing shopping platform.</p></div>
    </section>

    <!-- FEATURES -->
    <section class="features-section">
        <h2 class="section-title">Why Choose ShopWithUs?</h2>
        <div class="moving-track">
            <div class="feature-box"><h3>⚡ Fast Delivery</h3><p>Receive your products quickly and safely anywhere worldwide.</p></div>
            <div class="feature-box"><h3>🔒 Secure Payments</h3><p>Advanced and trusted transaction systems for every purchase.</p></div>
            <div class="feature-box"><h3>🌍 Worldwide Access</h3><p>Shop globally from anywhere with ease and flexibility.</p></div>
            <div class="feature-box"><h3>📞 24/7 Support</h3><p>Friendly customer service available anytime you need help.</p></div>
            <div class="feature-box"><h3>🛒 Trending Products</h3><p>Explore electronics, fashion, food, gadgets and much more.</p></div>
            <div class="feature-box"><h3>⚡ Fast Delivery</h3><p>Receive your products quickly and safely anywhere worldwide.</p></div>
            <div class="feature-box"><h3>🔒 Secure Payments</h3><p>Advanced and trusted transaction systems for every purchase.</p></div>
            <div class="feature-box"><h3>🌍 Worldwide Access</h3><p>Shop globally from anywhere with ease and flexibility.</p></div>
        </div>
    </section>

    <!-- DARK SHOWCASE -->
    <section class="dark-section">
        <h2>Experience the future of online shopping</h2>
        <div class="dark-grid">
            <div class="dark-card">
                <img src="https://images.unsplash.com/photo-1523381210434-271e8be1f52b">
                <div class="dark-content"><h3>Fashion & Lifestyle</h3><p>Explore premium clothing, sneakers, accessories, and trending styles for modern living.</p></div>
            </div>
            <div class="dark-card">
                <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9">
                <div class="dark-content"><h3>Smart Electronics</h3><p>Discover high-quality gadgets, smartphones, headphones, and modern technology products.</p></div>
            </div>
            <div class="dark-card">
                <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c">
                <div class="dark-content"><h3>Healthy Food & More</h3><p>Order delicious meals, healthy food, groceries, and lifestyle essentials easily.</p></div>
            </div>
        </div>
    </section>

    <!-- FREE TRIAL -->
    <section class="trial-section" id="trial">
        <h2>Join thousands shopping with us</h2>
        <p>Enter your email and start your free shopping journey today.</p>
        <div class="trial-box">
            <input type="email" id="trialEmail" placeholder="Enter your email address">
            <button onclick="submitTrial()">Start Free Trial</button>
        </div>
        <div id="trialMessage" style="margin-top: 20px;"></div>
    </section>

    <!-- FAQ -->
    <section class="faq-section">
        <div class="faq-title">
            <span>Are you new and wish to get used to our platform before starting your journey with us?</span>
            Here are frequently asked questions to help you understand our services quickly and comfortably.
        </div>
        <div class="faq-item"><div class="faq-question"><span>How do I place an order?</span><span>+</span></div><div class="faq-answer">Register an account, browse products, add items to your cart, and confirm your order securely.</div></div>
        <div class="faq-item"><div class="faq-question"><span>Can I track my orders?</span><span>+</span></div><div class="faq-answer">Yes. Real-time order tracking becomes available immediately after purchase.</div></div>
        <div class="faq-item"><div class="faq-question"><span>Is ShopWithUs available worldwide?</span><span>+</span></div><div class="faq-answer">Yes. Customers can access and order products internationally.</div></div>
        <div class="faq-item"><div class="faq-question"><span>What payment methods are supported?</span><span>+</span></div><div class="faq-answer">We support secure card payments, mobile payments, and multiple online transaction methods.</div></div>
    </section>

    <!-- CONTACT -->
    <section class="contact">
        <h2>Contact Services</h2>
        <div class="contact-row">
            <div>📧 support@shopwithus.com</div>
            <div>📞 +8615594601190</div>
            <div>🕒 Available 24/7</div>
            <div>🌍 Beijing & International Support</div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer>© 2026 ShopWithUs — Smarter Shopping Starts Here.</footer>

    <!-- TIME -->
    <div class="time-box">
        <div>🌍 GMT: <span id="gmtTime"></span></div>
        <div>🇨🇳 Beijing: <span id="beijingTime"></span></div>
        <div>📅 <span id="date"></span></div>
    </div>

    <script>
        // TIME FUNCTION
        function updateTime() {
            const now = new Date();
            document.getElementById("gmtTime").innerHTML = now.toUTCString().split(" ")[4];
            document.getElementById("beijingTime").innerHTML = now.toLocaleTimeString("en-US", { timeZone: "Asia/Shanghai" });
            document.getElementById("date").innerHTML = now.toDateString();
        }
        setInterval(updateTime, 1000);
        updateTime();

        // FAQ TOGGLE
        const faqItems = document.querySelectorAll(".faq-item");
        faqItems.forEach(item => {
            item.addEventListener("click", () => {
                const answer = item.querySelector(".faq-answer");
                answer.style.display = answer.style.display === "block" ? "none" : "block";
            });
        });

        // TRIAL SUBMISSION
        function submitTrial() {
            const email = document.getElementById('trialEmail').value;
            const messageDiv = document.getElementById('trialMessage');

            if (!email) {
                messageDiv.innerHTML = '<div style="color:red; padding:10px;">Please enter your email</div>';
                return;
            }
            if (!email.match(/^[A-Za-z0-9+_.-]+@(.+)$/)) {
                messageDiv.innerHTML = '<div style="color:red; padding:10px;">Please enter a valid email</div>';
                return;
            }

            messageDiv.innerHTML = '<div style="color:green; padding:10px;">✓ Trial request submitted! Check your email for details.</div>';
            document.getElementById('trialEmail').value = '';
            setTimeout(() => { messageDiv.innerHTML = ''; }, 3000);
        }
    </script>
</body>
</html>