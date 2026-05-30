<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

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

        .category-bar { background: white; padding: 6px 30px; border-bottom: 1px solid #eee; border-top: 1px solid #eee; position: fixed; top: 78px; width: 100%; z-index: 999; overflow-x: auto; white-space: nowrap; }
        .category-bar a { display: inline-block; padding: 4px 16px; color: #666; text-decoration: none; font-size: 12px; font-weight: 500; cursor: pointer; transition: all 0.3s; border-radius: 20px; }
        .category-bar a:hover { color: #0b4f3c; background: #e8f0fe; }
        .category-bar a.active { background: #0b4f3c; color: white; }

        .container { margin-top: 125px; padding: 20px 30px; }
        .hero-banner { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 16px; padding: 25px; color: white; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .hero-text h2 { font-size: 24px; margin-bottom: 5px; }
        .hero-text p { opacity: 0.9; font-size: 13px; }
        .user-stats { display: flex; gap: 15px; background: rgba(255,255,255,0.2); padding: 10px 20px; border-radius: 12px; }
        .user-stat { text-align: center; }
        .user-stat-value { font-size: 20px; font-weight: 800; }
        .user-stat-label { font-size: 9px; opacity: 0.8; }
        .offer-badge { background: rgba(255,255,255,0.2); padding: 10px 20px; border-radius: 12px; text-align: center; }
        .offer-badge .big { font-size: 26px; font-weight: 800; }

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
        .buy-now:hover { background: #0a3d2e; transform: translateY(-2px); }
        .cart-icon { background: #e0e8f0; color: #333; }
        .cart-icon:hover { background: #0b4f3c; color: white; }
        .wishlist-icon { background: #fff0f0; color: #dc2626; }
        .wishlist-icon:hover { background: #dc2626; color: white; }
        .message-icon { background: #e8f0fe; color: #2563eb; }
        .message-icon:hover { background: #2563eb; color: white; }
        .shop-icon { background: #fef3c7; color: #d97706; }
        .shop-icon:hover { background: #d97706; color: white; }

        .features-section { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin: 30px 0; }
        .feature-item { background: white; padding: 15px; border-radius: 10px; text-align: center; }
        .feature-item:hover { transform: translateY(-3px); }
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

        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 2000; justify-content: center; align-items: center; }
        .modal.active { display: flex; }
        .modal-content { background: white; border-radius: 16px; max-width: 800px; width: 90%; max-height: 85vh; overflow-y: auto; position: relative; }
        .modal-close { position: absolute; top: 12px; right: 18px; font-size: 24px; cursor: pointer; color: #999; z-index: 10; }
        .modal-close:hover { color: #333; }
        .product-detail { display: flex; flex-wrap: wrap; }
        .product-detail-image { flex: 1; min-width: 200px; background: #f8f9fa; padding: 20px; }
        .product-detail-image img { width: 100%; border-radius: 12px; }
        .product-detail-info { flex: 1; padding: 20px; }
        .product-detail-title { font-size: 22px; font-weight: 700; margin-bottom: 8px; }
        .product-detail-rating { color: #ffc107; margin-bottom: 10px; font-size: 13px; }
        .product-detail-price { font-size: 24px; font-weight: 700; color: #0b4f3c; margin-bottom: 8px; }
        .product-detail-old-price { font-size: 16px; color: #999; text-decoration: line-through; margin-left: 8px; }
        .product-detail-description { color: #666; line-height: 1.5; margin: 15px 0; font-size: 13px; }
        .product-detail-meta { padding: 10px 0; border-top: 1px solid #eee; border-bottom: 1px solid #eee; margin: 10px 0; font-size: 12px; }
        .detail-quantity { display: flex; align-items: center; gap: 10px; margin: 15px 0; }
        .detail-quantity-btn { width: 32px; height: 32px; border: 1px solid #ddd; background: white; border-radius: 6px; cursor: pointer; font-size: 16px; }
        .detail-quantity-input { width: 50px; text-align: center; border: 1px solid #ddd; border-radius: 6px; padding: 6px; }
        .detail-add-to-cart { background: #0b4f3c; color: white; border: none; padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; width: 100%; }

        .converter-modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2001; justify-content: center; align-items: center; }
        .converter-modal.active { display: flex; }
        .converter-card { background: white; border-radius: 16px; width: 420px; max-width: 90%; padding: 20px; box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .converter-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .converter-header h3 { font-size: 16px; color: #333; }
        .converter-close { cursor: pointer; font-size: 22px; color: #999; }
        .converter-close:hover { color: #333; }
        .converter-row { display: flex; gap: 12px; align-items: center; margin-bottom: 12px; flex-wrap: wrap; }
        .converter-input-group { flex: 1; min-width: 100px; }
        .converter-input-group label { display: block; font-size: 10px; color: #666; margin-bottom: 3px; }
        .converter-input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; }
        .converter-select-container { position: relative; flex: 1; min-width: 100px; }
        .converter-select-btn { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 6px; font-size: 12px; background: white; cursor: pointer; display: flex; align-items: center; justify-content: space-between; }
        .converter-select-dropdown { position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-radius: 6px; max-height: 200px; overflow-y: auto; display: none; z-index: 100; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .converter-select-dropdown.show { display: block; }
        .converter-search-input { width: 100%; padding: 6px 8px; border: none; border-bottom: 1px solid #eee; outline: none; font-size: 11px; }
        .converter-currency-option { padding: 6px 10px; cursor: pointer; border-bottom: 1px solid #f0f0f0; font-size: 11px; display: flex; align-items: center; gap: 6px; }
        .converter-currency-option:hover { background: #f0f2f5; }
        .swap-icon { cursor: pointer; color: #0b4f3c; font-size: 18px; padding: 5px; margin-top: 15px; }
        .convert-result { background: #f0f2f5; padding: 12px; border-radius: 8px; text-align: center; font-size: 14px; font-weight: 600; color: #0b4f3c; margin-top: 12px; }
        .live-rate { font-size: 10px; color: #666; text-align: center; margin-top: 8px; }

        @media (max-width: 768px) {
            .navbar { padding: 8px 15px; top: 26px; }
            .category-bar { top: 74px; padding: 5px 15px; }
            .container { margin-top: 120px; padding: 15px; }
            .country-search { width: 100px; font-size: 10px; }
            .currency-selector-btn { width: 75px; font-size: 10px; }
            .search-container { order: 3; margin: 8px 0 0; max-width: 100%; width: 100%; }
            .nav-icons { order: 2; }
            .hero-banner { flex-direction: column; text-align: center; }
            .user-stats { justify-content: center; }
            .features-section { grid-template-columns: repeat(2, 1fr); }
            .footer-grid { grid-template-columns: 1fr; text-align: center; }
            .converter-card { width: 95%; }
            .converter-row { flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>
    <div class="top-bar">🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support | Secure Payments</div>

    <div class="navbar">
        <div class="logo" onclick="resetFilters()">🛍️ ShopWithUs!</div>

        <div class="search-container">
            <input type="text" id="searchInput" placeholder="Search products..." onkeyup="searchSuggestions()">
            <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
            <div id="searchSuggestions" class="search-suggestions"></div>
        </div>

        <div class="nav-icons">
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
            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <div class="category-bar" id="categoryBar">
        <a href="#" onclick="filterByCategory('all', this)" class="active">All</a>
        <a href="#" onclick="filterByCategory('women', this)">Women</a>
        <a href="#" onclick="filterByCategory('men', this)">Men</a>
        <a href="#" onclick="filterByCategory('shoes', this)">Shoes</a>
        <a href="#" onclick="filterByCategory('bags', this)">Bags</a>
        <a href="#" onclick="filterByCategory('beauty', this)">Beauty</a>
        <a href="#" onclick="filterByCategory('electronics', this)">Electronics</a>
        <a href="#" onclick="filterByCategory('home', this)">Home</a>
        <a href="#" onclick="filterByCategory('kids', this)">Kids</a>
        <a href="#" onclick="filterByCategory('sports', this)">Sports</a>
    </div>

    <div class="container">
        <div class="hero-banner">
            <div class="hero-text">
                <h2>Welcome back, @<%= displayName %>! 👋</h2>
                <p>Discover amazing deals and exclusive offers just for you</p>
            </div>
            <div class="user-stats">
                <div class="user-stat"><div class="user-stat-value" id="cartItemCount">0</div><div class="user-stat-label">Cart Items</div></div>
                <div class="user-stat"><div class="user-stat-value" id="wishlistItemCount">0</div><div class="user-stat-label">Wishlist</div></div>
                <div class="user-stat"><div class="user-stat-value">0</div><div class="user-stat-label">Orders</div></div>
            </div>
            <div class="offer-badge">
                <div class="big">30% OFF</div>
                <div>Your First Order</div>
                <small>Code: WELCOME30</small>
            </div>
        </div>

        <div class="section-header">
            <h3>⚡ Flash Sale <span style="font-size:11px; color:#666;">Ends soon!</span></h3>
            <div class="timer" id="timer">Ending in: 23:59:59</div>
        </div>

        <div class="products-grid" id="productsGrid"></div>
        <div class="pagination" id="pagination"></div>
    </div>

    <div class="features-section">
        <div class="feature-item"><div class="feature-icon">🚚</div><div class="feature-title">Free Shipping</div><div class="feature-desc">On orders $50+</div></div>
        <div class="feature-item"><div class="feature-icon">🔒</div><div class="feature-title">Secure Payment</div><div class="feature-desc">100% secure checkout</div></div>
        <div class="feature-item"><div class="feature-icon">↩️</div><div class="feature-title">Easy Returns</div><div class="feature-desc">30 days return policy</div></div>
        <div class="feature-item"><div class="feature-icon">💬</div><div class="feature-title">24/7 Support</div><div class="feature-desc">Live chat available</div></div>
    </div>

    <div class="footer">
        <div class="footer-grid">
            <div class="footer-section"><h4>ShopWithUs</h4><a onclick="showNotification('About Us coming soon!', 'info')">About Us</a><a onclick="showNotification('Careers coming soon!', 'info')">Careers</a><a onclick="showNotification('Press coming soon!', 'info')">Press</a></div>
            <div class="footer-section"><h4>Customer Service</h4><a onclick="showNotification('Contact Us coming soon!', 'info')">Contact Us</a><a onclick="showNotification('Shipping Info coming soon!', 'info')">Shipping Info</a><a onclick="showNotification('Returns & Refunds coming soon!', 'info')">Returns & Refunds</a></div>
            <div class="footer-section"><h4>My Account</h4><a href="${pageContext.request.contextPath}/user/wishlist.jsp">My Wishlist</a><a href="${pageContext.request.contextPath}/user/cart.jsp">My Cart</a><a onclick="showNotification('My Orders coming soon!', 'info')">My Orders</a></div>
            <div class="footer-section"><h4>Follow Us</h4><a href="#"><i class="fab fa-facebook"></i> Facebook</a><a href="#"><i class="fab fa-instagram"></i> Instagram</a><a href="#"><i class="fab fa-twitter"></i> Twitter</a></div>
        </div>
        <div class="payment-methods"><i class="fab fa-cc-visa"></i> <i class="fab fa-cc-mastercard"></i> <i class="fab fa-cc-paypal"></i> <i class="fab fa-alipay"></i> <i class="fab fa-weixin"></i></div>
        <div class="copyright">© 2024 ShopWithUs — All rights reserved. Smarter Shopping Starts Here.</div>
    </div>

    <div id="productModal" class="modal"><div class="modal-content"><span class="modal-close" onclick="closeProductModal()">&times;</span><div id="modalContent"></div></div></div>

    <div id="converterModal" class="converter-modal">
        <div class="converter-card">
            <div class="converter-header">
                <h3><i class="fas fa-calculator"></i> Currency Converter</h3>
                <span class="converter-close" onclick="closeConverterModal()">&times;</span>
            </div>
            <div class="converter-row">
                <div class="converter-input-group">
                    <label>Amount</label>
                    <input type="number" id="convertAmount" class="converter-input" value="1" step="0.01" oninput="convertCurrencyModal()">
                </div>
            </div>
            <div class="converter-row">
                <div class="converter-select-container" id="converterFromContainer">
                    <div class="converter-select-btn" onclick="toggleConverterDropdown('from')">
                        <span id="converterFromDisplay">🇺🇸 USD</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="converterFromDropdown" class="converter-select-dropdown">
                        <input type="text" id="converterFromSearch" class="converter-search-input" placeholder="🔍 Search currency..." onkeyup="filterConverterOptions('from')">
                        <div id="converterFromOptions"></div>
                    </div>
                </div>
                <i class="fas fa-exchange-alt swap-icon" onclick="swapCurrenciesModal()"></i>
                <div class="converter-select-container" id="converterToContainer">
                    <div class="converter-select-btn" onclick="toggleConverterDropdown('to')">
                        <span id="converterToDisplay">🇨🇲 XAF</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div id="converterToDropdown" class="converter-select-dropdown">
                        <input type="text" id="converterToSearch" class="converter-search-input" placeholder="🔍 Search currency..." onkeyup="filterConverterOptions('to')">
                        <div id="converterToOptions"></div>
                    </div>
                </div>
            </div>
            <div class="convert-result" id="convertResult">1 USD = 0 XAF</div>
            <div class="live-rate" id="liveRate">Live exchange rates from API</div>
        </div>
    </div>

    <script>
        var countries = [
            { code: "CM", name: "Cameroon", currency: "XAF", flag: "🇨🇲" }, { code: "CN", name: "China", currency: "CNY", flag: "🇨🇳" }, { code: "US", name: "United States", currency: "USD", flag: "🇺🇸" }, { code: "GB", name: "United Kingdom", currency: "GBP", flag: "🇬🇧" }, { code: "FR", name: "France", currency: "EUR", flag: "🇫🇷" }, { code: "DE", name: "Germany", currency: "EUR", flag: "🇩🇪" }, { code: "JP", name: "Japan", currency: "JPY", flag: "🇯🇵" }, { code: "AE", name: "UAE", currency: "AED", flag: "🇦🇪" }, { code: "NG", name: "Nigeria", currency: "NGN", flag: "🇳🇬" }, { code: "IN", name: "India", currency: "INR", flag: "🇮🇳" }, { code: "CA", name: "Canada", currency: "CAD", flag: "🇨🇦" }, { code: "AU", name: "Australia", currency: "AUD", flag: "🇦🇺" }, { code: "ZA", name: "South Africa", currency: "ZAR", flag: "🇿🇦" }, { code: "KE", name: "Kenya", currency: "KES", flag: "🇰🇪" }, { code: "GH", name: "Ghana", currency: "GHS", flag: "🇬🇭" }, { code: "BR", name: "Brazil", currency: "BRL", flag: "🇧🇷" }, { code: "MX", name: "Mexico", currency: "MXN", flag: "🇲🇽" }, { code: "KR", name: "South Korea", currency: "KRW", flag: "🇰🇷" }, { code: "RU", name: "Russia", currency: "RUB", flag: "🇷🇺" }, { code: "TR", name: "Turkey", currency: "TRY", flag: "🇹🇷" }, { code: "SA", name: "Saudi Arabia", currency: "SAR", flag: "🇸🇦" }
        ];

        var allCurrencies = [
            { code: "XAF", name: "CFA Franc (Cameroon)", flag: "🇨🇲" }, { code: "USD", name: "US Dollar", flag: "🇺🇸" }, { code: "CNY", name: "Chinese Yuan", flag: "🇨🇳" }, { code: "EUR", name: "Euro", flag: "🇪🇺" }, { code: "JPY", name: "Japanese Yen", flag: "🇯🇵" }, { code: "AED", name: "UAE Dirham", flag: "🇦🇪" }, { code: "GBP", name: "British Pound", flag: "🇬🇧" }, { code: "NGN", name: "Nigerian Naira", flag: "🇳🇬" }, { code: "INR", name: "Indian Rupee", flag: "🇮🇳" }, { code: "CAD", name: "Canadian Dollar", flag: "🇨🇦" }, { code: "AUD", name: "Australian Dollar", flag: "🇦🇺" }, { code: "CHF", name: "Swiss Franc", flag: "🇨🇭" }, { code: "SEK", name: "Swedish Krona", flag: "🇸🇪" }, { code: "NZD", name: "New Zealand Dollar", flag: "🇳🇿" }, { code: "SGD", name: "Singapore Dollar", flag: "🇸🇬" }, { code: "MYR", name: "Malaysian Ringgit", flag: "🇲🇾" }, { code: "THB", name: "Thai Baht", flag: "🇹🇭" }, { code: "VND", name: "Vietnamese Dong", flag: "🇻🇳" }, { code: "PHP", name: "Philippine Peso", flag: "🇵🇭" }, { code: "ZAR", name: "South African Rand", flag: "🇿🇦" }, { code: "KES", name: "Kenyan Shilling", flag: "🇰🇪" }, { code: "GHS", name: "Ghanaian Cedi", flag: "🇬🇭" }, { code: "BRL", name: "Brazilian Real", flag: "🇧🇷" }, { code: "MXN", name: "Mexican Peso", flag: "🇲🇽" }, { code: "KRW", name: "South Korean Won", flag: "🇰🇷" }, { code: "RUB", name: "Russian Ruble", flag: "🇷🇺" }, { code: "TRY", name: "Turkish Lira", flag: "🇹🇷" }, { code: "SAR", name: "Saudi Riyal", flag: "🇸🇦" }
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
            1: { name: "Floral Summer Dress", price: 29.99, oldPrice: 49.99, rating: 4, reviews: 128, image: "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446", description: "Beautiful floral print summer dress...", category: "women", stock: 50 },
            2: { name: "Nike Running Shoes", price: 89.99, oldPrice: null, rating: 5, reviews: 342, image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff", description: "Premium running shoes...", category: "shoes", stock: 45 },
            3: { name: "Smart Watch Series 8", price: 149.99, oldPrice: 199.99, rating: 4, reviews: 567, image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30", description: "Advanced smart watch...", category: "electronics", stock: 40 },
            4: { name: "Wireless Headphones", price: 99.99, oldPrice: 149.99, rating: 4, reviews: 892, image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e", description: "Premium wireless headphones...", category: "electronics", stock: 75 },
            5: { name: "Designer Handbag", price: 69.99, oldPrice: 89.99, rating: 4, reviews: 234, image: "https://images.unsplash.com/photo-1584917865442-de89df76afd3", description: "Elegant leather handbag...", category: "bags", stock: 25 },
            6: { name: "Premium Makeup Kit", price: 39.99, oldPrice: null, rating: 4, reviews: 456, image: "https://images.unsplash.com/photo-1596462502278-27bfdc403348", description: "Complete makeup kit...", category: "beauty", stock: 100 },
            7: { name: "Men Casual Shirt", price: 45.99, oldPrice: 69.99, rating: 4, reviews: 189, image: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c", description: "Comfortable casual shirt...", category: "men", stock: 60 },
            8: { name: "Kids Toy Set", price: 24.99, oldPrice: 34.99, rating: 4, reviews: 78, image: "https://images.unsplash.com/photo-1566576912321-d58ddd7a6088", description: "Educational toy set...", category: "kids", stock: 45 },
            9: { name: "Home Decor Lamp", price: 49.99, oldPrice: 79.99, rating: 4, reviews: 234, image: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c", description: "Modern LED desk lamp...", category: "home", stock: 30 },
            10: { name: "Sports Bag", price: 54.99, oldPrice: 79.99, rating: 4, reviews: 156, image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62", description: "Durable sports bag...", category: "sports", stock: 55 }
        };

        function toggleCurrencyDropdown() {
            var dropdown = document.getElementById('currencyDropdownList');
            dropdown.classList.toggle('show');
            if (dropdown.classList.contains('show')) {
                document.getElementById('currencySearchInput').focus();
                filterCurrencyOptions();
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
                fromDropdown.classList.toggle('show');
                toDropdown.classList.remove('show');
                if (fromDropdown.classList.contains('show')) {
                    document.getElementById('converterFromSearch').focus();
                    filterConverterOptions('from');
                }
            } else {
                toDropdown.classList.toggle('show');
                fromDropdown.classList.remove('show');
                if (toDropdown.classList.contains('show')) {
                    document.getElementById('converterToSearch').focus();
                    filterConverterOptions('to');
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
            var symbols = { USD:'$', EUR:'€', GBP:'£', JPY:'¥', CNY:'¥', XAF:'FCFA', AED:'د.إ', NGN:'₦', INR:'₹', CAD:'C$', AUD:'A$', ZAR:'R', KES:'KSh', GHS:'GH₵', BRL:'R$', MXN:'$', KRW:'₩', RUB:'₽', TRY:'₺', SAR:'﷼' };
            return symbols[currencyCode] || currencyCode;
        }

        document.addEventListener('click', function(event) {
            var container = document.querySelector('.currency-selector-container');
            var dropdown = document.getElementById('currencyDropdownList');
            if (container && dropdown && !container.contains(event.target)) {
                dropdown.classList.remove('show');
            }
            var fromContainer = document.getElementById('converterFromContainer');
            var toContainer = document.getElementById('converterToContainer');
            var fromDropdown = document.getElementById('converterFromDropdown');
            var toDropdown = document.getElementById('converterToDropdown');
            if (fromContainer && fromDropdown && !fromContainer.contains(event.target)) {
                fromDropdown.classList.remove('show');
            }
            if (toContainer && toDropdown && !toContainer.contains(event.target)) {
                toDropdown.classList.remove('show');
            }
        });

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
            var fromFound = allCurrencies.find(function(c) { return c.code === 'USD'; });
            var toFound = allCurrencies.find(function(c) { return c.code === 'XAF'; });
            if (fromFound) document.getElementById('converterFromDisplay').innerHTML = fromFound.flag + ' ' + fromFound.code;
            if (toFound) document.getElementById('converterToDisplay').innerHTML = toFound.flag + ' ' + toFound.code;
        }

        function selectCountry(code, name, currency) {
            var country = countries.find(function(c) { return c.code === code; });
            if (country) {
                selectedCountryCode = code; selectedCountryName = name; selectedCountryFlag = country.flag;
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
            if (term.length < 1) { dropdown.classList.remove('show'); return; }
            var filtered = countries.filter(function(c) { return c.name.toLowerCase().includes(term) || c.code.toLowerCase().includes(term); });
            if (filtered.length === 0) { dropdown.innerHTML = '<div class="no-results">No countries found</div>'; }
            else {
                var html = '';
                for (var i = 0; i < Math.min(filtered.length, 15); i++) {
                    var c = filtered[i];
                    html += '<div class="country-option" onclick="selectCountry(\'' + c.code + '\', \'' + c.name + '\', \'' + c.currency + '\')">' + c.flag + ' ' + c.name + ' (' + c.currency + ')</div>';
                }
                dropdown.innerHTML = html;
            }
            dropdown.classList.add('show');
        }

        function showCountryDropdown() { var input = document.getElementById('countrySearch'); if (input.value.length >= 1) filterCountries(); }
        function updateSelectedCountryDisplay() {
            var displaySpan = document.getElementById('selectedCountryDisplay');
            var flagSpan = document.getElementById('selectedCountryFlag');
            var nameSpan = document.getElementById('selectedCountryName');
            if (selectedCountryCode && selectedCountryName) {
                flagSpan.innerHTML = selectedCountryFlag;
                nameSpan.innerHTML = selectedCountryName;
                displaySpan.style.display = 'inline-flex';
            } else { displaySpan.style.display = 'none'; }
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
            if (paginated.length === 0) { grid.innerHTML = '<div style="text-align:center; padding:50px;"><i class="fas fa-search" style="font-size:48px; color:#ccc;"></i><h3>No products found</h3></div>'; updatePagination(1, 1); return; }
            var html = '';
            for (var i = 0; i < paginated.length; i++) {
                var p = paginated[i].data, id = paginated[i].id;
                var hasSale = p.oldPrice && p.oldPrice > p.price;
                var stars = ''; for (var s=0; s<p.rating; s++) stars+='★'; for(var s=p.rating; s<5; s++) stars+='☆';
                var discount = hasSale ? Math.round((1 - p.price/p.oldPrice)*100) : 0;
                html += '<div class="product-card">';
                if (hasSale) html += '<div class="product-badge">-' + discount + '%</div>';
                html += '<img src="' + p.image + '" class="product-image" onclick="viewProduct(' + id + ')" onerror="this.src=\'https://via.placeholder.com/220x180\'">';
                html += '<div class="product-info">';
                html += '<div class="product-title" onclick="viewProduct(' + id + ')">' + p.name + '</div>';
                html += '<div class="product-category">' + p.category.toUpperCase() + '</div>';
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
            if (total <= 1) { pagination.innerHTML = ''; return; }
            var html = '';
            if (page > 1) html += '<a onclick="goToPage(' + (page-1) + ')">« Prev</a>';
            for (var i = Math.max(1, page-2); i <= Math.min(total, page+2); i++) html += '<a onclick="goToPage(' + i + ')" class="' + (i===page?'active':'') + '">' + i + '</a>';
            if (page < total) html += '<a onclick="goToPage(' + (page+1) + ')">Next »</a>';
            pagination.innerHTML = html;
        }

        function goToPage(page) { currentPage = page; displayProducts(); }
        function filterByCategory(category, element) { currentCategory = category; currentSearchTerm = ''; currentPage = 1; document.getElementById('searchInput').value = ''; var links = document.querySelectorAll('.category-bar a'); for (var i=0; i<links.length; i++) links[i].classList.remove('active'); if (element) element.classList.add('active'); displayProducts(); showNotification('Showing ' + category + ' products', 'info'); }
        function searchProducts() { currentSearchTerm = document.getElementById('searchInput').value; currentPage = 1; displayProducts(); }
        function resetFilters() { currentCategory = 'all'; currentSearchTerm = ''; currentPage = 1; document.getElementById('searchInput').value = ''; document.querySelector('.category-bar a').classList.add('active'); displayProducts(); showNotification('All products shown', 'info'); }
        function searchSuggestions() { var term = document.getElementById('searchInput').value.toLowerCase(); var suggestionsDiv = document.getElementById('searchSuggestions'); if (term.length < 2) { suggestionsDiv.style.display = 'none'; return; } var matches = []; for (var id in productsData) { if (productsData[id].name.toLowerCase().includes(term)) matches.push(productsData[id].name); } if (matches.length === 0) { suggestionsDiv.style.display = 'none'; return; } suggestionsDiv.style.display = 'block'; suggestionsDiv.innerHTML = matches.slice(0,5).map(function(m) { return '<div class="search-suggestion-item" onclick="selectSuggestion(\'' + m + '\')">' + m + '</div>'; }).join(''); }
        function selectSuggestion(name) { document.getElementById('searchInput').value = name; searchProducts(); document.getElementById('searchSuggestions').style.display = 'none'; }
        function convertPrice(priceUSD) { var rate = exchangeRates[currentCurrency] || 1; return (priceUSD * rate).toFixed(2); }
        function getCurrencySymbol() { var symbols = { USD:'$', XAF:'FCFA', CNY:'¥', EUR:'€', JPY:'¥', AED:'د.إ', GBP:'£', NGN:'₦', INR:'₹', CAD:'C$', AUD:'A$', ZAR:'R', KES:'KSh', GHS:'GH₵', BRL:'R$', MXN:'$', KRW:'₩', RUB:'₽', TRY:'₺', SAR:'﷼' }; return symbols[currentCurrency] || currentCurrency; }
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

        function init() {
            fetchExchangeRates();
            updateCartCount();
            updateWishlistCount();
            displayProducts();
            updateSelectedCountryDisplay();
            updateSelectedCurrencyDisplay();
            populateConverterOptions();
        }
        init(); setInterval(updateTimer,1000); updateTimer();
    </script>
</body>
</html>