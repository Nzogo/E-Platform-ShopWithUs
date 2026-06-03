<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    // Get featured products (first 12 from database)
    List<Product> featuredProducts = products;
    if (featuredProducts.size() > 12) {
        featuredProducts = products.subList(0, 12);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>ShopWithUs - Shopping Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #0a0a0a;
            transition: background 0.3s, color 0.3s;
        }

        body.light-mode {
            background: #f5f5f5;
        }

        body.light-mode .product-card,
        body.light-mode .category-section,
        body.light-mode .navbar,
        body.light-mode .stat-card,
        body.light-mode .feature-box,
        body.light-mode .dark-card {
            background: white;
        }

        body.light-mode .product-title,
        body.light-mode .category-section h2,
        body.light-mode .stat-card p,
        body.light-mode .feature-box p {
            color: #333;
        }

        body.light-mode .footer {
            background: #1a1a2e;
        }

        /* Theme Toggle */
        .theme-toggle {
            background: rgba(255,255,255,0.1);
            border-radius: 50px;
            padding: 5px;
            display: flex;
            gap: 5px;
        }

        .theme-toggle button {
            background: none;
            border: none;
            padding: 5px 12px;
            border-radius: 20px;
            cursor: pointer;
            color: white;
            font-size: 13px;
            transition: 0.2s;
        }

        body.light-mode .theme-toggle button {
            color: #333;
        }

        .theme-toggle button.active {
            background: #d4af37;
            color: #0a0a0a;
        }

        /* Language Selector */
        .lang-selector {
            display: flex;
            gap: 5px;
            background: rgba(255,255,255,0.1);
            padding: 5px 12px;
            border-radius: 20px;
        }

        .lang-btn {
            background: none;
            border: none;
            font-size: 12px;
            cursor: pointer;
            padding: 3px 10px;
            border-radius: 15px;
            color: white;
            transition: 0.2s;
        }

        body.light-mode .lang-btn {
            color: #333;
        }

        .lang-btn.active {
            background: #d4af37;
            color: #0a0a0a;
        }

        /* Navigation */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            padding: 12px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000;
            background: rgba(10, 10, 10, 0.95);
            backdrop-filter: blur(10px);
            flex-wrap: wrap;
            gap: 15px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 24px;
            font-weight: 800;
            color: #d4af37;
            letter-spacing: 1px;
        }

        .nav-controls {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .auth-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-login, .btn-register {
            padding: 6px 20px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
        }

        .btn-login {
            border: 1px solid #d4af37;
            color: #d4af37;
            background: transparent;
        }

        .btn-register {
            background: #d4af37;
            color: #0a0a0a;
        }

        .btn-login:hover, .btn-register:hover {
            transform: translateY(-2px);
        }

        /* Search Bar */
        .search-container {
            flex: 1;
            max-width: 400px;
            position: relative;
        }

        .search-container input {
            width: 100%;
            padding: 10px 45px 10px 20px;
            border: 1px solid #333;
            border-radius: 30px;
            font-size: 13px;
            background: #1a1a2e;
            color: white;
            outline: none;
        }

        body.light-mode .search-container input {
            background: white;
            border-color: #ddd;
            color: #333;
        }

        .search-container button {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #d4af37;
            cursor: pointer;
        }

        /* Category Bar */
        .category-bar {
            margin-top: 70px;
            background: #1a1a2e;
            padding: 12px 30px;
            display: flex;
            gap: 25px;
            overflow-x: auto;
            white-space: nowrap;
            border-bottom: 1px solid rgba(212, 175, 55, 0.2);
        }

        body.light-mode .category-bar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .category-bar a {
            color: #ccc;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: 0.2s;
            cursor: pointer;
        }

        body.light-mode .category-bar a {
            color: #555;
        }

        .category-bar a:hover {
            color: #d4af37;
        }

        /* Hero Banner */
        .hero-banner {
            height: 450px;
            background-size: cover;
            background-position: center;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(0,0,0,0.6), rgba(0,0,0,0.3));
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
        }

        .hero-content h1 {
            font-size: 52px;
            margin-bottom: 15px;
            font-weight: 800;
        }

        .hero-content p {
            font-size: 18px;
            margin-bottom: 25px;
            opacity: 0.9;
        }

        .hero-btn {
            padding: 12px 35px;
            background: #d4af37;
            color: #0a0a0a;
            border: none;
            border-radius: 40px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: 0.3s;
        }

        .hero-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(212, 175, 55, 0.3);
        }

        /* Products Grid */
        .products-section {
            padding: 40px 30px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .section-header h2 {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(135deg, #d4af37, #f39c12);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .section-header a {
            color: #d4af37;
            text-decoration: none;
            font-size: 14px;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 25px;
        }

        .product-card {
            background: #1a1a2e;
            border-radius: 15px;
            overflow: hidden;
            transition: 0.3s;
            cursor: pointer;
            border: 1px solid rgba(212, 175, 55, 0.2);
        }

        body.light-mode .product-card {
            background: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .product-card:hover {
            transform: translateY(-5px);
            border-color: #d4af37;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .product-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #ff6b6b;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            z-index: 1;
        }

        .product-image {
            width: 100%;
            height: 220px;
            object-fit: cover;
            transition: 0.3s;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-info {
            padding: 15px;
        }

        .product-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 8px;
            color: white;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        body.light-mode .product-title {
            color: #333;
        }

        .product-price {
            font-size: 20px;
            font-weight: 700;
            color: #d4af37;
            margin-bottom: 5px;
        }

        .product-old-price {
            font-size: 13px;
            color: #888;
            text-decoration: line-through;
            margin-left: 8px;
        }

        .product-rating {
            color: #ffc107;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .add-to-cart-btn {
            width: 100%;
            padding: 10px;
            background: #d4af37;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 8px;
        }

        .add-to-cart-btn:hover {
            background: #f39c12;
            transform: scale(0.98);
        }

        /* Entertainment Section */
        .entertainment-section {
            padding: 60px 30px;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: white;
            margin: 40px 0;
        }

        .entertainment-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .entertainment-header h2 {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .entertainment-header p {
            color: rgba(255,255,255,0.7);
        }

        .anime-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
        }

        .anime-card {
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            overflow: hidden;
            transition: 0.3s;
            cursor: pointer;
            backdrop-filter: blur(10px);
        }

        .anime-card:hover {
            transform: translateY(-5px);
            background: rgba(255,255,255,0.2);
        }

        .anime-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .anime-info {
            padding: 15px;
        }

        .anime-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .anime-rating {
            color: #ffc107;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .anime-year {
            font-size: 12px;
            color: rgba(255,255,255,0.6);
        }

        .watch-now {
            display: inline-block;
            margin-top: 10px;
            padding: 6px 20px;
            background: #d4af37;
            color: #0a0a0a;
            border-radius: 25px;
            font-size: 12px;
            text-decoration: none;
            font-weight: 600;
        }

        /* Stats Section */
        .stats {
            padding: 60px 30px;
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            background: #0a0a0a;
        }

        body.light-mode .stats {
            background: #f5f5f5;
        }

        .stat-card {
            background: #1a1a2e;
            padding: 35px;
            border-radius: 20px;
            text-align: center;
            transition: 0.3s;
            border: 1px solid rgba(212, 175, 55, 0.2);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #d4af37;
        }

        .stat-card h2 {
            color: #d4af37;
            font-size: 42px;
            margin-bottom: 10px;
        }

        .stat-card p {
            color: #aaa;
            font-size: 14px;
        }

        /* Features Moving Track */
        .features-section {
            padding: 60px 0;
            overflow: hidden;
            background: #0a0a0a;
        }

        body.light-mode .features-section {
            background: white;
        }

        .section-title {
            text-align: center;
            font-size: 36px;
            margin-bottom: 40px;
            font-weight: 700;
            background: linear-gradient(135deg, #d4af37, #f39c12);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .moving-track {
            display: flex;
            gap: 25px;
            width: max-content;
            animation: moveCards 25s linear infinite;
        }

        @keyframes moveCards {
            from { transform: translateX(0); }
            to { transform: translateX(-50%); }
        }

        .feature-box {
            min-width: 280px;
            background: #1a1a2e;
            padding: 30px;
            border-radius: 20px;
            text-align: center;
            border: 1px solid rgba(212, 175, 55, 0.2);
            transition: 0.3s;
        }

        body.light-mode .feature-box {
            background: #f8f9fa;
        }

        .feature-box:hover {
            transform: translateY(-5px);
            background: #d4af37;
            color: #0a0a0a;
        }

        .feature-box h3 {
            font-size: 20px;
            margin-top: 15px;
        }

        /* Dark Showcase */
        .dark-section {
            background: #07131d;
            color: white;
            padding: 60px 30px;
        }

        .dark-section h2 {
            font-size: 36px;
            margin-bottom: 40px;
            text-align: center;
        }

        .dark-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
        }

        .dark-card {
            background: #111c26;
            border-radius: 20px;
            overflow: hidden;
            transition: 0.3s;
            border: 1px solid rgba(212, 175, 55, 0.2);
        }

        .dark-card:hover {
            transform: translateY(-5px);
            border-color: #d4af37;
        }

        .dark-card img {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }

        .dark-content {
            padding: 20px;
        }

        .dark-content h3 {
            font-size: 20px;
            margin-bottom: 10px;
        }

        /* Free Trial */
        .trial-section {
            padding: 60px 30px;
            text-align: center;
            background: #0a0a0a;
        }

        body.light-mode .trial-section {
            background: white;
        }

        .trial-section h2 {
            font-size: 36px;
            font-weight: 800;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #d4af37, #f39c12);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .trial-section p {
            color: #888;
            margin-bottom: 25px;
        }

        .trial-box {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .trial-box input {
            width: 350px;
            padding: 14px 25px;
            border-radius: 50px;
            border: 1px solid #333;
            background: #1a1a2e;
            color: white;
            font-size: 14px;
            outline: none;
        }

        body.light-mode .trial-box input {
            background: white;
            border-color: #ddd;
            color: #333;
        }

        .trial-box button {
            padding: 14px 35px;
            background: #d4af37;
            color: #0a0a0a;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .trial-box button:hover {
            transform: translateY(-2px);
        }

        /* FAQ */
        .faq-section {
            background: #07131d;
            color: white;
            padding: 60px 30px;
        }

        .faq-title {
            text-align: center;
            margin-bottom: 40px;
            font-size: 18px;
            color: #ccc;
        }

        .faq-title span {
            color: #d4af37;
            font-weight: 700;
        }

        .faq-item {
            padding: 20px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            cursor: pointer;
            max-width: 800px;
            margin: 0 auto;
        }

        .faq-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 18px;
            font-weight: 500;
        }

        .faq-answer {
            display: none;
            margin-top: 15px;
            color: #ccc;
            line-height: 1.6;
        }

        /* Contact */
        .contact {
            padding: 60px 30px;
            text-align: center;
            background: #0a0a0a;
        }

        body.light-mode .contact {
            background: white;
        }

        .contact h2 {
            font-size: 36px;
            margin-bottom: 25px;
            background: linear-gradient(135deg, #d4af37, #f39c12);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .contact-row {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
            color: #aaa;
        }

        /* Footer */
        .footer {
            background: #0a0a0a;
            padding: 40px;
            text-align: center;
            border-top: 1px solid rgba(212, 175, 55, 0.2);
        }

        body.light-mode .footer {
            background: #1a1a2e;
        }

        .footer p {
            color: #888;
            font-size: 13px;
        }

        .payment-methods {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            font-size: 24px;
            color: #888;
        }

        /* Time Box */
        .time-box {
            position: fixed;
            right: 20px;
            bottom: 20px;
            background: #1a1a2e;
            color: white;
            padding: 10px 18px;
            border-radius: 15px;
            z-index: 1000;
            font-size: 11px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            border: 1px solid rgba(212, 175, 55, 0.3);
        }

        .time-box span {
            color: #d4af37;
            font-weight: 600;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .product-card, .stat-card, .dark-card, .anime-card {
            animation: fadeInUp 0.5s ease-out forwards;
            opacity: 0;
        }

        .product-card:nth-child(1) { animation-delay: 0.05s; }
        .product-card:nth-child(2) { animation-delay: 0.1s; }
        .product-card:nth-child(3) { animation-delay: 0.15s; }
        .product-card:nth-child(4) { animation-delay: 0.2s; }

        /* Responsive */
        @media (max-width: 992px) {
            .stats {
                grid-template-columns: repeat(2, 1fr);
            }
            .dark-grid {
                grid-template-columns: 1fr;
            }
            .hero-content h1 {
                font-size: 36px;
            }
        }

        @media (max-width: 768px) {
            .navbar {
                flex-direction: column;
                padding: 15px;
            }
            .category-bar {
                margin-top: 120px;
                padding: 10px 15px;
                gap: 15px;
            }
            .hero-banner {
                height: 300px;
                margin-top: 0;
            }
            .hero-content h1 {
                font-size: 24px;
            }
            .hero-content p {
                font-size: 14px;
            }
            .stats {
                grid-template-columns: 1fr;
            }
            .products-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }
            .anime-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .products-section, .entertainment-section, .stats, .dark-section, .trial-section, .faq-section, .contact {
                padding: 30px 15px;
            }
            .product-image {
                height: 160px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="logo">🛍️ ShopWithUs</div>
        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search products...">
            <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
        </div>
        <div class="nav-controls">
            <div class="lang-selector">
                <button class="lang-btn active" onclick="changeLanguage('en')">EN</button>
                <button class="lang-btn" onclick="changeLanguage('fr')">FR</button>
                <button class="lang-btn" onclick="changeLanguage('zh')">中文</button>
                <button class="lang-btn" onclick="changeLanguage('es')">ES</button>
            </div>
            <div class="theme-toggle">
                <button onclick="setTheme('dark')" class="active">🌙</button>
                <button onclick="setTheme('light')">☀️</button>
            </div>
            <div class="auth-buttons">
                <% if (user != null) { %>
                    <a href="user/dashboard.jsp" class="btn-register">Dashboard</a>
                    <a href="login?action=logout" class="btn-login">Logout</a>
                <% } else { %>
                    <a href="user/login.jsp" class="btn-login">Login</a>
                    <a href="user/register.jsp" class="btn-register">Sign Up</a>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Category Bar -->
    <div class="category-bar">
        <a href="#" onclick="filterCategory('all')">All</a>
        <a href="#" onclick="filterCategory('fashion')">Fashion</a>
        <a href="#" onclick="filterCategory('beauty')">Beauty</a>
        <a href="#" onclick="filterCategory('electronics')">Electronics</a>
        <a href="#" onclick="filterCategory('gaming')">Gaming</a>
        <a href="#" onclick="filterCategory('movies')">Movies & Anime</a>
        <a href="#" onclick="filterCategory('home')">Home</a>
        <a href="#" onclick="filterCategory('sports')">Sports</a>
        <a href="#" onclick="filterCategory('summer')">Summer Sale</a>
    </div>

    <!-- Hero Banner -->
    <div class="hero-banner" style="background-image: url('https://images.unsplash.com/photo-1441986300917-64674bd600d8');">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <h1>Summer Collection 2024</h1>
            <p>Up to 50% off on selected items | Free shipping on orders $50+</p>
            <a href="#products" class="hero-btn">Shop Now →</a>
        </div>
    </div>

    <!-- Products Section -->
    <section class="products-section" id="products">
        <div class="section-header">
            <h2>🔥 Featured Products</h2>
            <a href="#" onclick="filterCategory('all')">View All →</a>
        </div>
        <div class="products-grid" id="productsGrid">
            <% if (featuredProducts != null && !featuredProducts.isEmpty()) { %>
                <% for (int i = 0; i < Math.min(featuredProducts.size(), 8); i++) {
                    Product p = featuredProducts.get(i);
                    double displayPrice = p.getDiscountPrice() > 0 ? p.getDiscountPrice() : p.getPrice();
                    boolean hasDiscount = p.getDiscountPrice() > 0;
                %>
                    <div class="product-card" onclick="viewProduct(<%= p.getId() %>)">
                        <% if (hasDiscount) { %>
                            <div class="product-badge">SALE</div>
                        <% } %>
                        <img src="<%= request.getContextPath() %>/<%= p.getImage1() != null ? p.getImage1() : "https://via.placeholder.com/240x220" %>"
                             class="product-image" onerror="this.src='https://via.placeholder.com/240x220'">
                        <div class="product-info">
                            <div class="product-title"><%= p.getName() %></div>
                            <div class="product-price">
                                $<%= String.format("%.2f", displayPrice) %>
                                <% if (hasDiscount) { %>
                                    <span class="product-old-price">$<%= String.format("%.2f", p.getPrice()) %></span>
                                <% } %>
                            </div>
                            <div class="product-rating">★★★★☆ (128)</div>
                            <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(<%= p.getId() %>, '<%= p.getName() %>', <%= displayPrice %>)">Add to Cart</button>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <!-- Sample products if database empty -->
                <div class="product-card" onclick="viewProduct(1)">
                    <div class="product-badge">SALE</div>
                    <img src="https://images.unsplash.com/photo-1515372039744-b8f02a3ae446" class="product-image">
                    <div class="product-info">
                        <div class="product-title">Floral Summer Dress</div>
                        <div class="product-price">$29.99 <span class="product-old-price">$49.99</span></div>
                        <div class="product-rating">★★★★☆ (128)</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(1, 'Floral Summer Dress', 29.99)">Add to Cart</button>
                    </div>
                </div>
                <div class="product-card" onclick="viewProduct(2)">
                    <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff" class="product-image">
                    <div class="product-info">
                        <div class="product-title">Nike Running Shoes</div>
                        <div class="product-price">$89.99</div>
                        <div class="product-rating">★★★★★ (342)</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(2, 'Nike Running Shoes', 89.99)">Add to Cart</button>
                    </div>
                </div>
                <div class="product-card" onclick="viewProduct(3)">
                    <div class="product-badge">HOT</div>
                    <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30" class="product-image">
                    <div class="product-info">
                        <div class="product-title">Smart Watch</div>
                        <div class="product-price">$149.99 <span class="product-old-price">$199.99</span></div>
                        <div class="product-rating">★★★★☆ (567)</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(3, 'Smart Watch', 149.99)">Add to Cart</button>
                    </div>
                </div>
                <div class="product-card" onclick="viewProduct(4)">
                    <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e" class="product-image">
                    <div class="product-info">
                        <div class="product-title">Wireless Headphones</div>
                        <div class="product-price">$99.99 <span class="product-old-price">$149.99</span></div>
                        <div class="product-rating">★★★★☆ (892)</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(4, 'Wireless Headphones', 99.99)">Add to Cart</button>
                    </div>
                </div>
                <div class="product-card" onclick="viewProduct(5)">
                    <img src="https://images.unsplash.com/photo-1584917865442-de89df76afd3" class="product-image">
                    <div class="product-info">
                        <div class="product-title">Designer Handbag</div>
                        <div class="product-price">$69.99 <span class="product-old-price">$89.99</span></div>
                        <div class="product-rating">★★★★☆ (234)</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(5, 'Designer Handbag', 69.99)">Add to Cart</button>
                    </div>
                </div>
                <div class="product-card" onclick="viewProduct(6)">
                    <div class="product-badge">NEW</div>
                    <img src="https://images.unsplash.com/photo-1596462502278-27bfdc403348" class="product-image">
                    <div class="product-info">
                        <div class="product-title">Premium Makeup Kit</div>
                        <div class="product-price">$39.99</div>
                        <div class="product-rating">★★★★☆ (456)</div>
                        <button class="add-to-cart-btn" onclick="event.stopPropagation(); addToCart(6, 'Premium Makeup Kit', 39.99)">Add to Cart</button>
                    </div>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Entertainment Section - Anime & Movies -->
    <section class="entertainment-section">
        <div class="entertainment-header">
            <h2>🎬 Trending Anime & Movies</h2>
            <p>Watch the latest episodes, discover new series, and join the community</p>
        </div>
        <div class="anime-grid">
            <div class="anime-card">
                <img src="https://images.unsplash.com/photo-1578632767115-351597cf2477" class="anime-image">
                <div class="anime-info">
                    <div class="anime-title">My Hero Academia S7</div>
                    <div class="anime-rating">★★★★★ (12.5k)</div>
                    <div class="anime-year">2024 • Action</div>
                    <a href="#" class="watch-now">Watch Now →</a>
                </div>
            </div>
            <div class="anime-card">
                <img src="https://images.unsplash.com/photo-1541562232579-426a2b9ad194" class="anime-image">
                <div class="anime-info">
                    <div class="anime-title">Demon Slayer</div>
                    <div class="anime-rating">★★★★★ (18.2k)</div>
                    <div class="anime-year">2024 • Fantasy</div>
                    <a href="#" class="watch-now">Watch Now →</a>
                </div>
            </div>
            <div class="anime-card">
                <img src="https://images.unsplash.com/photo-1485846234645-a62644f84728" class="anime-image">
                <div class="anime-info">
                    <div class="anime-title">One Piece</div>
                    <div class="anime-rating">★★★★☆ (9.8k)</div>
                    <div class="anime-year">2024 • Adventure</div>
                    <a href="#" class="watch-now">Watch Now →</a>
                </div>
            </div>
            <div class="anime-card">
                <img src="https://images.unsplash.com/photo-1535016120720-40c646be5580" class="anime-image">
                <div class="anime-info">
                    <div class="anime-title">Attack on Titan</div>
                    <div class="anime-rating">★★★★★ (15.4k)</div>
                    <div class="anime-year">2024 • Dark Fantasy</div>
                    <a href="#" class="watch-now">Watch Now →</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats">
        <div class="stat-card">
            <h2>50K+</h2>
            <p>Products available worldwide</p>
        </div>
        <div class="stat-card">
            <h2>24/7</h2>
            <p>Customer support available</p>
        </div>
        <div class="stat-card">
            <h2>99%</h2>
            <p>Secure checkout experience</p>
        </div>
        <div class="stat-card">
            <h2>120+</h2>
            <p>Countries connected</p>
        </div>
    </section>

    <!-- Features Moving Track -->
    <section class="features-section">
        <h2 class="section-title">Why Choose ShopWithUs?</h2>
        <div class="moving-track">
            <div class="feature-box"><h3>⚡ Fast Delivery</h3><p>Quick shipping worldwide</p></div>
            <div class="feature-box"><h3>🔒 Secure Payments</h3><p>100% protected checkout</p></div>
            <div class="feature-box"><h3>🌍 Worldwide Access</h3><p>Shop from anywhere</p></div>
            <div class="feature-box"><h3>📞 24/7 Support</h3><p>Always here to help</p></div>
            <div class="feature-box"><h3>🛒 Trending Products</h3><p>Latest styles and gadgets</p></div>
            <div class="feature-box"><h3>⚡ Fast Delivery</h3><p>Quick shipping worldwide</p></div>
        </div>
    </section>

    <!-- Dark Showcase -->
    <section class="dark-section">
        <h2>Experience the future of online shopping</h2>
        <div class="dark-grid">
            <div class="dark-card">
                <img src="https://images.unsplash.com/photo-1523381210434-271e8be1f52b">
                <div class="dark-content">
                    <h3>Fashion & Lifestyle</h3>
                    <p>Premium clothing, sneakers, accessories</p>
                </div>
            </div>
            <div class="dark-card">
                <img src="https://images.unsplash.com/photo-1511707171634-5f897ff02aa9">
                <div class="dark-content">
                    <h3>Smart Electronics</h3>
                    <p>Gadgets, smartphones, headphones</p>
                </div>
            </div>
            <div class="dark-card">
                <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c">
                <div class="dark-content">
                    <h3>Healthy Food & More</h3>
                    <p>Groceries and lifestyle essentials</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Free Trial -->
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
            <span>❓ Frequently Asked Questions</span>
        </div>
        <div class="faq-item">
            <div class="faq-question"><span>How do I place an order?</span><span>+</span></div>
            <div class="faq-answer">Register an account, browse products, add items to your cart, and confirm your order securely.</div>
        </div>
        <div class="faq-item">
            <div class="faq-question"><span>Can I track my orders?</span><span>+</span></div>
            <div class="faq-answer">Yes. Real-time order tracking becomes available immediately after purchase.</div>
        </div>
        <div class="faq-item">
            <div class="faq-question"><span>Is ShopWithUs available worldwide?</span><span>+</span></div>
            <div class="faq-answer">Yes. Customers can access and order products internationally.</div>
        </div>
        <div class="faq-item">
            <div class="faq-question"><span>What payment methods are supported?</span><span>+</span></div>
            <div class="faq-answer">We support secure card payments, mobile payments, and multiple online transaction methods.</div>
        </div>
    </section>

    <!-- Contact -->
    <section class="contact">
        <h2>Contact Us</h2>
        <div class="contact-row">
            <div>📧 support@shopwithus.com</div>
            <div>📞 +8615594601190</div>
            <div>🕒 Available 24/7</div>
            <div>🌍 Global Support</div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <p>© 2024 ShopWithUs — All rights reserved. Smarter Shopping Starts Here.</p>
        <div class="payment-methods">
            <i class="fab fa-cc-visa"></i>
            <i class="fab fa-cc-mastercard"></i>
            <i class="fab fa-cc-paypal"></i>
            <i class="fab fa-alipay"></i>
            <i class="fab fa-weixin"></i>
        </div>
    </footer>

    <!-- Time Box -->
    <div class="time-box">
        <div>🌍 GMT: <span id="gmtTime"></span></div>
        <div>🇨🇳 Beijing: <span id="beijingTime"></span></div>
        <div>📅 <span id="date"></span></div>
    </div>

    <script>
        // Cart functions
        var cart = JSON.parse(localStorage.getItem('cart')) || [];

        function updateCartCount() {
            var count = 0;
            for (var i = 0; i < cart.length; i++) {
                count += cart[i].quantity;
            }
            var cartCountElements = document.querySelectorAll('.cart-count');
            for (var j = 0; j < cartCountElements.length; j++) {
                cartCountElements[j].innerHTML = count;
            }
            localStorage.setItem('cart', JSON.stringify(cart));
        }

        function addToCart(id, name, price) {
            var existing = null;
            for (var i = 0; i < cart.length; i++) {
                if (cart[i].id === id) {
                    existing = cart[i];
                    break;
                }
            }
            if (existing) {
                existing.quantity++;
            } else {
                cart.push({ id: id, name: name, price: price, quantity: 1 });
            }
            updateCartCount();
            showNotification(name + ' added to cart!');
        }

        function viewProduct(id) {
            window.location.href = 'user/product.jsp?id=' + id;
        }

        function filterCategory(category) {
            window.location.href = 'user/dashboard.jsp?category=' + category;
        }

        function searchProducts() {
            var term = document.getElementById('searchInput').value;
            if (term) {
                window.location.href = 'user/dashboard.jsp?search=' + encodeURIComponent(term);
            }
        }

        function showNotification(message) {
            var notification = document.createElement('div');
            notification.style.cssText = 'position: fixed; bottom: 20px; right: 20px; background: #d4af37; color: #0a0a0a; padding: 10px 20px; border-radius: 10px; z-index: 2000; font-size: 14px; font-weight: 500; animation: slideIn 0.3s ease;';
            notification.innerHTML = message;
            document.body.appendChild(notification);
            setTimeout(function() { notification.remove(); }, 3000);
        }

        // Theme functions
        function setTheme(theme) {
            if (theme === 'light') {
                document.body.classList.add('light-mode');
                localStorage.setItem('theme', 'light');
                var btns = document.querySelectorAll('.theme-toggle button');
                btns[0].classList.remove('active');
                btns[1].classList.add('active');
            } else {
                document.body.classList.remove('light-mode');
                localStorage.setItem('theme', 'dark');
                var btns = document.querySelectorAll('.theme-toggle button');
                btns[0].classList.add('active');
                btns[1].classList.remove('active');
            }
        }

        // Language
        var currentLang = localStorage.getItem('language') || 'en';

        function changeLanguage(lang) {
            currentLang = lang;
            localStorage.setItem('language', lang);
            var btns = document.querySelectorAll('.lang-btn');
            for (var i = 0; i < btns.length; i++) {
                btns[i].classList.remove('active');
            }
            event.target.classList.add('active');
            showNotification('Language changed to ' + lang.toUpperCase());
        }

        // FAQ Toggle
        var faqItems = document.querySelectorAll(".faq-item");
        for (var i = 0; i < faqItems.length; i++) {
            faqItems[i].addEventListener("click", function() {
                var answer = this.querySelector(".faq-answer");
                if (answer.style.display === "block") {
                    answer.style.display = "none";
                } else {
                    answer.style.display = "block";
                }
            });
        }

        // Trial Submission
        function submitTrial() {
            var email = document.getElementById('trialEmail').value;
            var messageDiv = document.getElementById('trialMessage');
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
            setTimeout(function() { messageDiv.innerHTML = ''; }, 3000);
        }

        // Time Update
        function updateTime() {
            var now = new Date();
            document.getElementById("gmtTime").innerHTML = now.toUTCString().split(" ")[4];
            document.getElementById("beijingTime").innerHTML = now.toLocaleTimeString("en-US", { timeZone: "Asia/Shanghai" });
            document.getElementById("date").innerHTML = now.toDateString();
        }

        // Load saved theme
        var savedTheme = localStorage.getItem('theme');
        if (savedTheme === 'light') {
            setTheme('light');
        }

        // Animation style
        var style = document.createElement('style');
        style.textContent = '@keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }';
        document.head.appendChild(style);

        // Search on Enter key
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchProducts();
            }
        });

        // Initialize
        updateCartCount();
        setInterval(updateTime, 1000);
        updateTime();
    </script>
</body>
</html>