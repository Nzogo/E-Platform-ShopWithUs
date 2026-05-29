<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }
    String displayName = user.getNickname() != null && !user.getNickname().trim().isEmpty()
                        ? user.getNickname()
                        : user.getFullname().split(" ")[0];
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopWithUs - Your Shopping Dashboard</title>
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
            background: #f0f2f5;
        }

        .top-bar {
            background: #0b4f3c;
            color: white;
            padding: 8px 0;
            text-align: center;
            font-size: 12px;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1001;
        }

        .navbar {
            background: white;
            padding: 12px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            position: fixed;
            top: 32px;
            width: 100%;
            z-index: 1000;
            flex-wrap: wrap;
        }

        .logo {
            font-size: 24px;
            font-weight: 800;
            color: #0b4f3c;
            text-decoration: none;
            cursor: pointer;
        }

        .search-bar {
            flex: 1;
            max-width: 400px;
            margin: 0 20px;
            position: relative;
        }

        .search-bar input {
            width: 100%;
            padding: 10px 40px 10px 15px;
            border: 1px solid #ddd;
            border-radius: 25px;
            font-size: 14px;
            outline: none;
        }

        .search-bar button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            padding: 8px 12px;
            cursor: pointer;
            color: #0b4f3c;
        }

        .nav-icons {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .nav-icons a {
            color: #333;
            text-decoration: none;
            font-size: 18px;
            position: relative;
            cursor: pointer;
        }

        .nav-icons a:hover {
            color: #0b4f3c;
        }

        .cart-count {
            position: absolute;
            top: -8px;
            right: -10px;
            background: #ff6b6b;
            color: white;
            font-size: 10px;
            padding: 2px 5px;
            border-radius: 50%;
        }

        .logout-btn {
            background: #dc2626;
            color: white !important;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        .logout-btn:hover {
            background: #b91c1c;
        }

        .currency-selector {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            background: white;
        }

        .category-bar {
            background: white;
            padding: 10px 40px;
            border-bottom: 1px solid #eee;
            position: fixed;
            top: 88px;
            width: 100%;
            z-index: 999;
            overflow-x: auto;
            white-space: nowrap;
        }

        .category-bar a {
            display: inline-block;
            padding: 5px 20px;
            color: #666;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }

        .category-bar a:hover {
            color: #0b4f3c;
        }

        .category-bar a.active {
            background: #0b4f3c;
            color: white;
            border-radius: 20px;
        }

        .container {
            margin-top: 145px;
            padding: 20px 40px;
            transition: filter 0.3s ease;
        }

        .container.blurred {
            filter: blur(5px);
            pointer-events: none;
        }

        .hero-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 40px;
            color: white;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .hero-text h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }

        .hero-text p {
            opacity: 0.9;
            font-size: 14px;
        }

        .offer-badge {
            background: rgba(255,255,255,0.2);
            padding: 15px 25px;
            border-radius: 15px;
            text-align: center;
        }

        .offer-badge .big {
            font-size: 32px;
            font-weight: 800;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .section-header h3 {
            font-size: 20px;
            color: #333;
        }

        .timer {
            background: #ff6b6b;
            color: white;
            padding: 5px 20px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: 600;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .product-badge {
            position: absolute;
            top: 8px;
            left: 8px;
            background: #ff6b6b;
            color: white;
            padding: 2px 8px;
            border-radius: 15px;
            font-size: 10px;
            font-weight: 600;
            z-index: 1;
        }

        .product-badge.hot {
            background: #ff9800;
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .product-info {
            padding: 12px;
        }

        .product-title {
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 5px;
            color: #333;
        }

        .product-price {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-bottom: 8px;
        }

        .current-price {
            font-size: 16px;
            font-weight: 700;
            color: #0b4f3c;
        }

        .old-price {
            font-size: 12px;
            color: #999;
            text-decoration: line-through;
        }

        .product-rating {
            font-size: 11px;
            color: #ffc107;
            margin-bottom: 8px;
        }

        .add-to-cart {
            width: 100%;
            padding: 8px;
            background: #0b4f3c;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
        }

        .add-to-cart:hover {
            background: #0a3d2e;
        }

        .features-section {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin: 40px 0;
        }

        .feature-item {
            background: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
        }

        .feature-item:hover {
            transform: translateY(-3px);
        }

        .feature-icon {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .feature-title {
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .feature-desc {
            font-size: 11px;
            color: #666;
        }

        .footer {
            background: #1a1a2e;
            color: white;
            padding: 40px;
            margin-top: 40px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-section h4 {
            margin-bottom: 15px;
            font-size: 16px;
        }

        .footer-section a {
            display: block;
            color: #aaa;
            text-decoration: none;
            font-size: 12px;
            margin-bottom: 8px;
            cursor: pointer;
        }

        .footer-section a:hover {
            color: white;
        }

        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid #333;
            font-size: 12px;
            color: #aaa;
        }

        .payment-methods {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
            font-size: 24px;
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 20px;
            max-width: 900px;
            width: 90%;
            max-height: 85vh;
            overflow-y: auto;
            position: relative;
        }

        .modal-close {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 28px;
            cursor: pointer;
            color: #999;
            z-index: 10;
        }

        .modal-close:hover {
            color: #333;
        }

        .product-detail {
            display: flex;
            flex-wrap: wrap;
        }

        .product-detail-image {
            flex: 1;
            min-width: 250px;
            background: #f8f9fa;
            padding: 30px;
        }

        .product-detail-image img {
            width: 100%;
            border-radius: 15px;
        }

        .product-detail-info {
            flex: 1;
            padding: 30px;
        }

        .product-detail-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .product-detail-rating {
            color: #ffc107;
            margin-bottom: 15px;
        }

        .product-detail-price {
            font-size: 32px;
            font-weight: 700;
            color: #0b4f3c;
            margin-bottom: 10px;
        }

        .product-detail-old-price {
            font-size: 20px;
            color: #999;
            text-decoration: line-through;
            margin-left: 10px;
        }

        .product-detail-description {
            color: #666;
            line-height: 1.6;
            margin: 20px 0;
        }

        .product-detail-meta {
            padding: 15px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
            margin: 15px 0;
        }

        .detail-quantity {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 20px 0;
        }

        .detail-quantity-btn {
            width: 40px;
            height: 40px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
        }

        .detail-quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
        }

        .detail-add-to-cart {
            background: #0b4f3c;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 10px 20px;
            }
            .search-bar {
                order: 3;
                margin: 10px 0 0;
                max-width: 100%;
                width: 100%;
            }
            .container {
                padding: 20px;
                margin-top: 220px;
            }
            .features-section {
                grid-template-columns: repeat(2, 1fr);
            }
            .footer-grid {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support | Secure Payments
    </div>

    <div class="navbar">
        <div class="logo" onclick="resetFilters()">🛍️ ShopWithUs!</div>

        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search products...">
            <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
        </div>

        <div class="nav-icons">
            <select id="currencySelector" class="currency-selector" onchange="changeCurrency()">
                <option value="CNY">CNY - Yuan</option>
                <option value="XAF">XAF - CFA Franc</option>
                <option value="USD">USD - Dollar</option>
                <option value="GBP">GBP - Pound</option>
                <option value="EUR">EUR - Euro</option>
                <option value="NGN">NGN - Naira</option>
                <option value="JPY">JPY - Yen</option>
                <option value="INR">INR - Rupee</option>
            </select>
            <a onclick="showNotification('Wishlist coming soon!', 'info')"><i class="far fa-heart"></i></a>
            <a href="cart.jsp" style="position: relative;">
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

    <div class="container" id="mainContainer">
        <div class="hero-banner">
            <div class="hero-text">
                <h2>Welcome back, @<%= displayName %>! 👋</h2>
                <p>Discover amazing deals and exclusive offers just for you</p>
            </div>
            <div class="offer-badge">
                <div class="big">30% OFF</div>
                <div>Your First Order</div>
                <small>Code: WELCOME30</small>
            </div>
        </div>

        <div class="section-header">
            <h3>⚡ Flash Sale <span style="font-size:12px; color:#666;">Ends soon!</span></h3>
            <div class="timer" id="timer">Ending in: 23:59:59</div>
        </div>

        <div class="products-grid" id="productsGrid"></div>
    </div>

    <div class="footer">
        <div class="footer-grid">
            <div class="footer-section">
                <h4>ShopWithUs</h4>
                <a onclick="showNotification('About Us coming soon!', 'info')">About Us</a>
                <a onclick="showNotification('Careers coming soon!', 'info')">Careers</a>
                <a onclick="showNotification('Press coming soon!', 'info')">Press</a>
                <a onclick="showNotification('Sustainability coming soon!', 'info')">Sustainability</a>
            </div>
            <div class="footer-section">
                <h4>Customer Service</h4>
                <a onclick="showNotification('Contact Us coming soon!', 'info')">Contact Us</a>
                <a onclick="showNotification('Shipping Info coming soon!', 'info')">Shipping Info</a>
                <a onclick="showNotification('Returns & Refunds coming soon!', 'info')">Returns & Refunds</a>
                <a onclick="showNotification('FAQs coming soon!', 'info')">FAQs</a>
            </div>
            <div class="footer-section">
                <h4>My Account</h4>
                <a onclick="showNotification('My Orders coming soon!', 'info')">My Orders</a>
                <a onclick="showNotification('Wishlist coming soon!', 'info')">Wishlist</a>
                <a onclick="showNotification('Settings coming soon!', 'info')">Settings</a>
                <a onclick="showNotification('Promotions coming soon!', 'info')">Promotions</a>
            </div>
            <div class="footer-section">
                <h4>Follow Us</h4>
                <a href="#"><i class="fab fa-facebook"></i> Facebook</a>
                <a href="#"><i class="fab fa-instagram"></i> Instagram</a>
                <a href="#"><i class="fab fa-twitter"></i> Twitter</a>
                <a href="#"><i class="fab fa-pinterest"></i> Pinterest</a>
            </div>
        </div>
        <div class="payment-methods">
            <i class="fab fa-cc-visa"></i>
            <i class="fab fa-cc-mastercard"></i>
            <i class="fab fa-cc-amex"></i>
            <i class="fab fa-cc-paypal"></i>
            <i class="fab fa-alipay"></i>
            <i class="fab fa-weixin"></i>
        </div>
        <div class="copyright">
            © 2024 ShopWithUs — All rights reserved. Smarter Shopping Starts Here.
        </div>
    </div>

    <div id="productModal" class="modal">
        <div class="modal-content">
            <span class="modal-close" onclick="closeProductModal()">&times;</span>
            <div id="modalContent"></div>
        </div>
    </div>

    <script>
        var cart = [];
        var currentCategory = 'all';
        var currentSearchTerm = '';

        // Product database with categories
        var productsData = {
            1: {
                name: "Floral Summer Dress",
                price: 29.99, oldPrice: 49.99, rating: 4, reviews: 128,
                image: "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446",
                description: "Beautiful floral print summer dress perfect for warm days. Made with high-quality cotton fabric that is breathable and comfortable.",
                category: "women", stock: 50
            },
            2: {
                name: "Nike Running Shoes",
                price: 89.99, oldPrice: null, rating: 5, reviews: 342,
                image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
                description: "Premium running shoes with air cushion technology for maximum comfort. Lightweight design with breathable mesh upper.",
                category: "shoes", stock: 45
            },
            3: {
                name: "Smart Watch Series 8",
                price: 149.99, oldPrice: 199.99, rating: 4, reviews: 567,
                image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30",
                description: "Advanced smart watch with health tracking features including heart rate monitor, blood oxygen sensor, and sleep tracking.",
                category: "electronics", stock: 40
            },
            4: {
                name: "Wireless Headphones",
                price: 99.99, oldPrice: 149.99, rating: 4, reviews: 892,
                image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e",
                description: "Premium wireless headphones with active noise cancellation. 30-hour battery life with fast charging.",
                category: "electronics", stock: 75
            },
            5: {
                name: "Designer Handbag",
                price: 69.99, oldPrice: 89.99, rating: 4, reviews: 234,
                image: "https://images.unsplash.com/photo-1584917865442-de89df76afd3",
                description: "Elegant leather handbag perfect for daily use. Features multiple compartments, adjustable strap, and secure zipper closure.",
                category: "bags", stock: 25
            },
            6: {
                name: "Premium Makeup Kit",
                price: 39.99, oldPrice: null, rating: 4, reviews: 456,
                image: "https://images.unsplash.com/photo-1596462502278-27bfdc403348",
                description: "Complete makeup kit with 12 eyeshadow colors, 3 lipsticks, blush, and brushes. High-quality pigments that last all day.",
                category: "beauty", stock: 100
            },
            7: {
                name: "Men Casual Shirt",
                price: 45.99, oldPrice: 69.99, rating: 4, reviews: 189,
                image: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c",
                description: "Comfortable casual shirt for men. Made from premium cotton fabric. Perfect for daily wear.",
                category: "men", stock: 60
            },
            8: {
                name: "Kids Toy Set",
                price: 24.99, oldPrice: 34.99, rating: 4, reviews: 78,
                image: "https://images.unsplash.com/photo-1566576912321-d58ddd7a6088",
                description: "Educational toy set for kids. Includes multiple pieces for creative play.",
                category: "kids", stock: 45
            },
            9: {
                name: "Home Decor Lamp",
                price: 49.99, oldPrice: 79.99, rating: 4, reviews: 234,
                image: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c",
                description: "Modern LED desk lamp with adjustable brightness. Perfect for home or office.",
                category: "home", stock: 30
            },
            10: {
                name: "Sports Bag",
                price: 54.99, oldPrice: 79.99, rating: 4, reviews: 156,
                image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62",
                description: "Durable sports bag with multiple compartments. Perfect for gym and travel.",
                category: "sports", stock: 55
            }
        };

        // Exchange rates
        var exchangeRates = {
            CNY: 7.24, XAF: 605, USD: 1, GBP: 0.78, EUR: 0.92,
            JPY: 150, INR: 83, NGN: 1500
        };

        var currentCurrency = localStorage.getItem('currency') || 'CNY';

        function getFilteredProducts() {
            var filtered = [];
            for (var id in productsData) {
                var product = productsData[id];
                if (currentCategory !== 'all' && product.category !== currentCategory) {
                    continue;
                }
                if (currentSearchTerm !== '') {
                    var searchLower = currentSearchTerm.toLowerCase();
                    if (product.name.toLowerCase().indexOf(searchLower) === -1 &&
                        product.description.toLowerCase().indexOf(searchLower) === -1) {
                        continue;
                    }
                }
                filtered.push({ id: id, data: product });
            }
            return filtered;
        }

        function displayProducts() {
            var filteredProducts = getFilteredProducts();
            var grid = document.getElementById('productsGrid');
            var symbol = getCurrencySymbol();

            if (filteredProducts.length === 0) {
                grid.innerHTML = '<div style="text-align:center; padding:50px; background:white; border-radius:12px;"><i class="fas fa-search" style="font-size:48px; color:#ccc;"></i><h3 style="margin-top:20px;">No products found</h3><p>Try adjusting your search or category filter</p></div>';
                return;
            }

            var html = '';
            for (var i = 0; i < filteredProducts.length; i++) {
                var p = filteredProducts[i].data;
                var id = filteredProducts[i].id;
                var hasSale = p.oldPrice && p.oldPrice > p.price;
                var stars = '';
                for (var s = 0; s < p.rating; s++) stars += '★';
                for (var s = p.rating; s < 5; s++) stars += '☆';
                var discount = hasSale ? Math.round((1 - p.price/p.oldPrice) * 100) : 0;

                html += '<div class="product-card" onclick="openProductModal(' + id + ')">';
                if (hasSale) html += '<div class="product-badge">-' + discount + '%</div>';
                html += '<img src="' + p.image + '" class="product-image" onerror="this.src=\'https://via.placeholder.com/200x200\'">';
                html += '<div class="product-info">';
                html += '<div class="product-title">' + p.name + '</div>';
                html += '<div class="product-price">';
                html += '<span class="current-price">' + symbol + ' ' + convertPrice(p.price) + '</span>';
                if (p.oldPrice) html += '<span class="old-price">' + symbol + ' ' + convertPrice(p.oldPrice) + '</span>';
                html += '</div>';
                html += '<div class="product-rating">' + stars + ' (' + p.reviews + ')</div>';
                html += '<button class="add-to-cart" onclick="event.stopPropagation(); addToCart(' + id + ', \'' + p.name + '\', ' + p.price + ')">Add to Cart</button>';
                html += '</div></div>';
            }
            grid.innerHTML = html;
        }

        function filterByCategory(category, element) {
            currentCategory = category;
            currentSearchTerm = '';
            document.getElementById('searchInput').value = '';

            var allLinks = document.querySelectorAll('.category-bar a');
            for (var i = 0; i < allLinks.length; i++) {
                allLinks[i].classList.remove('active');
            }
            if (element) element.classList.add('active');

            displayProducts();
            showNotification('Showing ' + category + ' products', 'info');
        }

        function searchProducts() {
            currentSearchTerm = document.getElementById('searchInput').value;
            displayProducts();
            if (currentSearchTerm) {
                showNotification('Searching for: ' + currentSearchTerm, 'info');
            }
        }

        function resetFilters() {
            currentCategory = 'all';
            currentSearchTerm = '';
            document.getElementById('searchInput').value = '';

            var allLinks = document.querySelectorAll('.category-bar a');
            for (var i = 0; i < allLinks.length; i++) {
                allLinks[i].classList.remove('active');
            }
            document.querySelector('.category-bar a').classList.add('active');

            displayProducts();
            showNotification('All products shown', 'info');
        }

        function convertPrice(priceUSD) {
            var rate = exchangeRates[currentCurrency];
            if (!rate) rate = exchangeRates['CNY'];
            return (priceUSD * rate).toFixed(2);
        }

        function getCurrencySymbol() {
            var symbols = { CNY: '¥', XAF: 'FCFA', USD: '$', GBP: '£', EUR: '€', JPY: '¥', INR: '₹', NGN: '₦' };
            return symbols[currentCurrency] || '¥';
        }

        function changeCurrency() {
            var selector = document.getElementById('currencySelector');
            currentCurrency = selector.value;
            localStorage.setItem('currency', currentCurrency);
            displayProducts();
            showNotification('Currency changed to ' + currentCurrency, 'info');
        }

        function openProductModal(id) {
            var product = productsData[id];
            if (!product) return;
            var symbol = getCurrencySymbol();
            var stars = '';
            for (var s = 0; s < product.rating; s++) stars += '★';
            for (var s = product.rating; s < 5; s++) stars += '☆';

            var modalContent = document.getElementById('modalContent');
            modalContent.innerHTML = '<div class="product-detail"><div class="product-detail-image"><img src="' + product.image + '" onerror="this.src=\'https://via.placeholder.com/400\'"></div><div class="product-detail-info"><h1 class="product-detail-title">' + product.name + '</h1><div class="product-detail-rating">' + stars + ' (' + product.reviews + ' reviews)</div><div class="product-detail-price">' + symbol + ' ' + convertPrice(product.price) + (product.oldPrice ? '<span class="product-detail-old-price">' + symbol + ' ' + convertPrice(product.oldPrice) + '</span>' : '') + '</div><p class="product-detail-description">' + product.description + '</p><div class="product-detail-meta"><p><strong>Category:</strong> ' + product.category.toUpperCase() + '</p><p><strong>Availability:</strong> <span style="color:#0b4f3c;">In Stock (' + product.stock + ' units)</span></p></div><div class="detail-quantity"><button class="detail-quantity-btn" onclick="decreaseModalQuantity()">-</button><input type="number" id="modalQuantity" class="detail-quantity-input" value="1" min="1" max="' + product.stock + '"><button class="detail-quantity-btn" onclick="increaseModalQuantity(' + product.stock + ')">+</button></div><button class="detail-add-to-cart" onclick="addFromModal(' + id + ', \'' + product.name + '\', ' + product.price + ')">Add to Cart</button></div></div>';
            document.getElementById('mainContainer').classList.add('blurred');
            document.getElementById('productModal').classList.add('active');
        }

        function closeProductModal() {
            document.getElementById('mainContainer').classList.remove('blurred');
            document.getElementById('productModal').classList.remove('active');
        }

        function decreaseModalQuantity() {
            var qtyInput = document.getElementById('modalQuantity');
            if (qtyInput && parseInt(qtyInput.value) > 1) qtyInput.value = parseInt(qtyInput.value) - 1;
        }

        function increaseModalQuantity(maxStock) {
            var qtyInput = document.getElementById('modalQuantity');
            if (qtyInput && parseInt(qtyInput.value) < maxStock) qtyInput.value = parseInt(qtyInput.value) + 1;
        }

        function addFromModal(id, name, priceUSD) {
            var qtyInput = document.getElementById('modalQuantity');
            var quantity = qtyInput ? parseInt(qtyInput.value) : 1;
            addToCart(id, name, priceUSD, quantity);
            closeProductModal();
        }

        function addToCart(id, name, priceUSD, quantity) {
            quantity = quantity || 1;
            var found = false;
            for (var i = 0; i < cart.length; i++) {
                if (cart[i].id === id) {
                    cart[i].quantity += quantity;
                    found = true;
                    break;
                }
            }
            if (!found) {
                cart.push({ id: id, name: name, price: priceUSD, quantity: quantity, image: productsData[id].image });
            }
            updateCartCount();
            showNotification(name + ' added to cart!', 'success');
        }

        function loadCart() {
            var savedCart = localStorage.getItem('cart');
            if (savedCart) {
                try {
                    cart = JSON.parse(savedCart);
                } catch(e) {
                    cart = [];
                }
            }
            updateCartCount();
        }

        function updateCartCount() {
            var count = 0;
            for (var i = 0; i < cart.length; i++) {
                count += cart[i].quantity;
            }
            var cartCountSpan = document.getElementById('cartCount');
            if (cartCountSpan) cartCountSpan.innerHTML = count;
            localStorage.setItem('cart', JSON.stringify(cart));
        }

        function updateTimer() {
            var now = new Date();
            var end = new Date();
            end.setHours(23, 59, 59, 999);
            var diff = end - now;
            var h = Math.floor(diff / 3600000);
            var m = Math.floor((diff % 3600000) / 60000);
            var s = Math.floor((diff % 60000) / 1000);
            var timer = document.getElementById('timer');
            if (timer) timer.innerHTML = '⏰ Ending in: ' + (h<10?'0'+h:h) + ':' + (m<10?'0'+m:m) + ':' + (s<10?'0'+s:s);
        }

        function showNotification(message, type) {
            var n = document.createElement('div');
            var bg = type === 'error' ? '#dc2626' : (type === 'info' ? '#2196f3' : '#0b4f3c');
            n.style.cssText = 'position:fixed; bottom:20px; right:20px; background:' + bg + '; color:white; padding:12px 20px; border-radius:10px; z-index:2000; font-size:14px;';
            n.innerHTML = message;
            document.body.appendChild(n);
            setTimeout(function() { if(n && n.remove) n.remove(); }, 3000);
        }

        window.onclick = function(e) {
            var modal = document.getElementById('productModal');
            if (e.target === modal) closeProductModal();
        }

        function init() {
            loadCart();
            displayProducts();
            var currencySelector = document.getElementById('currencySelector');
            if (currencySelector) currencySelector.value = currentCurrency;
        }

        init();
        setInterval(updateTimer, 1000);
        updateTimer();
    </script>
</body>
</html>