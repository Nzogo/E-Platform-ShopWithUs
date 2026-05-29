<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }
    String productId = request.getParameter("id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - ShopWithUs</title>
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

        .navbar {
            background: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            flex-wrap: wrap;
        }

        .logo {
            font-size: 24px;
            font-weight: 800;
            color: #0b4f3c;
            text-decoration: none;
            cursor: pointer;
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
            cursor: pointer;
        }

        .cart-count {
            background: #ff6b6b;
            color: white;
            font-size: 10px;
            padding: 2px 5px;
            border-radius: 50%;
            margin-left: 5px;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }

        .product-details {
            background: white;
            border-radius: 20px;
            padding: 30px;
            display: flex;
            gap: 40px;
            flex-wrap: wrap;
        }

        .product-image-section {
            flex: 1;
            min-width: 300px;
        }

        .product-main-image {
            width: 100%;
            border-radius: 15px;
        }

        .product-info-section {
            flex: 1;
        }

        .product-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .product-rating {
            color: #ffc107;
            margin-bottom: 15px;
        }

        .product-price {
            font-size: 32px;
            font-weight: 700;
            color: #0b4f3c;
            margin-bottom: 10px;
        }

        .product-old-price {
            font-size: 20px;
            color: #999;
            text-decoration: line-through;
            margin-left: 10px;
        }

        .product-description {
            color: #666;
            line-height: 1.6;
            margin: 20px 0;
        }

        .product-meta {
            padding: 20px 0;
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
        }

        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 20px 0;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
        }

        .add-to-cart-btn {
            background: #0b4f3c;
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
        }

        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            margin-bottom: 20px;
        }

        .currency-selector {
            margin-right: 20px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 15px 20px;
            }
            .product-details {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo" onclick="location.href='dashboard.jsp'">🛍️ ShopWithUs!</div>
        <div class="nav-icons">
            <select id="currencySelector" class="currency-selector" onchange="changeCurrency()">
                <option value="USD">USD $</option>
                <option value="EUR">EUR €</option>
                <option value="GBP">GBP £</option>
                <option value="CNY">CNY ¥</option>
                <option value="NGN">NGN ₦</option>
            </select>
            <a href="cart.jsp"><i class="fas fa-shopping-cart"></i> <span id="cartCount" class="cart-count">0</span></a>
            <a href="dashboard.jsp">Shop</a>
            <a href="${pageContext.request.contextPath}/login?action=logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <button class="back-btn" onclick="history.back()"><i class="fas fa-arrow-left"></i> Back</button>

        <div class="product-details" id="productDetails">
            <div style="text-align:center; padding:50px;">Loading product details...</div>
        </div>
    </div>

    <script>
        var products = {
            1: { name: "Floral Summer Dress", price: 29.99, oldPrice: 49.99, rating: 4, reviews: 128, image: "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446", description: "Beautiful floral print summer dress perfect for warm days. Made with high-quality cotton fabric that is breathable and comfortable. Features a flattering fit with adjustable straps and side pockets. Perfect for casual outings, beach days, or summer parties." },
            2: { name: "Nike Running Shoes", price: 89.99, oldPrice: null, rating: 5, reviews: 342, image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff", description: "Premium running shoes with air cushion technology for maximum comfort. Lightweight design with breathable mesh upper. Perfect for daily running, gym workouts, or casual wear. Durable rubber sole provides excellent traction." },
            3: { name: "Smart Watch Series 8", price: 149.99, oldPrice: 199.99, rating: 4, reviews: 567, image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30", description: "Advanced smart watch with health tracking features including heart rate monitor, blood oxygen sensor, and sleep tracking. GPS enabled, water resistant, with 5-day battery life. Compatible with iOS and Android." },
            4: { name: "Wireless Headphones", price: 99.99, oldPrice: 149.99, rating: 4, reviews: 892, image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e", description: "Premium wireless headphones with active noise cancellation. 30-hour battery life with fast charging. Comfortable over-ear design with soft memory foam ear cushions. Perfect for travel, work, or daily use." },
            5: { name: "Designer Handbag", price: 69.99, oldPrice: 89.99, rating: 4, reviews: 234, image: "https://images.unsplash.com/photo-1584917865442-de89df76afd3", description: "Elegant leather handbag perfect for daily use. Features multiple compartments, adjustable strap, and secure zipper closure. Available in multiple colors. Perfect for work, shopping, or travel." },
            6: { name: "Premium Makeup Kit", price: 39.99, oldPrice: null, rating: 4, reviews: 456, image: "https://images.unsplash.com/photo-1596462502278-27bfdc403348", description: "Complete makeup kit with 12 eyeshadow colors, 3 lipsticks, blush, and brushes. High-quality pigments that last all day. Perfect for beginners or professionals. Cruelty-free and hypoallergenic." }
        };

        var exchangeRates = {
            USD: 1,
            EUR: 0.92,
            GBP: 0.78,
            CNY: 7.24,
            NGN: 1500
        };

        var currentCurrency = localStorage.getItem('currency') || 'USD';
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
            var cartCountSpan = document.getElementById('cartCount');
            if (cartCountSpan) cartCountSpan.innerHTML = count;
        }

        function convertPrice(priceUSD) {
            var rate = exchangeRates[currentCurrency];
            if (!rate) rate = 1;
            return (priceUSD * rate).toFixed(2);
        }

        function getCurrencySymbol() {
            var symbols = { USD: '$', EUR: '€', GBP: '£', CNY: '¥', NGN: '₦' };
            return symbols[currentCurrency] || '$';
        }

        function displayProduct() {
            var urlParams = new URLSearchParams(window.location.search);
            var productId = urlParams.get('id');
            var product = products[productId];

            if (!product) {
                document.getElementById('productDetails').innerHTML = '<div style="text-align:center; padding:50px;">Product not found</div>';
                return;
            }

            var symbol = getCurrencySymbol();
            var stars = '';
            for (var s = 0; s < product.rating; s++) stars += '★';
            for (var s = product.rating; s < 5; s++) stars += '☆';

            var html = '<div class="product-image-section">';
            html += '<img src="' + product.image + '" class="product-main-image" onerror="this.src=\'https://via.placeholder.com/400\'">';
            html += '</div>';
            html += '<div class="product-info-section">';
            html += '<h1 class="product-title">' + product.name + '</h1>';
            html += '<div class="product-rating">' + stars + ' (' + product.reviews + ' reviews)</div>';
            html += '<div class="product-price">' + symbol + ' ' + convertPrice(product.price);
            if (product.oldPrice) html += '<span class="product-old-price">' + symbol + ' ' + convertPrice(product.oldPrice) + '</span>';
            html += '</div>';
            html += '<p class="product-description">' + product.description + '</p>';
            html += '<div class="product-meta">';
            html += '<p><strong>Category:</strong> Fashion</p>';
            html += '<p><strong>Availability:</strong> <span style="color:#0b4f3c;">In Stock</span></p>';
            html += '</div>';
            html += '<div class="quantity-selector">';
            html += '<button class="quantity-btn" onclick="decreaseQuantity()">-</button>';
            html += '<input type="number" id="quantity" class="quantity-input" value="1" min="1">';
            html += '<button class="quantity-btn" onclick="increaseQuantity()">+</button>';
            html += '</div>';
            html += '<button class="add-to-cart-btn" onclick="addToCart(' + productId + ', \'' + product.name + '\', ' + product.price + ')">Add to Cart</button>';
            html += '</div>';

            document.getElementById('productDetails').innerHTML = html;
        }

        function decreaseQuantity() {
            var qtyInput = document.getElementById('quantity');
            var val = parseInt(qtyInput.value);
            if (val > 1) qtyInput.value = val - 1;
        }

        function increaseQuantity() {
            var qtyInput = document.getElementById('quantity');
            var val = parseInt(qtyInput.value);
            qtyInput.value = val + 1;
        }

        function addToCart(id, name, price) {
            var quantity = parseInt(document.getElementById('quantity').value);
            var found = false;
            for (var i = 0; i < cart.length; i++) {
                if (cart[i].id === id) {
                    cart[i].quantity += quantity;
                    found = true;
                    break;
                }
            }
            if (!found) {
                cart.push({ id: id, name: name, price: price, quantity: quantity, image: products[id] ? products[id].image : '' });
            }
            updateCartCount();
            localStorage.setItem('cart', JSON.stringify(cart));
            alert(name + ' added to cart!');
        }

        function changeCurrency() {
            var selector = document.getElementById('currencySelector');
            currentCurrency = selector.value;
            localStorage.setItem('currency', currentCurrency);
            displayProduct();
        }

        function setCurrencySelector() {
            var selector = document.getElementById('currencySelector');
            if (selector) selector.value = currentCurrency;
        }

        loadCart();
        setCurrencySelector();
        displayProduct();
    </script>
</body>
</html>