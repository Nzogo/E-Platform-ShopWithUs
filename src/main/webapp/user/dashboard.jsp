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
        }

        .category-bar a:hover {
            color: #0b4f3c;
        }

        .container {
            margin-top: 145px;
            padding: 20px 40px;
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
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
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

        .recommended-title {
            font-size: 20px;
            font-weight: 600;
            margin: 30px 0 20px;
            color: #333;
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
                margin-top: 195px;
            }
            .features-section {
                grid-template-columns: repeat(2, 1fr);
            }
            .footer-grid {
                grid-template-columns: 1fr;
                text-align: center;
            }
            .hero-text h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <div class="top-bar">
        🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support | Secure Payments
    </div>

    <div class="navbar">
        <div class="logo" onclick="location.reload()">🛍️ ShopWithUs!</div>

        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search products...">
            <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
        </div>

        <div class="nav-icons">
            <a onclick="showNotification('Wishlist coming soon!', 'info')"><i class="far fa-heart"></i></a>
            <a onclick="viewCart()" style="position: relative;">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count" id="cartCount">0</span>
            </a>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <div class="category-bar">
        <a onclick="filterCategory('all')">All</a>
        <a onclick="filterCategory('women')">Women</a>
        <a onclick="filterCategory('men')">Men</a>
        <a onclick="filterCategory('shoes')">Shoes</a>
        <a onclick="filterCategory('bags')">Bags</a>
        <a onclick="filterCategory('beauty')">Beauty</a>
        <a onclick="filterCategory('electronics')">Electronics</a>
        <a onclick="filterCategory('home')">Home</a>
        <a onclick="filterCategory('kids')">Kids</a>
        <a onclick="filterCategory('sports')">Sports</a>
    </div>

    <div class="container">
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

        <div class="products-grid" id="productsGrid">
            <!-- Product 1 -->
            <div class="product-card" onclick="viewProduct(1)">
                <div class="product-badge">-40%</div>
                <img src="https://images.unsplash.com/photo-1515372039744-b8f02a3ae446" class="product-image" onerror="this.src='https://via.placeholder.com/200x200'">
                <div class="product-info">
                    <div class="product-title">Floral Summer Dress</div>
                    <div class="product-price">
                        <span class="current-price">$29.99</span>
                        <span class="old-price">$49.99</span>
                    </div>
                    <div class="product-rating">★★★★☆ (128)</div>
                    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(1, 'Floral Summer Dress', 29.99)">Add to Cart</button>
                </div>
            </div>

            <div class="product-card" onclick="viewProduct(2)">
                <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff" class="product-image" onerror="this.src='https://via.placeholder.com/200x200'">
                <div class="product-info">
                    <div class="product-title">Nike Running Shoes</div>
                    <div class="product-price">
                        <span class="current-price">$89.99</span>
                    </div>
                    <div class="product-rating">★★★★★ (342)</div>
                    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(2, 'Nike Running Shoes', 89.99)">Add to Cart</button>
                </div>
            </div>

            <div class="product-card" onclick="viewProduct(3)">
                <div class="product-badge hot">Hot</div>
                <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30" class="product-image" onerror="this.src='https://via.placeholder.com/200x200'">
                <div class="product-info">
                    <div class="product-title">Smart Watch Series 8</div>
                    <div class="product-price">
                        <span class="current-price">$149.99</span>
                        <span class="old-price">$199.99</span>
                    </div>
                    <div class="product-rating">★★★★☆ (567)</div>
                    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(3, 'Smart Watch', 149.99)">Add to Cart</button>
                </div>
            </div>

            <div class="product-card" onclick="viewProduct(4)">
                <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e" class="product-image" onerror="this.src='https://via.placeholder.com/200x200'">
                <div class="product-info">
                    <div class="product-title">Wireless Headphones</div>
                    <div class="product-price">
                        <span class="current-price">$99.99</span>
                        <span class="old-price">$149.99</span>
                    </div>
                    <div class="product-rating">★★★★☆ (892)</div>
                    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(4, 'Wireless Headphones', 99.99)">Add to Cart</button>
                </div>
            </div>

            <div class="product-card" onclick="viewProduct(5)">
                <img src="https://images.unsplash.com/photo-1584917865442-de89df76afd3" class="product-image" onerror="this.src='https://via.placeholder.com/200x200'">
                <div class="product-info">
                    <div class="product-title">Designer Handbag</div>
                    <div class="product-price">
                        <span class="current-price">$69.99</span>
                        <span class="old-price">$89.99</span>
                    </div>
                    <div class="product-rating">★★★★☆ (234)</div>
                    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(5, 'Designer Handbag', 69.99)">Add to Cart</button>
                </div>
            </div>

            <div class="product-card" onclick="viewProduct(6)">
                <div class="product-badge">New</div>
                <img src="https://images.unsplash.com/photo-1596462502278-27bfdc403348" class="product-image" onerror="this.src='https://via.placeholder.com/200x200'">
                <div class="product-info">
                    <div class="product-title">Premium Makeup Kit</div>
                    <div class="product-price">
                        <span class="current-price">$39.99</span>
                    </div>
                    <div class="product-rating">★★★★☆ (456)</div>
                    <button class="add-to-cart" onclick="event.stopPropagation(); addToCart(6, 'Premium Makeup Kit', 39.99)">Add to Cart</button>
                </div>
            </div>
        </div>

        <div class="features-section">
            <div class="feature-item">
                <div class="feature-icon">🚚</div>
                <div class="feature-title">Free Shipping</div>
                <div class="feature-desc">On orders $50+</div>
            </div>
            <div class="feature-item">
                <div class="feature-icon">🔒</div>
                <div class="feature-title">Secure Payment</div>
                <div class="feature-desc">100% secure checkout</div>
            </div>
            <div class="feature-item">
                <div class="feature-icon">↩️</div>
                <div class="feature-title">Easy Returns</div>
                <div class="feature-desc">30 days return policy</div>
            </div>
            <div class="feature-item">
                <div class="feature-icon">💬</div>
                <div class="feature-title">24/7 Support</div>
                <div class="feature-desc">Live chat available</div>
            </div>
        </div>

        <div class="recommended-title">✨ Recommended For You</div>
        <div class="products-grid" id="recommendedGrid"></div>
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

    <script>
        var cart = [];

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
            document.getElementById('cartCount').innerHTML = count;
            localStorage.setItem('cart', JSON.stringify(cart));
        }

        function addToCart(id, name, price) {
            var found = false;
            for (var i = 0; i < cart.length; i++) {
                if (cart[i].id === id) {
                    cart[i].quantity++;
                    found = true;
                    break;
                }
            }
            if (!found) {
                cart.push({ id: id, name: name, price: price, quantity: 1 });
            }
            updateCartCount();
            showNotification(name + ' added to cart!', 'success');
        }

        function viewCart() {
            if (cart.length === 0) {
                showNotification('Your cart is empty', 'info');
            } else {
                var message = 'Cart Items:\n';
                var total = 0;
                for (var i = 0; i < cart.length; i++) {
                    var item = cart[i];
                    var itemTotal = item.price * item.quantity;
                    message += item.name + ' x' + item.quantity + ' - $' + itemTotal.toFixed(2) + '\n';
                    total += itemTotal;
                }
                message += '\nTotal: $' + total.toFixed(2);
                alert(message);
            }
        }

        function viewProduct(id) {
            showNotification('Product details coming soon! Product ID: ' + id, 'info');
        }

        function filterCategory(category) {
            showNotification('Showing ' + category + ' products', 'info');
        }

        function searchProducts() {
            var searchTerm = document.getElementById('searchInput').value;
            if (searchTerm) {
                showNotification('Searching for: ' + searchTerm, 'info');
            }
        }

        function updateTimer() {
            var now = new Date();
            var endOfDay = new Date();
            endOfDay.setHours(23, 59, 59, 999);
            var diff = endOfDay - now;

            var hours = Math.floor(diff / 3600000);
            var minutes = Math.floor((diff % 3600000) / 60000);
            var seconds = Math.floor((diff % 60000) / 1000);

            var hoursStr = (hours < 10) ? '0' + hours : '' + hours;
            var minutesStr = (minutes < 10) ? '0' + minutes : '' + minutes;
            var secondsStr = (seconds < 10) ? '0' + seconds : '' + seconds;

            var timerElement = document.getElementById('timer');
            if (timerElement) {
                timerElement.innerHTML = '⏰ Ending in: ' + hoursStr + ':' + minutesStr + ':' + secondsStr;
            }
        }

        function showNotification(message, type) {
            var notification = document.createElement('div');
            var bgColor = '#0b4f3c';
            if (type === 'error') bgColor = '#dc2626';
            else if (type === 'info') bgColor = '#2196f3';

            notification.style.cssText = 'position: fixed; bottom: 20px; right: 20px; background: ' + bgColor + '; color: white; padding: 12px 20px; border-radius: 10px; z-index: 2000; font-size: 14px;';
            notification.innerHTML = message;
            document.body.appendChild(notification);

            setTimeout(function() {
                if (notification && notification.remove) {
                    notification.remove();
                }
            }, 3000);
        }

        loadCart();
        setInterval(updateTimer, 1000);
        updateTimer();
    </script>
</body>
</html>