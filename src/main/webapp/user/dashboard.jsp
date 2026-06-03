<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="com.ecommerce.dao.SliderDAO" %>
<%@ page import="com.ecommerce.model.SliderImage" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    SliderDAO sliderDAO = new SliderDAO();
    List<SliderImage> sliders = sliderDAO.getAllActiveSliders();

    String displayName = user.getNickname() != null && !user.getNickname().trim().isEmpty()
                        ? user.getNickname()
                        : user.getFullname();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopWithUs - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; }

        .top-bar { background: #0b4f3c; color: white; padding: 6px 0; text-align: center; font-size: 11px; position: fixed; top: 0; width: 100%; z-index: 1001; }

        .navbar { background: white; padding: 8px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.08); position: fixed; top: 28px; width: 100%; z-index: 1000; flex-wrap: wrap; gap: 8px; }
        .logo { font-size: 22px; font-weight: 800; color: #0b4f3c; text-decoration: none; cursor: pointer; }
        .search-container { flex: 1; max-width: 350px; margin: 0 15px; position: relative; }
        .search-container input { width: 100%; padding: 8px 35px 8px 12px; border: 1px solid #ddd; border-radius: 25px; font-size: 13px; outline: none; }
        .search-container button { position: absolute; right: 5px; top: 50%; transform: translateY(-50%); background: none; border: none; padding: 5px 10px; cursor: pointer; color: #0b4f3c; }
        .search-suggestions { position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-radius: 8px; max-height: 200px; overflow-y: auto; display: none; z-index: 1000; }
        .search-suggestion-item { padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
        .search-suggestion-item:hover { background: #f0f2f5; }

        .country-search-container { position: relative; display: flex; align-items: center; gap: 8px; }
        .country-search { padding: 5px 8px; border: 1px solid #ddd; border-radius: 8px; font-size: 12px; background: white; width: 130px; outline: none; }
        .country-search:focus { border-color: #0b4f3c; }
        .selected-country-badge { background: #e8f0fe; padding: 4px 10px; border-radius: 20px; font-size: 11px; display: flex; align-items: center; gap: 4px; }
        .country-dropdown { position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-radius: 8px; max-height: 250px; overflow-y: auto; display: none; z-index: 1000; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .country-dropdown.show { display: block; }
        .country-option { padding: 6px 10px; cursor: pointer; border-bottom: 1px solid #f0f0f0; font-size: 12px; }
        .country-option:hover { background: #f0f2f5; }
        .no-results { padding: 10px; text-align: center; color: #999; font-size: 12px; }

        .currency-selector-container { position: relative; display: inline-block; }
        .currency-selector-btn { padding: 5px 8px; border: 1px solid #ddd; border-radius: 8px; cursor: pointer; font-size: 12px; background: white; width: 90px; display: flex; align-items: center; justify-content: space-between; }
        .currency-dropdown { position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-radius: 8px; max-height: 300px; overflow-y: auto; display: none; z-index: 1000; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 200px; }
        .currency-dropdown.show { display: block; }
        .currency-search-input { width: 100%; padding: 6px 8px; border: none; border-bottom: 1px solid #eee; outline: none; font-size: 12px; }
        .currency-option { padding: 6px 10px; cursor: pointer; border-bottom: 1px solid #f0f0f0; font-size: 12px; display: flex; align-items: center; gap: 6px; }
        .currency-option:hover { background: #f0f2f5; }
        .currency-option.selected { background: #0b4f3c; color: white; }

        .nav-icons { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
        .nav-icons a { color: #333; text-decoration: none; font-size: 16px; position: relative; cursor: pointer; }
        .nav-icons a:hover { color: #0b4f3c; }
        .cart-count { position: absolute; top: -6px; right: -8px; background: #ff6b6b; color: white; font-size: 9px; padding: 2px 4px; border-radius: 50%; }
        .logout-btn { background: #dc2626; color: white !important; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .logout-btn:hover { background: #b91c1c; }
        .calculator-icon { background: #e8f0fe; color: #0b4f3c; padding: 5px 8px; border-radius: 8px; font-size: 14px; cursor: pointer; transition: 0.3s; }
        .calculator-icon:hover { background: #0b4f3c; color: white; }

        .lang-selector { display: flex; gap: 5px; background: #f0f2f5; padding: 3px 8px; border-radius: 20px; }
        .lang-btn { background: none; border: none; font-size: 13px; cursor: pointer; padding: 2px 6px; border-radius: 15px; transition: 0.3s; color: #666; }
        .lang-btn:hover { background: #e0e8f0; }
        .lang-btn.active { background: #0b4f3c; color: white; }

        .category-bar { background: white; padding: 6px 30px; border-bottom: 1px solid #eee; border-top: 1px solid #eee; position: fixed; top: 78px; width: 100%; z-index: 999; overflow-x: auto; white-space: nowrap; }
        .category-bar a { display: inline-block; padding: 4px 16px; color: #666; text-decoration: none; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.3s; border-radius: 20px; }
        .category-bar a:hover { color: #0b4f3c; background: #e8f0fe; }
        .category-bar a.active { background: #0b4f3c; color: white; }

        .container { margin-top: 125px; padding: 20px 30px; }

        .welcome-collapsible {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 16px;
            margin-bottom: 25px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .welcome-header { display: flex; align-items: center; padding: 12px 20px; cursor: pointer; transition: 0.3s; gap: 15px; }
        .welcome-header:hover { background: rgba(255,255,255,0.1); }
        .welcome-icon { width: 40px; height: 40px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .welcome-info { flex: 1; display: flex; flex-direction: column; }
        .welcome-name { font-size: 15px; font-weight: 700; color: white; }
        .welcome-message { font-size: 10px; color: rgba(255,255,255,0.8); }
        .welcome-toggle { color: white; font-size: 14px; transition: transform 0.3s; }
        .welcome-toggle.rotated { transform: rotate(180deg); }
        .welcome-content { max-height: 0; overflow: hidden; transition: max-height 0.4s ease-out; border-top: 1px solid rgba(255,255,255,0.2); }
        .welcome-content.show { max-height: 180px; transition: max-height 0.4s ease-in; }
        .welcome-stats { display: flex; justify-content: space-around; padding: 15px 20px; flex-wrap: wrap; gap: 15px; }
        .stat-item { display: flex; align-items: center; gap: 10px; color: white; }
        .stat-item i { font-size: 22px; opacity: 0.9; }
        .stat-info { display: flex; flex-direction: column; }
        .stat-value { font-size: 18px; font-weight: 800; }
        .stat-label { font-size: 9px; opacity: 0.8; }
        .welcome-code { text-align: center; padding: 8px 20px 15px; font-size: 11px; color: rgba(255,255,255,0.9); border-top: 1px solid rgba(255,255,255,0.1); }

        .admin-dropdown { position: relative; display: inline-block; }
        .admin-icon { font-size: 18px; cursor: pointer; padding: 5px 10px; background: #e8f0fe; border-radius: 8px; color: #0b4f3c; }
        .admin-icon:hover { background: #0b4f3c; color: white; }
        .admin-menu { display: none; position: absolute; right: 0; top: 35px; background: white; min-width: 180px; box-shadow: 0 8px 16px rgba(0,0,0,0.1); border-radius: 10px; z-index: 100; overflow: hidden; }
        .admin-menu.show { display: block; }
        .admin-menu a { display: flex; align-items: center; gap: 10px; padding: 10px 15px; text-decoration: none; color: #333; font-size: 12px; transition: 0.3s; border-bottom: 1px solid #f0f0f0; }
        .admin-menu a:hover { background: #f0f2f5; color: #0b4f3c; }

        .hero-slider-container { position: relative; width: 100%; height: 400px; border-radius: 20px; overflow: hidden; margin-bottom: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .slider-wrapper { position: relative; width: 100%; height: 100%; overflow: hidden; }
        .slider-track { display: flex; width: 100%; height: 100%; transition: transform 0.5s ease-in-out; }
        .slider-slide { min-width: 100%; height: 100%; position: relative; background-size: cover; background-position: center; background-repeat: no-repeat; }
        .slider-slide::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(135deg, rgba(0,0,0,0.4), rgba(0,0,0,0.2)); z-index: 1; }
        .slide-content { position: absolute; bottom: 15%; left: 8%; z-index: 2; color: white; max-width: 450px; animation: fadeInUp 0.8s ease; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        .slide-badge { display: inline-block; background: #ff6b6b; color: white; padding: 4px 12px; border-radius: 25px; font-size: 11px; font-weight: 600; margin-bottom: 10px; }
        .slide-title { font-size: 36px; font-weight: 800; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .slide-description { font-size: 13px; margin-bottom: 15px; opacity: 0.95; line-height: 1.5; }
        .slide-btn { background: #0b4f3c; color: white; padding: 8px 24px; border-radius: 30px; text-decoration: none; font-weight: 600; transition: 0.3s; border: none; cursor: pointer; font-size: 13px; }
        .slide-btn:hover { background: #0a3d2e; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.3); }
        .slider-arrow { position: absolute; top: 50%; transform: translateY(-50%); background: rgba(255,255,255,0.3); backdrop-filter: blur(5px); border: none; width: 36px; height: 36px; border-radius: 50%; cursor: pointer; z-index: 10; transition: 0.3s; color: white; font-size: 14px; }
        .slider-arrow:hover { background: rgba(255,255,255,0.5); transform: translateY(-50%) scale(1.1); }
        .prev { left: 15px; } .next { right: 15px; }
        .slider-dots { position: absolute; bottom: 15px; left: 50%; transform: translateX(-50%); display: flex; gap: 8px; z-index: 10; }
        .dot { width: 8px; height: 8px; border-radius: 50%; background: rgba(255,255,255,0.5); cursor: pointer; transition: 0.3s; }
        .dot.active { background: white; width: 20px; border-radius: 10px; }
        .slider-pause { position: absolute; bottom: 15px; right: 15px; background: rgba(0,0,0,0.5); border: none; width: 28px; height: 28px; border-radius: 50%; cursor: pointer; z-index: 10; color: white; font-size: 12px; }

        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; flex-wrap: wrap; gap: 10px; }
        .section-header h3 { font-size: 18px; color: #333; }
        .timer { background: #ff6b6b; color: white; padding: 4px 15px; border-radius: 25px; font-size: 12px; font-weight: 600; }

        .pagination { display: flex; justify-content: center; gap: 6px; margin: 25px 0; flex-wrap: wrap; }
        .pagination a, .pagination span { padding: 6px 12px; border: 1px solid #ddd; border-radius: 6px; text-decoration: none; color: #333; cursor: pointer; transition: 0.3s; font-size: 13px; }
        .pagination a:hover, .pagination .active { background: #0b4f3c; color: white; border-color: #0b4f3c; }

        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .product-card { background: white; border-radius: 12px; overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; position: relative; }
        .product-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .product-badge { position: absolute; top: 8px; left: 8px; background: #ff6b6b; color: white; padding: 2px 8px; border-radius: 15px; font-size: 10px; font-weight: 600; z-index: 1; }
        .product-image { width: 100%; height: 180px; object-fit: cover; cursor: pointer; }
        .product-info { padding: 12px; }
        .product-title { font-size: 14px; font-weight: 600; margin-bottom: 4px; color: #333; cursor: pointer; }
        .product-title:hover { color: #0b4f3c; }
        .product-category { font-size: 10px; color: #999; margin-bottom: 6px; }
        .product-price { display: flex; gap: 8px; align-items: center; margin-bottom: 6px; }
        .current-price { font-size: 16px; font-weight: 700; color: #0b4f3c; }
        .old-price { font-size: 12px; color: #999; text-decoration: line-through; }
        .product-rating { font-size: 11px; color: #ffc107; margin-bottom: 8px; }
        .product-actions { display: flex; gap: 6px; margin-top: 8px; flex-wrap: wrap; }
        .action-icon { flex: 1; padding: 6px; border: none; border-radius: 6px; cursor: pointer; font-size: 11px; font-weight: 500; transition: 0.3s; display: flex; align-items: center; justify-content: center; gap: 4px; min-width: 55px; }
        .buy-now { background: #0b4f3c; color: white; }
        .cart-icon { background: #e0e8f0; color: #333; }
        .wishlist-icon { background: #fff0f0; color: #dc2626; }
        .message-icon { background: #e8f0fe; color: #2563eb; }
        .shop-icon { background: #fef3c7; color: #d97706; }

        .features-section { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin: 30px 0; }
        .feature-item { background: white; padding: 15px; border-radius: 10px; text-align: center; }
        .feature-icon { font-size: 28px; margin-bottom: 8px; }
        .feature-title { font-weight: 600; font-size: 13px; margin-bottom: 3px; }
        .feature-desc { font-size: 10px; color: #666; }

        .footer { background: #1a1a2e; color: white; padding: 30px; margin-top: 30px; }
        .footer-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; max-width: 1200px; margin: 0 auto; }
        .footer-section h4 { margin-bottom: 12px; font-size: 14px; }
        .footer-section a { display: block; color: #aaa; text-decoration: none; font-size: 11px; margin-bottom: 6px; cursor: pointer; }
        .footer-section a:hover { color: white; }
        .payment-methods { text-align: center; margin: 15px 0; font-size: 20px; }
        .copyright { text-align: center; padding-top: 20px; margin-top: 20px; border-top: 1px solid #333; font-size: 11px; color: #aaa; }

        .modal, .converter-modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 2000; justify-content: center; align-items: center; }
        .modal.active, .converter-modal.active { display: flex; }
        .modal-content { background: white; border-radius: 16px; max-width: 800px; width: 90%; max-height: 85vh; overflow-y: auto; position: relative; }
        .modal-close, .converter-close { position: absolute; top: 12px; right: 18px; font-size: 24px; cursor: pointer; color: #999; z-index: 10; }
        .product-detail { display: flex; flex-wrap: wrap; }
        .product-detail-image { flex: 1; min-width: 200px; background: #f8f9fa; padding: 20px; }
        .product-detail-image img { width: 100%; border-radius: 12px; }
        .product-detail-info { flex: 1; padding: 20px; }
        .product-detail-title { font-size: 22px; font-weight: 700; margin-bottom: 8px; }
        .product-detail-price { font-size: 24px; font-weight: 700; color: #0b4f3c; margin-bottom: 8px; }
        .detail-quantity { display: flex; align-items: center; gap: 10px; margin: 15px 0; }
        .detail-quantity-btn { width: 32px; height: 32px; border: 1px solid #ddd; background: white; border-radius: 6px; cursor: pointer; font-size: 16px; }
        .detail-quantity-input { width: 50px; text-align: center; border: 1px solid #ddd; border-radius: 6px; padding: 6px; }
        .detail-add-to-cart { background: #0b4f3c; color: white; border: none; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; width: 100%; }

        .converter-card { background: white; border-radius: 16px; width: 420px; max-width: 90%; padding: 20px; }
        .converter-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .converter-row { display: flex; gap: 12px; align-items: center; margin-bottom: 12px; flex-wrap: wrap; }
        .converter-input-group { flex: 1; min-width: 100px; }
        .converter-input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; }
        .convert-result { background: #f0f2f5; padding: 12px; border-radius: 8px; text-align: center; font-size: 14px; font-weight: 600; color: #0b4f3c; margin-top: 12px; }

        @media (max-width: 768px) {
            .navbar { padding: 8px 15px; top: 26px; }
            .category-bar { top: 74px; padding: 5px 15px; }
            .container { margin-top: 120px; padding: 15px; }
            .hero-slider-container { height: 280px; }
            .slide-title { font-size: 22px; }
            .slide-description { font-size: 10px; }
            .slide-content { bottom: 10%; left: 5%; }
            .features-section { grid-template-columns: repeat(2, 1fr); }
            .footer-grid { grid-template-columns: 1fr; text-align: center; }
        }
    </style>
</head>
<body>
    <div class="top-bar" id="topBarText">🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support | Secure Payments</div>

    <div class="navbar">
        <div class="logo" id="logoText" onclick="resetFilters()">🛍️ ShopWithUs!</div>

        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search products..." onkeyup="searchSuggestions()">
            <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
            <div id="searchSuggestions" class="search-suggestions"></div>
        </div>

        <div class="nav-icons">
            <div class="lang-selector">
                <button class="lang-btn" onclick="changeLanguage('en')">EN</button>
                <button class="lang-btn" onclick="changeLanguage('fr')">FR</button>
                <button class="lang-btn" onclick="changeLanguage('zh')">中文</button>
                <button class="lang-btn" onclick="changeLanguage('es')">ES</button>
                <button class="lang-btn" onclick="changeLanguage('ar')">عربي</button>
            </div>

            <div class="country-search-container">
                <input type="text" id="countrySearch" class="country-search" placeholder="🔍 Search country..."
                       onkeyup="filterCountries()" onfocus="showCountryDropdown()" autocomplete="off">
                <span id="selectedCountryDisplay" class="selected-country-badge" style="display: none;">
                    <span id="selectedCountryFlag"></span>
                    <span id="selectedCountryName"></span>
                </span>
                <div id="countryDropdown" class="country-dropdown"></div>
            </div>

            <div class="currency-selector-container" id="currencySelectorContainer">
                <div class="currency-selector-btn" onclick="toggleCurrencyDropdown()">
                    <span id="selectedCurrencyDisplay">🇨🇲 XAF</span>
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div id="currencyDropdownList" class="currency-dropdown">
                    <input type="text" id="currencySearchInput" class="currency-search-input" placeholder="🔍 Search currency..." onkeyup="filterCurrencyOptions()">
                    <div id="currencyOptionsList"></div>
                </div>
            </div>

            <i class="fas fa-calculator calculator-icon" onclick="openConverterModal()" title="Currency Converter"></i>
            <a href="${pageContext.request.contextPath}/user/wishlist.jsp"><i class="far fa-heart"></i> <span id="wishlistCount">0</span></a>
            <a href="${pageContext.request.contextPath}/user/cart.jsp" style="position: relative;">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count" id="cartCount">0</span>
            </a>

            <% if (user != null && "admin".equals(user.getRole())) { %>
                <div class="admin-dropdown">
                    <i class="fas fa-user-shield admin-icon" onclick="toggleAdminMenu()"></i>
                    <div class="admin-menu" id="adminMenu">
                        <a href="${pageContext.request.contextPath}/admin/manage-products.jsp"><i class="fas fa-box"></i> Products</a>
                        <a href="${pageContext.request.contextPath}/admin/manage-sliders.jsp"><i class="fas fa-images"></i> Sliders</a>
                    </div>
                </div>
            <% } %>

            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn" id="logoutText"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <div class="category-bar" id="categoryBar">
        <a href="#" onclick="filterByCategory('all', this)" class="active" id="catAllText">All</a>
        <a href="#" onclick="filterByCategory('women', this)" id="catWomenText">Women</a>
        <a href="#" onclick="filterByCategory('men', this)" id="catMenText">Men</a>
        <a href="#" onclick="filterByCategory('shoes', this)" id="catShoesText">Shoes</a>
        <a href="#" onclick="filterByCategory('bags', this)" id="catBagsText">Bags</a>
        <a href="#" onclick="filterByCategory('beauty', this)" id="catBeautyText">Beauty</a>
        <a href="#" onclick="filterByCategory('electronics', this)" id="catElectronicsText">Electronics</a>
        <a href="#" onclick="filterByCategory('home', this)" id="catHomeText">Home</a>
        <a href="#" onclick="filterByCategory('kids', this)" id="catKidsText">Kids</a>
        <a href="#" onclick="filterByCategory('sports', this)" id="catSportsText">Sports</a>
    </div>

    <div class="container">
        <div class="welcome-collapsible">
            <div class="welcome-header" onclick="toggleWelcome()">
                <div class="welcome-icon"><i class="fas fa-user-astronaut"></i></div>
                <div class="welcome-info">
                    <span class="welcome-name" id="welcomeNameText">Welcome back, @<%= displayName %>! 👋</span>
                    <span class="welcome-message" id="welcomeMessageText">Discover amazing deals and exclusive offers just for you</span>
                </div>
                <div class="welcome-toggle"><i class="fas fa-chevron-down" id="welcomeToggleIcon"></i></div>
            </div>
            <div class="welcome-content" id="welcomeContent">
                <div class="welcome-stats">
                    <div class="stat-item"><i class="fas fa-shopping-cart"></i><div class="stat-info"><span class="stat-value" id="cartItemCount">0</span><span class="stat-label" id="cartItemsText">Cart Items</span></div></div>
                    <div class="stat-item"><i class="fas fa-heart"></i><div class="stat-info"><span class="stat-value" id="wishlistItemCount">0</span><span class="stat-label" id="wishlistText">Wishlist</span></div></div>
                    <div class="stat-item"><i class="fas fa-box"></i><div class="stat-info"><span class="stat-value">0</span><span class="stat-label" id="ordersText">Orders</span></div></div>
                    <div class="stat-item"><i class="fas fa-tag"></i><div class="stat-info"><span class="stat-value">30%</span><span class="stat-label" id="firstOrderText">First Order</span></div></div>
                </div>
                <div class="welcome-code"><span id="useCodeText">Use code:</span> <strong>WELCOME30</strong> <span id="forDiscountText">for 30% off</span></div>
            </div>
        </div>

        <div class="hero-slider-container" id="heroSlider">
            <div class="slider-wrapper">
                <div class="slider-track" id="sliderTrack">
                    <% if (sliders != null && !sliders.isEmpty()) { %>
                        <% for (SliderImage slider : sliders) { %>
                            <div class="slider-slide" style="background-image: linear-gradient(135deg, rgba(0,0,0,0.4), rgba(0,0,0,0.2)), url('<%= request.getContextPath() %>/<%= slider.getImageUrl() %>');">
                                <div class="slide-content">
                                    <% if (slider.getDiscountPercent() > 0) { %>
                                        <div class="slide-badge"><%= slider.getDiscountPercent() %>% OFF</div>
                                    <% } %>
                                    <h2 class="slide-title"><%= slider.getTitle() %></h2>
                                    <p class="slide-description"><%= slider.getDescription() %></p>
                                    <button class="slide-btn" onclick="filterByCategory('<%= slider.getCategory() %>', this)"><%= slider.getButtonText() %> →</button>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="slider-slide" style="background-image: linear-gradient(135deg, rgba(0,0,0,0.4), rgba(0,0,0,0.2)), url('<%= request.getContextPath() %>/uploads/sliders/placeholder.jpg');">
                            <div class="slide-content">
                                <div class="slide-badge">Welcome</div>
                                <h2 class="slide-title">No Slides Yet</h2>
                                <p class="slide-description">Admin can add slides from the admin panel</p>
                                <button class="slide-btn" onclick="location.href='${pageContext.request.contextPath}/admin/manage-sliders.jsp'">Add Slides →</button>
                            </div>
                        </div>
                    <% } %>
                </div>
                <button class="slider-arrow prev" id="prevSlide"><i class="fas fa-chevron-left"></i></button>
                <button class="slider-arrow next" id="nextSlide"><i class="fas fa-chevron-right"></i></button>
                <div class="slider-dots" id="sliderDots"></div>
                <button class="slider-pause" id="sliderPause"><i class="fas fa-pause"></i></button>
            </div>
        </div>

        <div class="section-header">
            <h3 id="flashSaleText">⚡ Flash Sale <span style="font-size:11px; color:#666;">Ends soon!</span></h3>
            <div class="timer" id="timer">Ending in: 23:59:59</div>
        </div>

        <div class="products-grid" id="productsGrid"></div>
        <div class="pagination" id="pagination"></div>
    </div>

    <div class="features-section">
        <div class="feature-item"><div class="feature-icon">🚚</div><div class="feature-title" id="freeShippingText">Free Shipping</div><div class="feature-desc" id="freeShippingDescText">On orders $50+</div></div>
        <div class="feature-item"><div class="feature-icon">🔒</div><div class="feature-title" id="securePaymentText">Secure Payment</div><div class="feature-desc" id="securePaymentDescText">100% secure checkout</div></div>
        <div class="feature-item"><div class="feature-icon">↩️</div><div class="feature-title" id="easyReturnsText">Easy Returns</div><div class="feature-desc" id="easyReturnsDescText">30 days return policy</div></div>
        <div class="feature-item"><div class="feature-icon">💬</div><div class="feature-title" id="supportText">24/7 Support</div><div class="feature-desc" id="supportDescText">Live chat available</div></div>
    </div>

    <div class="footer">
        <div class="footer-grid">
            <div class="footer-section"><h4 id="shopWithUsText">ShopWithUs</h4><a onclick="showNotification('About Us coming soon!', 'info')" id="aboutUsText">About Us</a><a onclick="showNotification('Careers coming soon!', 'info')" id="careersText">Careers</a><a onclick="showNotification('Press coming soon!', 'info')" id="pressText">Press</a></div>
            <div class="footer-section"><h4 id="customerServiceText">Customer Service</h4><a onclick="showNotification('Contact Us coming soon!', 'info')" id="contactUsText">Contact Us</a><a onclick="showNotification('Shipping Info coming soon!', 'info')" id="shippingInfoText">Shipping Info</a><a onclick="showNotification('Returns & Refunds coming soon!', 'info')" id="returnsText">Returns & Refunds</a></div>
            <div class="footer-section"><h4 id="myAccountText">My Account</h4><a href="${pageContext.request.contextPath}/user/wishlist.jsp" id="myWishlistText">My Wishlist</a><a href="${pageContext.request.contextPath}/user/cart.jsp" id="myCartText">My Cart</a><a onclick="showNotification('My Orders coming soon!', 'info')" id="myOrdersText">My Orders</a></div>
            <div class="footer-section"><h4 id="followUsText">Follow Us</h4><a href="#"><i class="fab fa-facebook"></i> Facebook</a><a href="#"><i class="fab fa-instagram"></i> Instagram</a><a href="#"><i class="fab fa-twitter"></i> Twitter</a></div>
        </div>
        <div class="payment-methods"><i class="fab fa-cc-visa"></i> <i class="fab fa-cc-mastercard"></i> <i class="fab fa-cc-paypal"></i> <i class="fab fa-alipay"></i> <i class="fab fa-weixin"></i></div>
        <div class="copyright" id="copyrightText">© 2024 ShopWithUs — All rights reserved. Smarter Shopping Starts Here.</div>
    </div>

    <div id="productModal" class="modal"><div class="modal-content"><span class="modal-close" onclick="closeProductModal()">&times;</span><div id="modalContent"></div></div></div>
    <div id="converterModal" class="converter-modal"><div class="converter-card"><div class="converter-header"><h3 id="currencyConverterText"><i class="fas fa-calculator"></i> Currency Converter</h3><span class="converter-close" onclick="closeConverterModal()">&times;</span></div>
        <div class="converter-row"><div class="converter-input-group"><label id="amountText">Amount</label><input type="number" id="convertAmount" class="converter-input" value="1" step="0.01" oninput="convertCurrencyModal()"></div></div>
        <div class="converter-row"><div class="converter-select-container" id="converterFromContainer"><div class="converter-select-btn" onclick="toggleConverterDropdown('from')"><span id="converterFromDisplay">🇺🇸 USD</span><i class="fas fa-chevron-down"></i></div><div id="converterFromDropdown" class="converter-select-dropdown"><input type="text" id="converterFromSearch" class="converter-search-input" placeholder="🔍 Search currency..." onkeyup="filterConverterOptions('from')"><div id="converterFromOptions"></div></div></div>
        <i class="fas fa-exchange-alt swap-icon" onclick="swapCurrenciesModal()"></i>
        <div class="converter-select-container" id="converterToContainer"><div class="converter-select-btn" onclick="toggleConverterDropdown('to')"><span id="converterToDisplay">🇨🇲 XAF</span><i class="fas fa-chevron-down"></i></div><div id="converterToDropdown" class="converter-select-dropdown"><input type="text" id="converterToSearch" class="converter-search-input" placeholder="🔍 Search currency..." onkeyup="filterConverterOptions('to')"><div id="converterToOptions"></div></div></div></div>
        <div class="convert-result" id="convertResult">1 USD = 0 XAF</div><div class="live-rate" id="liveRate">Live exchange rates from API</div>
    </div></div>

    <script>
        // ============================================
        // TRANSLATIONS DATABASE
        // ============================================
        var translations = {
            en: {
                topBar: "🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support | Secure Payments",
                logo: "🛍️ ShopWithUs!",
                logout: "Logout",
                welcomeName: "Welcome back, @<%= displayName %>! 👋",
                welcomeMessage: "Discover amazing deals and exclusive offers just for you",
                cartItems: "Cart Items",
                wishlist: "Wishlist",
                orders: "Orders",
                firstOrder: "First Order",
                useCode: "Use code:",
                forDiscount: "for 30% off",
                flashSale: "⚡ Flash Sale Ends soon!",
                freeShipping: "Free Shipping",
                freeShippingDesc: "On orders $50+",
                securePayment: "Secure Payment",
                securePaymentDesc: "100% secure checkout",
                easyReturns: "Easy Returns",
                easyReturnsDesc: "30 days return policy",
                support: "24/7 Support",
                supportDesc: "Live chat available",
                currencyConverter: "Currency Converter",
                amount: "Amount",
                catAll: "All",
                catWomen: "Women",
                catMen: "Men",
                catShoes: "Shoes",
                catBags: "Bags",
                catBeauty: "Beauty",
                catElectronics: "Electronics",
                catHome: "Home",
                catKids: "Kids",
                catSports: "Sports",
                shopWithUs: "ShopWithUs",
                aboutUs: "About Us",
                careers: "Careers",
                press: "Press",
                customerService: "Customer Service",
                contactUs: "Contact Us",
                shippingInfo: "Shipping Info",
                returns: "Returns & Refunds",
                myAccount: "My Account",
                myWishlist: "My Wishlist",
                myCart: "My Cart",
                myOrders: "My Orders",
                followUs: "Follow Us",
                copyright: "© 2024 ShopWithUs — All rights reserved. Smarter Shopping Starts Here."
            },
            fr: {
                topBar: "🚚 Livraison gratuite sur commandes $50+ | Retours gratuits | Support 24/7 | Paiements sécurisés",
                logo: "🛍️ ShopWithUs!",
                logout: "Déconnexion",
                welcomeName: "Bon retour, @<%= displayName %>! 👋",
                welcomeMessage: "Découvrez des offres exceptionnelles rien que pour vous",
                cartItems: "Articles du panier",
                wishlist: "Liste de souhaits",
                orders: "Commandes",
                firstOrder: "Première commande",
                useCode: "Utilisez le code:",
                forDiscount: "pour 30% de réduction",
                flashSale: "⚡ Vente Flash bientôt terminée!",
                freeShipping: "Livraison gratuite",
                freeShippingDesc: "Sur commandes $50+",
                securePayment: "Paiement sécurisé",
                securePaymentDesc: "Paiement 100% sécurisé",
                easyReturns: "Retours faciles",
                easyReturnsDesc: "Politique de retour 30 jours",
                support: "Support 24/7",
                supportDesc: "Chat en direct disponible",
                currencyConverter: "Convertisseur de devises",
                amount: "Montant",
                catAll: "Tous",
                catWomen: "Femmes",
                catMen: "Hommes",
                catShoes: "Chaussures",
                catBags: "Sacs",
                catBeauty: "Beauté",
                catElectronics: "Électronique",
                catHome: "Maison",
                catKids: "Enfants",
                catSports: "Sports",
                shopWithUs: "ShopWithUs",
                aboutUs: "À propos",
                careers: "Carrières",
                press: "Presse",
                customerService: "Service client",
                contactUs: "Contactez-nous",
                shippingInfo: "Infos livraison",
                returns: "Retours",
                myAccount: "Mon compte",
                myWishlist: "Ma liste",
                myCart: "Mon panier",
                myOrders: "Mes commandes",
                followUs: "Suivez-nous",
                copyright: "© 2024 ShopWithUs — Tous droits réservés."
            },
            zh: {
                topBar: "🚚 满$50免运费 | 免费退货 | 24/7客服 | 安全支付",
                logo: "🛍️ ShopWithUs!",
                logout: "退出登录",
                welcomeName: "欢迎回来, @<%= displayName %>! 👋",
                welcomeMessage: "发现专属于您的超值优惠",
                cartItems: "购物车",
                wishlist: "收藏夹",
                orders: "订单",
                firstOrder: "首单优惠",
                useCode: "使用代码:",
                forDiscount: "享30%折扣",
                flashSale: "⚡ 限时抢购即将结束!",
                freeShipping: "免费配送",
                freeShippingDesc: "订单满$50",
                securePayment: "安全支付",
                securePaymentDesc: "100%安全结账",
                easyReturns: "轻松退货",
                easyReturnsDesc: "30天退货政策",
                support: "24/7支持",
                supportDesc: "在线聊天",
                currencyConverter: "货币转换器",
                amount: "金额",
                catAll: "全部",
                catWomen: "女装",
                catMen: "男装",
                catShoes: "鞋类",
                catBags: "包包",
                catBeauty: "美妆",
                catElectronics: "电子",
                catHome: "家居",
                catKids: "儿童",
                catSports: "运动",
                shopWithUs: "关于我们",
                aboutUs: "公司简介",
                careers: "招聘信息",
                press: "新闻中心",
                customerService: "客服中心",
                contactUs: "联系我们",
                shippingInfo: "配送信息",
                returns: "退换货政策",
                myAccount: "我的账户",
                myWishlist: "我的收藏",
                myCart: "购物车",
                myOrders: "我的订单",
                followUs: "关注我们",
                copyright: "© 2024 ShopWithUs — 保留所有权利。"
            },
            es: {
                topBar: "🚚 Envío gratis en pedidos $50+ | Devoluciones gratis | Soporte 24/7 | Pagos seguros",
                logo: "🛍️ ShopWithUs!",
                logout: "Cerrar sesión",
                welcomeName: "¡Bienvenido de nuevo, @<%= displayName %>! 👋",
                welcomeMessage: "Descubre ofertas increíbles solo para ti",
                cartItems: "Artículos del carrito",
                wishlist: "Lista de deseos",
                orders: "Pedidos",
                firstOrder: "Primer pedido",
                useCode: "Usa el código:",
                forDiscount: "para 30% de descuento",
                flashSale: "⚡ Venta Flash por terminar!",
                freeShipping: "Envío gratis",
                freeShippingDesc: "En pedidos $50+",
                securePayment: "Pago seguro",
                securePaymentDesc: "100% seguro",
                easyReturns: "Devoluciones fáciles",
                easyReturnsDesc: "30 días de garantía",
                support: "Soporte 24/7",
                supportDesc: "Chat en vivo",
                currencyConverter: "Convertidor de moneda",
                amount: "Cantidad",
                catAll: "Todos",
                catWomen: "Mujeres",
                catMen: "Hombres",
                catShoes: "Zapatos",
                catBags: "Bolsos",
                catBeauty: "Belleza",
                catElectronics: "Electrónicos",
                catHome: "Hogar",
                catKids: "Niños",
                catSports: "Deportes",
                shopWithUs: "ShopWithUs",
                aboutUs: "Sobre nosotros",
                careers: "Carreras",
                press: "Prensa",
                customerService: "Servicio al cliente",
                contactUs: "Contáctenos",
                shippingInfo: "Información de envío",
                returns: "Devoluciones",
                myAccount: "Mi cuenta",
                myWishlist: "Mi lista",
                myCart: "Mi carrito",
                myOrders: "Mis pedidos",
                followUs: "Síguenos",
                copyright: "© 2024 ShopWithUs — Todos los derechos reservados."
            },
            ar: {
                topBar: "🚚 شحن مجاني للطلبات التي تزيد عن 50 دولارًا | إرجاع مجاني | دعم 24/7 | مدفوعات آمنة",
                logo: "🛍️ ShopWithUs!",
                logout: "تسجيل الخروج",
                welcomeName: "مرحباً بعودتك, @<%= displayName %>! 👋",
                welcomeMessage: "اكتشف عروضاً مذهلة حصرياً لك",
                cartItems: "عناصر السلة",
                wishlist: "قائمة الرغبات",
                orders: "الطلبات",
                firstOrder: "الطلب الأول",
                useCode: "استخدم الكود:",
                forDiscount: "للحصول على خصم 30%",
                flashSale: "⚡ تنتهي المبيعات السريعة قريباً!",
                freeShipping: "شحن مجاني",
                freeShippingDesc: "للطلبات التي تزيد عن 50 دولارًا",
                securePayment: "دفع آمن",
                securePaymentDesc: "خروج آمن 100%",
                easyReturns: "إرجاع سهل",
                easyReturnsDesc: "سياسة إرجاع 30 يوماً",
                support: "دعم 24/7",
                supportDesc: "دردشة مباشرة",
                currencyConverter: "محول العملات",
                amount: "المبلغ",
                catAll: "الكل",
                catWomen: "نساء",
                catMen: "رجال",
                catShoes: "أحذية",
                catBags: "حقائب",
                catBeauty: "تجميل",
                catElectronics: "إلكترونيات",
                catHome: "منزل",
                catKids: "أطفال",
                catSports: "رياضة",
                shopWithUs: "ShopWithUs",
                aboutUs: "معلومات عنا",
                careers: "وظائف",
                press: "صحافة",
                customerService: "خدمة العملاء",
                contactUs: "اتصل بنا",
                shippingInfo: "معلومات الشحن",
                returns: "الإرجاع",
                myAccount: "حسابي",
                myWishlist: "قائمة رغباتي",
                myCart: "سلتي",
                myOrders: "طلباتي",
                followUs: "تابعنا",
                copyright: "© 2024 ShopWithUs — جميع الحقوق محفوظة."
            }
        };

        var currentLanguage = localStorage.getItem('language') || 'en';

        function changeLanguage(lang) {
            currentLanguage = lang;
            localStorage.setItem('language', currentLanguage);

            document.querySelectorAll('.lang-btn').forEach(btn => {
                btn.classList.remove('active');
                if ((lang === 'en' && btn.textContent === 'EN') ||
                    (lang === 'fr' && btn.textContent === 'FR') ||
                    (lang === 'zh' && btn.textContent === '中文') ||
                    (lang === 'es' && btn.textContent === 'ES') ||
                    (lang === 'ar' && btn.textContent === 'عربي')) {
                    btn.classList.add('active');
                }
            });

            var elements = ['topBarText', 'logoText', 'logoutText', 'welcomeNameText', 'welcomeMessageText',
                'cartItemsText', 'wishlistText', 'ordersText', 'firstOrderText', 'useCodeText', 'forDiscountText',
                'flashSaleText', 'freeShippingText', 'freeShippingDescText', 'securePaymentText', 'securePaymentDescText',
                'easyReturnsText', 'easyReturnsDescText', 'supportText', 'supportDescText', 'currencyConverterText',
                'amountText', 'catAllText', 'catWomenText', 'catMenText', 'catShoesText', 'catBagsText',
                'catBeautyText', 'catElectronicsText', 'catHomeText', 'catKidsText', 'catSportsText',
                'shopWithUsText', 'aboutUsText', 'careersText', 'pressText', 'customerServiceText',
                'contactUsText', 'shippingInfoText', 'returnsText', 'myAccountText', 'myWishlistText',
                'myCartText', 'myOrdersText', 'followUsText', 'copyrightText'];

            for (var i = 0; i < elements.length; i++) {
                var el = document.getElementById(elements[i]);
                if (el && translations[lang] && translations[lang][elements[i].replace('Text', '')]) {
                    el.innerHTML = translations[lang][elements[i].replace('Text', '')];
                }
            }

            showNotification('Language changed to ' + lang.toUpperCase(), 'info');
        }

        // ============================================
        // REST OF JAVASCRIPT FUNCTIONS
        // ============================================
        var countries = [
            { code: "CM", name: "Cameroon", currency: "XAF", flag: "🇨🇲" }, { code: "CN", name: "China", currency: "CNY", flag: "🇨🇳" }, { code: "US", name: "United States", currency: "USD", flag: "🇺🇸" }, { code: "GB", name: "United Kingdom", currency: "GBP", flag: "🇬🇧" }, { code: "FR", name: "France", currency: "EUR", flag: "🇫🇷" }, { code: "DE", name: "Germany", currency: "EUR", flag: "🇩🇪" }, { code: "JP", name: "Japan", currency: "JPY", flag: "🇯🇵" }, { code: "AE", name: "UAE", currency: "AED", flag: "🇦🇪" }, { code: "NG", name: "Nigeria", currency: "NGN", flag: "🇳🇬" }, { code: "IN", name: "India", currency: "INR", flag: "🇮🇳" }, { code: "CA", name: "Canada", currency: "CAD", flag: "🇨🇦" }, { code: "AU", name: "Australia", currency: "AUD", flag: "🇦🇺" }, { code: "ZA", name: "South Africa", currency: "ZAR", flag: "🇿🇦" }, { code: "KE", name: "Kenya", currency: "KES", flag: "🇰🇪" }, { code: "GH", name: "Ghana", currency: "GHS", flag: "🇬🇭" }
        ];

        var allCurrencies = [
            { code: "XAF", name: "CFA Franc (Cameroon)", flag: "🇨🇲" }, { code: "USD", name: "US Dollar", flag: "🇺🇸" }, { code: "CNY", name: "Chinese Yuan", flag: "🇨🇳" }, { code: "EUR", name: "Euro", flag: "🇪🇺" }, { code: "JPY", name: "Japanese Yen", flag: "🇯🇵" }, { code: "AED", name: "UAE Dirham", flag: "🇦🇪" }, { code: "GBP", name: "British Pound", flag: "🇬🇧" }, { code: "NGN", name: "Nigerian Naira", flag: "🇳🇬" }, { code: "INR", name: "Indian Rupee", flag: "🇮🇳" }
        ];

        var exchangeRates = { USD: 1 };
        var currentCurrency = localStorage.getItem('currency') || 'XAF';
        var cart = JSON.parse(localStorage.getItem('cart')) || [];
        var wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
        var currentCategory = 'all';
        var currentSearchTerm = '';
        var currentPage = 1;
        var itemsPerPage = 8;

        var selectedCountryCode = localStorage.getItem('selectedCountryCode') || '';
        var selectedCountryName = localStorage.getItem('selectedCountryName') || '';
        var selectedCountryFlag = localStorage.getItem('selectedCountryFlag') || '';

        var productsData = {
            <% for (Product p : products) { %>
                <%= p.getId() %>: {
                    name: "<%= p.getName() %>",
                    price: <%= p.getPrice() %>,
                    oldPrice: <%= p.getDiscountPrice() > 0 ? p.getDiscountPrice() : "null" %>,
                    rating: 4,
                    reviews: 0,
                    image: "<%= request.getContextPath() %>/<%= p.getImage1() != null ? p.getImage1() : "uploads/products/placeholder.jpg" %>",
                    description: "<%= p.getDescription() != null ? p.getDescription().replace("\"", "\\\"").replace("\n", " ") : "" %>",
                    category: "<%= p.getCategory() != null ? p.getCategory() : "all" %>",
                    stock: <%= p.getStock() %>
                },
            <% } %>
        };

        var currentSlide = 0;
        var slideInterval;
        var isPlaying = true;
        var totalSlides = 0;

        function toggleWelcome() {
            var content = document.getElementById('welcomeContent');
            var icon = document.getElementById('welcomeToggleIcon');
            content.classList.toggle('show');
            if (icon && icon.parentElement) {
                icon.parentElement.classList.toggle('rotated');
            }
        }

        function toggleAdminMenu() {
            var menu = document.getElementById('adminMenu');
            if (menu) {
                menu.classList.toggle('show');
            }
        }

        function toggleCurrencyDropdown() {
            var dropdown = document.getElementById('currencyDropdownList');
            if (dropdown) {
                dropdown.classList.toggle('show');
                if (dropdown.classList.contains('show')) {
                    document.getElementById('currencySearchInput').focus();
                    filterCurrencyOptions();
                }
            }
        }

        function filterCurrencyOptions() {
            var searchTerm = document.getElementById('currencySearchInput').value.toLowerCase();
            var optionsDiv = document.getElementById('currencyOptionsList');
            var filtered = allCurrencies.filter(function(c) {
                return c.code.toLowerCase().includes(searchTerm) || c.name.toLowerCase().includes(searchTerm);
            });
            if (filtered.length === 0) {
                optionsDiv.innerHTML = '<div class="currency-option" style="color:#999;">No currencies found</div>';
            } else {
                var html = '';
                for (var i = 0; i < filtered.length; i++) {
                    var curr = filtered[i];
                    var selectedClass = (curr.code === currentCurrency) ? 'selected' : '';
                    html += '<div class="currency-option ' + selectedClass + '" onclick="selectCurrency(\'' + curr.code + '\', \'' + curr.flag + ' ' + curr.code + '\')">' + curr.flag + ' ' + curr.code + ' - ' + curr.name + '</div>';
                }
                optionsDiv.innerHTML = html;
            }
        }

        function selectCurrency(code, displayText) {
            currentCurrency = code;
            localStorage.setItem('currency', currentCurrency);
            document.getElementById('selectedCurrencyDisplay').innerHTML = displayText;
            document.getElementById('currencyDropdownList').classList.remove('show');
            displayProducts();
            showNotification('Currency changed to ' + code, 'info');
        }

        var converterFromCurrency = 'USD';
        var converterToCurrency = 'XAF';

        function populateConverterOptions() {
            var fromOptionsDiv = document.getElementById('converterFromOptions');
            var toOptionsDiv = document.getElementById('converterToOptions');
            if (!fromOptionsDiv || !toOptionsDiv) return;
            var fromHtml = '';
            var toHtml = '';
            for (var i = 0; i < allCurrencies.length; i++) {
                var curr = allCurrencies[i];
                fromHtml += '<div class="converter-currency-option" onclick="selectConverterCurrency(\'from\', \'' + curr.code + '\', \'' + curr.flag + ' ' + curr.code + '\')">' + curr.flag + ' ' + curr.code + ' - ' + curr.name + '</div>';
                toHtml += '<div class="converter-currency-option" onclick="selectConverterCurrency(\'to\', \'' + curr.code + '\', \'' + curr.flag + ' ' + curr.code + '\')">' + curr.flag + ' ' + curr.code + ' - ' + curr.name + '</div>';
            }
            fromOptionsDiv.innerHTML = fromHtml;
            toOptionsDiv.innerHTML = toHtml;
        }

        function filterConverterOptions(type) {
            var searchTerm = type === 'from' ? document.getElementById('converterFromSearch').value.toLowerCase() : document.getElementById('converterToSearch').value.toLowerCase();
            var optionsDiv = type === 'from' ? document.getElementById('converterFromOptions') : document.getElementById('converterToOptions');
            var filtered = allCurrencies.filter(function(c) {
                return c.code.toLowerCase().includes(searchTerm) || c.name.toLowerCase().includes(searchTerm);
            });
            if (filtered.length === 0) {
                optionsDiv.innerHTML = '<div class="converter-currency-option" style="color:#999;">No currencies found</div>';
            } else {
                var html = '';
                for (var i = 0; i < filtered.length; i++) {
                    var curr = filtered[i];
                    html += '<div class="converter-currency-option" onclick="selectConverterCurrency(\'' + type + '\', \'' + curr.code + '\', \'' + curr.flag + ' ' + curr.code + '\')">' + curr.flag + ' ' + curr.code + ' - ' + curr.name + '</div>';
                }
                optionsDiv.innerHTML = html;
            }
        }

        function toggleConverterDropdown(type) {
            var fromDropdown = document.getElementById('converterFromDropdown');
            var toDropdown = document.getElementById('converterToDropdown');
            if (type === 'from') {
                if (fromDropdown) {
                    fromDropdown.classList.toggle('show');
                    if (toDropdown) toDropdown.classList.remove('show');
                    if (fromDropdown.classList.contains('show')) {
                        document.getElementById('converterFromSearch').focus();
                        filterConverterOptions('from');
                    }
                }
            } else {
                if (toDropdown) {
                    toDropdown.classList.toggle('show');
                    if (fromDropdown) fromDropdown.classList.remove('show');
                    if (toDropdown.classList.contains('show')) {
                        document.getElementById('converterToSearch').focus();
                        filterConverterOptions('to');
                    }
                }
            }
        }

        function selectConverterCurrency(type, code, displayText) {
            if (type === 'from') {
                converterFromCurrency = code;
                document.getElementById('converterFromDisplay').innerHTML = displayText;
                document.getElementById('converterFromDropdown').classList.remove('show');
            } else {
                converterToCurrency = code;
                document.getElementById('converterToDisplay').innerHTML = displayText;
                document.getElementById('converterToDropdown').classList.remove('show');
            }
            convertCurrencyModal();
        }

        function openConverterModal() {
            document.getElementById('converterModal').classList.add('active');
            convertCurrencyModal();
        }

        function closeConverterModal() {
            document.getElementById('converterModal').classList.remove('active');
        }

        function convertCurrencyModal() {
            var amount = parseFloat(document.getElementById('convertAmount').value);
            if (isNaN(amount)) amount = 1;
            var amountInUSD = amount;
            if (converterFromCurrency !== 'USD' && exchangeRates[converterFromCurrency]) {
                amountInUSD = amount / exchangeRates[converterFromCurrency];
            }
            var convertedAmount = amountInUSD;
            if (converterToCurrency !== 'USD' && exchangeRates[converterToCurrency]) {
                convertedAmount = amountInUSD * exchangeRates[converterToCurrency];
            }
            var symbol = getCurrencySymbolForCode(converterToCurrency);
            document.getElementById('convertResult').innerHTML = amount + ' ' + converterFromCurrency + ' = ' + symbol + ' ' + convertedAmount.toFixed(2) + ' ' + converterToCurrency;
            var rate = exchangeRates[converterToCurrency];
            document.getElementById('liveRate').innerHTML = '1 USD = ' + rate.toFixed(4) + ' ' + converterToCurrency + ' (Live Rate)';
        }

        function swapCurrenciesModal() {
            var temp = converterFromCurrency;
            converterFromCurrency = converterToCurrency;
            converterToCurrency = temp;
            var tempDisplay = document.getElementById('converterFromDisplay').innerHTML;
            document.getElementById('converterFromDisplay').innerHTML = document.getElementById('converterToDisplay').innerHTML;
            document.getElementById('converterToDisplay').innerHTML = tempDisplay;
            convertCurrencyModal();
        }

        function getCurrencySymbolForCode(currencyCode) {
            var symbols = { USD:'$', EUR:'€', GBP:'£', JPY:'¥', CNY:'¥', XAF:'FCFA', AED:'د.إ', NGN:'₦', INR:'₹', CAD:'C$', AUD:'A$', ZAR:'R', KES:'KSh', GHS:'GH₵' };
            return symbols[currencyCode] || currencyCode;
        }

        function selectCountry(code, name, currency) {
            var country = countries.find(function(c) { return c.code === code; });
            if (country) {
                selectedCountryCode = code;
                selectedCountryName = name;
                selectedCountryFlag = country.flag;
                localStorage.setItem('selectedCountryCode', selectedCountryCode);
                localStorage.setItem('selectedCountryName', selectedCountryName);
                localStorage.setItem('selectedCountryFlag', selectedCountryFlag);
                updateSelectedCountryDisplay();
            }
            document.getElementById('countrySearch').value = '';
            currentCurrency = currency;
            var foundCurr = allCurrencies.find(function(c) { return c.code === currency; });
            if (foundCurr) {
                selectCurrency(currency, foundCurr.flag + ' ' + currency);
            }
            document.getElementById('countryDropdown').classList.remove('show');
            showNotification('Selected: ' + name + ' - Currency changed to ' + currency, 'success');
        }

        function filterCountries() {
            var input = document.getElementById('countrySearch');
            var term = input.value.toLowerCase();
            var dropdown = document.getElementById('countryDropdown');
            if (term.length < 1) {
                if (dropdown) dropdown.classList.remove('show');
                return;
            }
            var filtered = countries.filter(function(c) {
                return c.name.toLowerCase().includes(term) || c.code.toLowerCase().includes(term);
            });
            if (filtered.length === 0) {
                dropdown.innerHTML = '<div class="no-results">No countries found</div>';
            } else {
                var html = '';
                for (var i = 0; i < Math.min(filtered.length, 15); i++) {
                    var c = filtered[i];
                    html += '<div class="country-option" onclick="selectCountry(\'' + c.code + '\', \'' + c.name + '\', \'' + c.currency + '\')">' + c.flag + ' ' + c.name + ' (' + c.currency + ')</div>';
                }
                dropdown.innerHTML = html;
            }
            dropdown.classList.add('show');
        }

        function showCountryDropdown() {
            var input = document.getElementById('countrySearch');
            if (input.value.length >= 1) filterCountries();
        }

        function updateSelectedCountryDisplay() {
            var displaySpan = document.getElementById('selectedCountryDisplay');
            var flagSpan = document.getElementById('selectedCountryFlag');
            var nameSpan = document.getElementById('selectedCountryName');
            if (selectedCountryCode && selectedCountryName) {
                flagSpan.innerHTML = selectedCountryFlag;
                nameSpan.innerHTML = selectedCountryName;
                displaySpan.style.display = 'inline-flex';
            } else {
                displaySpan.style.display = 'none';
            }
        }

        function buildSliderDots() {
            var dotsContainer = document.getElementById('sliderDots');
            if (!dotsContainer) return;
            dotsContainer.innerHTML = '';
            for (var i = 0; i < totalSlides; i++) {
                var dot = document.createElement('div');
                dot.className = 'dot';
                dot.onclick = (function(index) { return function() { goToSlide(index); }; })(i);
                dotsContainer.appendChild(dot);
            }
            updateDots();
        }

        function updateDots() {
            var dots = document.querySelectorAll('.dot');
            for (var i = 0; i < dots.length; i++) {
                if (i === currentSlide) {
                    dots[i].classList.add('active');
                } else {
                    dots[i].classList.remove('active');
                }
            }
        }

        function updateSliderPosition() {
            var track = document.getElementById('sliderTrack');
            if (track) {
                track.style.transform = 'translateX(-' + (currentSlide * 100) + '%)';
            }
            updateDots();
        }

        function nextSlide() {
            if (totalSlides > 0) {
                currentSlide = (currentSlide + 1) % totalSlides;
                updateSliderPosition();
                resetAutoPlay();
            }
        }

        function prevSlide() {
            if (totalSlides > 0) {
                currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
                updateSliderPosition();
                resetAutoPlay();
            }
        }

        function goToSlide(index) {
            currentSlide = index;
            updateSliderPosition();
            resetAutoPlay();
        }

        function startAutoPlay() {
            if (slideInterval) clearInterval(slideInterval);
            if (totalSlides > 1) {
                slideInterval = setInterval(function() {
                    if (isPlaying) {
                        nextSlide();
                    }
                }, 5000);
            }
        }

        function resetAutoPlay() {
            if (slideInterval) clearInterval(slideInterval);
            startAutoPlay();
        }

        function toggleAutoPlay() {
            isPlaying = !isPlaying;
            var pauseBtn = document.getElementById('sliderPause');
            if (pauseBtn) {
                pauseBtn.innerHTML = isPlaying ? '<i class="fas fa-pause"></i>' : '<i class="fas fa-play"></i>';
            }
        }

        function getFilteredProducts() {
            var filtered = [];
            for (var id in productsData) {
                var p = productsData[id];
                if (currentCategory !== 'all' && p.category !== currentCategory) continue;
                if (currentSearchTerm !== '' && p.name.toLowerCase().indexOf(currentSearchTerm.toLowerCase()) === -1 && p.description.toLowerCase().indexOf(currentSearchTerm.toLowerCase()) === -1) continue;
                filtered.push({ id: id, data: p });
            }
            return filtered;
        }

        function displayProducts() {
            var filtered = getFilteredProducts();
            var totalPages = Math.ceil(filtered.length / itemsPerPage);
            var start = (currentPage - 1) * itemsPerPage;
            var paginated = filtered.slice(start, start + itemsPerPage);
            var grid = document.getElementById('productsGrid');
            var symbol = getCurrencySymbol();
            if (paginated.length === 0) {
                grid.innerHTML = '<div style="text-align:center; padding:50px;"><i class="fas fa-search" style="font-size:48px; color:#ccc;"></i><h3>No products found</h3></div>';
                updatePagination(1, 1);
                return;
            }
            var html = '';
            for (var i = 0; i < paginated.length; i++) {
                var p = paginated[i].data, id = paginated[i].id;
                var hasSale = p.oldPrice && p.oldPrice > p.price;
                var stars = '';
                for (var s = 0; s < p.rating; s++) stars += '★';
                for (var s = p.rating; s < 5; s++) stars += '☆';
                var discount = hasSale ? Math.round((1 - p.price / p.oldPrice) * 100) : 0;
                html += '<div class="product-card">';
                if (hasSale) html += '<div class="product-badge">-' + discount + '%</div>';
                html += '<img src="' + p.image + '" class="product-image" onclick="viewProduct(' + id + ')" onerror="this.src=\'' + contextPath + '/uploads/products/placeholder.jpg\'">';
                html += '<div class="product-info">';
                html += '<div class="product-title" onclick="viewProduct(' + id + ')">' + p.name + '</div>';
                html += '<div class="product-category">' + (p.category ? p.category.toUpperCase() : '') + '</div>';
                html += '<div class="product-price"><span class="current-price">' + symbol + ' ' + convertPrice(p.price) + '</span>';
                if (p.oldPrice) html += '<span class="old-price">' + symbol + ' ' + convertPrice(p.oldPrice) + '</span>';
                html += '</div><div class="product-rating">' + stars + ' (' + p.reviews + ')</div>';
                html += '<div class="product-actions">';
                html += '<button class="action-icon buy-now" onclick="buyNow(' + id + ')"><i class="fas fa-bolt"></i> Buy</button>';
                html += '<button class="action-icon cart-icon" onclick="addToCart(' + id + ', \'' + p.name + '\', ' + p.price + ')"><i class="fas fa-cart-plus"></i></button>';
                html += '<button class="action-icon wishlist-icon" onclick="toggleWishlist(' + id + ', \'' + p.name + '\', ' + p.price + ')"><i class="fas fa-heart"></i></button>';
                html += '<button class="action-icon message-icon" onclick="messageSeller(' + id + ', \'' + p.name + '\')"><i class="fas fa-envelope"></i></button>';
                html += '<button class="action-icon shop-icon" onclick="viewShop()"><i class="fas fa-store"></i></button>';
                html += '</div></div></div>';
            }
            grid.innerHTML = html;
            updatePagination(currentPage, totalPages);
            updateCartCount();
            updateWishlistCount();
        }

        function updatePagination(page, total) {
            var pagination = document.getElementById('pagination');
            if (total <= 1) {
                pagination.innerHTML = '';
                return;
            }
            var html = '';
            if (page > 1) html += '<a onclick="goToPage(' + (page - 1) + ')">« Prev</a>';
            for (var i = Math.max(1, page - 2); i <= Math.min(total, page + 2); i++) {
                html += '<a onclick="goToPage(' + i + ')" class="' + (i === page ? 'active' : '') + '">' + i + '</a>';
            }
            if (page < total) html += '<a onclick="goToPage(' + (page + 1) + ')">Next »</a>';
            pagination.innerHTML = html;
        }

        function goToPage(page) { currentPage = page; displayProducts(); }
        function filterByCategory(category, element) {
            currentCategory = category;
            currentSearchTerm = '';
            currentPage = 1;
            document.getElementById('searchInput').value = '';
            var links = document.querySelectorAll('.category-bar a');
            for (var i = 0; i < links.length; i++) links[i].classList.remove('active');
            if (element) element.classList.add('active');
            displayProducts();
            showNotification('Showing ' + category + ' products', 'info');
        }
        function searchProducts() { currentSearchTerm = document.getElementById('searchInput').value; currentPage = 1; displayProducts(); }
        function resetFilters() {
            currentCategory = 'all';
            currentSearchTerm = '';
            currentPage = 1;
            document.getElementById('searchInput').value = '';
            var links = document.querySelectorAll('.category-bar a');
            for (var i = 0; i < links.length; i++) links[i].classList.remove('active');
            document.querySelector('.category-bar a').classList.add('active');
            displayProducts();
            showNotification('All products shown', 'info');
        }
        function searchSuggestions() {
            var term = document.getElementById('searchInput').value.toLowerCase();
            var suggestionsDiv = document.getElementById('searchSuggestions');
            if (term.length < 2) {
                suggestionsDiv.style.display = 'none';
                return;
            }
            var matches = [];
            for (var id in productsData) {
                if (productsData[id].name.toLowerCase().includes(term)) matches.push(productsData[id].name);
            }
            if (matches.length === 0) {
                suggestionsDiv.style.display = 'none';
                return;
            }
            suggestionsDiv.style.display = 'block';
            suggestionsDiv.innerHTML = matches.slice(0, 5).map(function(m) {
                return '<div class="search-suggestion-item" onclick="selectSuggestion(\'' + m + '\')">' + m + '</div>';
            }).join('');
        }
        function selectSuggestion(name) { document.getElementById('searchInput').value = name; searchProducts(); document.getElementById('searchSuggestions').style.display = 'none'; }
        function convertPrice(priceUSD) { var rate = exchangeRates[currentCurrency] || 1; return (priceUSD * rate).toFixed(2); }
        function getCurrencySymbol() { var symbols = { USD:'$', XAF:'FCFA', CNY:'¥', EUR:'€', JPY:'¥', AED:'د.إ', GBP:'£', NGN:'₦', INR:'₹', CAD:'C$', AUD:'A$', ZAR:'R', KES:'KSh', GHS:'GH₵' }; return symbols[currentCurrency] || currentCurrency; }
        function addToCart(id, name, price) { var existing = cart.find(function(i){return i.id==id;}); if(existing) existing.quantity++; else cart.push({id:id, name:name, price:price, quantity:1, image:productsData[id].image}); updateCartCount(); showNotification(name + ' added to cart!', 'success'); }
        function updateCartCount() { var count = cart.reduce(function(t,i){return t+i.quantity;},0); document.getElementById('cartCount').innerHTML = count; document.getElementById('cartItemCount').innerHTML = count; localStorage.setItem('cart', JSON.stringify(cart)); }
        function toggleWishlist(id, name, price) { var index = wishlist.findIndex(function(i){return i.id==id;}); if(index>-1) wishlist.splice(index,1); else wishlist.push({id:id, name:name, price:price, image:productsData[id].image}); updateWishlistCount(); showNotification(index>-1 ? name + ' removed from wishlist' : name + ' added to wishlist', 'info'); }
        function updateWishlistCount() { document.getElementById('wishlistCount').innerHTML = wishlist.length; document.getElementById('wishlistItemCount').innerHTML = wishlist.length; localStorage.setItem('wishlist', JSON.stringify(wishlist)); }
        function buyNow(id) { window.location.href = '${pageContext.request.contextPath}/user/product.jsp?id=' + id; }
        function viewProduct(id) { window.location.href = '${pageContext.request.contextPath}/user/product.jsp?id=' + id; }
        function messageSeller(id, name) { showNotification('Message seller about ' + name, 'info'); }
        function viewShop() { showNotification('Shop page coming soon!', 'info'); }
        function updateTimer() { var now=new Date(), end=new Date(); end.setHours(23,59,59,999); var diff=end-now; var h=Math.floor(diff/3600000), m=Math.floor((diff%3600000)/60000), s=Math.floor((diff%60000)/1000); var timer=document.getElementById('timer'); if(timer) timer.innerHTML='⏰ Ending in: '+(h<10?'0'+h:h)+':'+(m<10?'0'+m:m)+':'+(s<10?'0'+s:s); }
        function showNotification(msg, type) { var n=document.createElement('div'); var bg=type==='error'?'#dc2626':(type==='info'?'#2196f3':'#0b4f3c'); n.style.cssText='position:fixed; bottom:20px; right:20px; background:'+bg+'; color:white; padding:10px 18px; border-radius:8px; z-index:2000; font-size:13px;'; n.innerHTML=msg; document.body.appendChild(n); setTimeout(function(){if(n&&n.remove)n.remove();},3000); }
        function closeProductModal() { document.getElementById('productModal').classList.remove('active'); }
        function openProductModal(id) { var product = productsData[id]; if (!product) return; var symbol = getCurrencySymbol(); var stars = ''; for (var s=0; s<product.rating; s++) stars+='★'; for(var s=product.rating; s<5; s++) stars+='☆'; var modalContent = document.getElementById('modalContent'); modalContent.innerHTML = '<div class="product-detail"><div class="product-detail-image"><img src="'+product.image+'" onerror="this.src=\'' + contextPath + '/uploads/products/placeholder.jpg\'"></div><div class="product-detail-info"><h1 class="product-detail-title">'+product.name+'</h1><div class="product-detail-price">'+symbol+' '+convertPrice(product.price)+(product.oldPrice?'<span class="product-detail-old-price">'+symbol+' '+convertPrice(product.oldPrice)+'</span>':'')+'</div><p class="product-detail-description">'+product.description+'</p><div class="detail-quantity"><button class="detail-quantity-btn" onclick="decreaseModalQuantity()">-</button><input type="number" id="modalQuantity" class="detail-quantity-input" value="1" min="1" max="'+product.stock+'"><button class="detail-quantity-btn" onclick="increaseModalQuantity('+product.stock+')">+</button></div><button class="detail-add-to-cart" onclick="addFromModal('+id+', \''+product.name+'\', '+product.price+')">Add to Cart</button></div></div>'; document.getElementById('productModal').classList.add('active'); }
        function decreaseModalQuantity() { var qty = document.getElementById('modalQuantity'); if (qty && parseInt(qty.value) > 1) qty.value = parseInt(qty.value) - 1; }
        function increaseModalQuantity(max) { var qty = document.getElementById('modalQuantity'); if (qty && parseInt(qty.value) < max) qty.value = parseInt(qty.value) + 1; }
        function addFromModal(id, name, price) { var qty = document.getElementById('modalQuantity'); var quantity = qty ? parseInt(qty.value) : 1; addToCart(id, name, price, quantity); closeProductModal(); }

        function fetchExchangeRates() {
            fetch('https://api.exchangerate-api.com/v4/latest/USD')
                .then(function(response) { return response.json(); })
                .then(function(data) {
                    if (data && data.rates) {
                        exchangeRates = data.rates;
                        localStorage.setItem('exchangeRates', JSON.stringify(exchangeRates));
                        displayProducts();
                        convertCurrencyModal();
                        updateSelectedCurrencyDisplay();
                    }
                })
                .catch(function(error) {
                    console.error('Failed to fetch rates:', error);
                    var cachedRates = localStorage.getItem('exchangeRates');
                    if (cachedRates) { exchangeRates = JSON.parse(cachedRates); }
                    displayProducts();
                    convertCurrencyModal();
                });
        }

        function updateSelectedCurrencyDisplay() {
            var found = allCurrencies.find(function(c) { return c.code === currentCurrency; });
            if (found) {
                document.getElementById('selectedCurrencyDisplay').innerHTML = found.flag + ' ' + found.code;
            }
        }

        // Event listeners
        document.addEventListener('click', function(event) {
            var currencyContainer = document.querySelector('.currency-selector-container');
            var currencyDropdown = document.getElementById('currencyDropdownList');
            if (currencyContainer && currencyDropdown && !currencyContainer.contains(event.target)) {
                currencyDropdown.classList.remove('show');
            }
            var fromContainer = document.getElementById('converterFromContainer');
            var toContainer = document.getElementById('converterToContainer');
            var fromDropdown = document.getElementById('converterFromDropdown');
            var toDropdown = document.getElementById('converterToDropdown');
            if (fromContainer && fromDropdown && !fromContainer.contains(event.target)) fromDropdown.classList.remove('show');
            if (toContainer && toDropdown && !toContainer.contains(event.target)) toDropdown.classList.remove('show');
            var countryContainer = document.querySelector('.country-search-container');
            var countryDropdown = document.getElementById('countryDropdown');
            if (countryContainer && countryDropdown && !countryContainer.contains(event.target)) countryDropdown.classList.remove('show');
            var adminContainer = document.querySelector('.admin-dropdown');
            var adminMenu = document.getElementById('adminMenu');
            if (adminContainer && adminMenu && !adminContainer.contains(event.target)) {
                adminMenu.classList.remove('show');
            }
        });

        var contextPath = '${pageContext.request.contextPath}';

        function init() {
            fetchExchangeRates();
            updateCartCount();
            updateWishlistCount();
            displayProducts();
            updateSelectedCountryDisplay();
            updateSelectedCurrencyDisplay();
            populateConverterOptions();
            totalSlides = document.querySelectorAll('.slider-slide').length;
            buildSliderDots();
            startAutoPlay();
            changeLanguage(currentLanguage);
            var prevBtn = document.getElementById('prevSlide');
            var nextBtn = document.getElementById('nextSlide');
            var pauseBtn = document.getElementById('sliderPause');
            if (prevBtn) prevBtn.addEventListener('click', prevSlide);
            if (nextBtn) nextBtn.addEventListener('click', nextSlide);
            if (pauseBtn) pauseBtn.addEventListener('click', toggleAutoPlay);
        }

        init();
        setInterval(updateTimer, 1000);
        updateTimer();
    </script>
</body>
</html>