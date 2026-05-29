<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
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
            background: #f5f5f5;
        }

        /* Top Bar - Shein Style */
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

        /* Navbar */
        .navbar {
            background: white;
            padding: 12px 50px;
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
            color: white;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        .logout-btn:hover {
            background: #b91c1c;
            color: white;
        }

        /* Category Bar - Alibaba Style */
        .category-bar {
            background: white;
            padding: 10px 50px;
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
            padding: 5px 18px;
            color: #666;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
        }

        .category-bar a:hover {
            color: #0b4f3c;
        }

        /* Main Container */
        .container {
            margin-top: 140px;
            padding: 20px 50px;
        }

        /* Hero Banner - Shein Style */
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

        /* Flash Sale Section */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h3 {
            font-size: 20px;
            color: #333;
        }

        .timer {
            background: #ff6b6b;
            color: white;
            padding: 5px 15px;
            border-radius: 25px;
            font-size: 13px;
        }

        /* Product Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s;
            cursor: pointer;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
            z-index: 1;
        }

        .product-image {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .product-info {
            padding: 10px;
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

        .add-to-cart {
            width: 100%;
            padding: 8px;
            background: #0b4f3c;
            color: white;
            border: none;
            border-radius: 8px;
            margin-top: 8px;
            cursor: pointer;
            font-size: 12px;
        }

        /* Features Section - Alibaba Style */
        .features-section {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin: 40px 0;
            text-align: center;
        }

        .feature-item {
            background: white;
            padding: 20px;
            border-radius: 12px;
        }

        .feature-icon {
            font-size: 30px;
            margin-bottom: 10px;
        }

        .feature-title {
            font-weight: 600;
            font-size: 14px;
        }

        /* Footer */
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

        /* Responsive */
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
                margin-top: 180px;
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
    <!-- Top Bar -->
    <div class="top-bar">
        🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support
    </div>

    <!-- Navbar -->
    <div class="navbar">
        <a href="#" class="logo">🛍️ ShopWithUs!</a>

        <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search products...">
            <button onclick="searchProducts()"><i class="fas fa-search"></i></button>
        </div>

        <div class="nav-icons">
            <a href="#"><i class="far fa-heart"></i></a>
            <a href="#" style="position: relative;">
                <i class="fas fa-shopping-cart"></i>
                <span class="cart-count">0</span>
            </a>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Category Bar -->
    <div class="category-bar">
        <a href="#">All</a>
        <a href="#">Women</a>
        <a href="#">Men</a>
        <a href="#">Shoes</a>
        <a href="#">Bags</a>
        <a href="#">Beauty</a>
        <a href="#">Electronics</a>
        <a href="#">Home</a>
        <a href="#">Kids</a>
        <a href="#">Sports</a>
    </div>

    <!-- Main Container -->
    <div class="container">
        <!-- Hero Banner -->
        <div class="hero-banner">
            <div class="hero-text">
                <h2>Welcome back, @<%= displayName %>!</h2>
                <p>Discover amazing deals and exclusive offers just for you</p>
            </div>
            <div class="offer-badge">
                <div class="big">30% OFF</div>
                <div>Your First Order</div>
                <small>Code: WELCOME30</small>
            </div>
        </div>

        <!-- Flash Sale -->
        <div class="section-header">
            <h3>⚡ Flash Sale</h3>
            <div class="timer" id="timer">Ending in: 23:59:59</div>
        </div>

        <!-- Products Grid -->
        <div class="products-grid" id="productsGrid">
            <!-- Product 1 -->
            <div class="product-card">
                <div class="product-badge">-40%</div>
                <img src="https://images.unsplash.com/photo-1515372039744-b8f02a3ae446" class="product-image">
                <div class="product-info">
                    <div class="product-title">Floral Summer Dress</div>
                    <div class="product-price">
                        <span class="current-price">$29.99</span>
                        <span class="old-price">$49.99</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>

            <!-- Product 2 -->
            <div class="product-card">
                <img src="https://images.unsplash.com/photo-1542291026-7eec264c27ff" class="product-image">
                <div class="product-info">
                    <div class="product-title">Running Shoes</div>
                    <div class="product-price">
                        <span class="current-price">$89.99</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>

            <!-- Product 3 -->
            <div class="product-card">
                <div class="product-badge">Sale</div>
                <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30" class="product-image">
                <div class="product-info">
                    <div class="product-title">Smart Watch</div>
                    <div class="product-price">
                        <span class="current-price">$149.99</span>
                        <span class="old-price">$199.99</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>

            <!-- Product 4 -->
            <div class="product-card">
                <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e" class="product-image">
                <div class="product-info">
                    <div class="product-title">Wireless Headphones</div>
                    <div class="product-price">
                        <span class="current-price">$99.99</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>

            <!-- Product 5 -->
            <div class="product-card">
                <img src="https://images.unsplash.com/photo-1584917865442-de89df76afd3" class="product-image">
                <div class="product-info">
                    <div class="product-title">Leather Handbag</div>
                    <div class="product-price">
                        <span class="current-price">$69.99</span>
                        <span class="old-price">$89.99</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>

            <!-- Product 6 -->
            <div class="product-card">
                <div class="product-badge">New</div>
                <img src="https://images.unsplash.com/photo-1596462502278-27bfdc403348" class="product-image">
                <div class="product-info">
                    <div class="product-title">Makeup Kit</div>
                    <div class="product-price">
                        <span class="current-price">$39.99</span>
                    </div>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>
        </div>

        <!-- Features Section -->
        <div class="features-section">
            <div class="feature-item">
                <div class="feature-icon">🚚</div>
                <div class="feature-title">Free Shipping</div>
                <small>On orders $50+</small>
            </div>
            <div class="feature-item">
                <div class="feature-icon">🔒</div>
                <div class="feature-title">Secure Payment</div>
                <small>100% secure</small>
            </div>
            <div class="feature-item">
                <div class="feature-icon">↩️</div>
                <div class="feature-title">Easy Returns</div>
                <small>30 days return</small>
            </div>
            <div class="feature-item">
                <div class="feature-icon">💬</div>
                <div class="feature-title">24/7 Support</div>
                <small>Live chat</small>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <div class="footer-grid">
            <div class="footer-section">
                <h4>ShopWithUs</h4>
                <a href="#">About Us</a>
                <a href="#">Careers</a>
                <a href="#">Press</a>
            </div>
            <div class="footer-section">
                <h4>Customer Service</h4>
                <a href="#">Contact Us</a>
                <a href="#">Shipping Info</a>
                <a href="#">Returns</a>
                <a href="#">FAQs</a>
            </div>
            <div class="footer-section">
                <h4>My Account</h4>
                <a href="#">My Orders</a>
                <a href="#">Wishlist</a>
                <a href="#">Settings</a>
            </div>
            <div class="footer-section">
                <h4>Follow Us</h4>
                <a href="#"><i class="fab fa-facebook"></i> Facebook</a>
                <a href="#"><i class="fab fa-instagram"></i> Instagram</a>
                <a href="#"><i class="fab fa-twitter"></i> Twitter</a>
            </div>
        </div>
        <div class="copyright">
            © 2024 ShopWithUs — All rights reserved.
        </div>
    </div>

    <script>
        // Timer for flash sale
        function updateTimer() {
            const now = new Date();
            const endOfDay = new Date();
            endOfDay.setHours(23, 59, 59, 999);
            const diff = endOfDay - now;

            const hours = Math.floor(diff / 3600000);
            const minutes = Math.floor((diff % 3600000) / 60000);
            const seconds = Math.floor((diff % 60000) / 1000);

            const timerElement = document.getElementById('timer');
            if (timerElement) {
                timerElement.innerHTML = `Ending in: ${String(hours).padStart(2,'0')}:${String(minutes).padStart(2,'0')}:${String(seconds).padStart(2,'0')}`;
            }
        }

        setInterval(updateTimer, 1000);
        updateTimer();

        // Search function
        function searchProducts() {
            const searchTerm = document.getElementById('searchInput').value;
            if (searchTerm) {
                alert('Searching for: ' + searchTerm + '\n(Full search coming soon!)');
            }
        }

        // Add to cart
        document.querySelectorAll('.add-to-cart').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                alert('Item added to cart!');
            });
        });

        // Product click
        document.querySelectorAll('.product-card').forEach(card => {
            card.addEventListener('click', function() {
                alert('Product details coming soon!');
            });
        });
    </script>
</body>
</html>