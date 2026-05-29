<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - ShopWithUs</title>
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

        .cart-header {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .cart-header h1 {
            color: #333;
            font-size: 28px;
        }

        .cart-items {
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .cart-item {
            display: flex;
            padding: 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .cart-item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        .cart-item-details {
            flex: 2;
        }

        .cart-item-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .cart-item-price {
            color: #0b4f3c;
            font-weight: 700;
            font-size: 18px;
        }

        .cart-item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .quantity-input {
            width: 50px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 5px;
        }

        .cart-item-subtotal {
            min-width: 100px;
            text-align: right;
            font-weight: 700;
            font-size: 18px;
            color: #0b4f3c;
        }

        .remove-btn {
            background: #dc2626;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
            cursor: pointer;
        }

        .cart-summary {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
            text-align: right;
        }

        .cart-total {
            font-size: 24px;
            font-weight: 700;
            margin: 15px 0;
        }

        .checkout-btn {
            background: #0b4f3c;
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .empty-cart {
            text-align: center;
            padding: 60px;
            background: white;
            border-radius: 12px;
        }

        .empty-cart i {
            font-size: 80px;
            color: #ccc;
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
            .cart-item {
                flex-direction: column;
                text-align: center;
            }
            .cart-item-subtotal {
                text-align: center;
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
        <div class="cart-header">
            <h1><i class="fas fa-shopping-cart"></i> My Shopping Cart</h1>
        </div>

        <div id="cartContainer"></div>
    </div>

    <script>
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
            displayCart();
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

        function updateQuantity(index, change) {
            var newQuantity = cart[index].quantity + change;
            if (newQuantity < 1) {
                removeItem(index);
            } else {
                cart[index].quantity = newQuantity;
                updateCartCount();
                displayCart();
            }
        }

        function removeItem(index) {
            cart.splice(index, 1);
            updateCartCount();
            displayCart();
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

        function displayCart() {
            var container = document.getElementById('cartContainer');
            var symbol = getCurrencySymbol();

            if (cart.length === 0) {
                container.innerHTML = '<div class="empty-cart"><i class="fas fa-shopping-basket"></i><h2>Your cart is empty</h2><p>Add some products to your cart!</p><button class="checkout-btn" onclick="location.href=\'dashboard.jsp\'">Continue Shopping</button></div>';
                return;
            }

            var itemsHtml = '<div class="cart-items">';
            var totalUSD = 0;

            for (var i = 0; i < cart.length; i++) {
                var item = cart[i];
                var itemTotalUSD = item.price * item.quantity;
                var itemTotalConverted = convertPrice(itemTotalUSD);
                totalUSD += itemTotalUSD;

                itemsHtml += '<div class="cart-item">';
                itemsHtml += '<img src="' + (item.image || 'https://via.placeholder.com/100') + '" class="cart-item-image" onerror="this.src=\'https://via.placeholder.com/100\'">';
                itemsHtml += '<div class="cart-item-details">';
                itemsHtml += '<div class="cart-item-title">' + item.name + '</div>';
                itemsHtml += '<div class="cart-item-price">' + symbol + ' ' + convertPrice(item.price) + '</div>';
                itemsHtml += '</div>';
                itemsHtml += '<div class="cart-item-quantity">';
                itemsHtml += '<button class="quantity-btn" onclick="updateQuantity(' + i + ', -1)">-</button>';
                itemsHtml += '<span class="quantity-input">' + item.quantity + '</span>';
                itemsHtml += '<button class="quantity-btn" onclick="updateQuantity(' + i + ', 1)">+</button>';
                itemsHtml += '</div>';
                itemsHtml += '<div class="cart-item-subtotal">' + symbol + ' ' + itemTotalConverted + '</div>';
                itemsHtml += '<button class="remove-btn" onclick="removeItem(' + i + ')">Remove</button>';
                itemsHtml += '</div>';
            }

            var totalConverted = convertPrice(totalUSD);
            itemsHtml += '</div>';
            itemsHtml += '<div class="cart-summary">';
            itemsHtml += '<h3>Order Summary</h3>';
            itemsHtml += '<div class="cart-total">Total: ' + symbol + ' ' + totalConverted + '</div>';
            itemsHtml += '<button class="checkout-btn" onclick="checkout()">Proceed to Checkout</button>';
            itemsHtml += '</div>';

            container.innerHTML = itemsHtml;
        }

        function checkout() {
            alert('Checkout coming soon! Total: ' + getCurrencySymbol() + ' ' + convertPrice(getCartTotalUSD()));
        }

        function getCartTotalUSD() {
            var total = 0;
            for (var i = 0; i < cart.length; i++) {
                total += cart[i].price * cart[i].quantity;
            }
            return total;
        }

        function changeCurrency() {
            var selector = document.getElementById('currencySelector');
            currentCurrency = selector.value;
            localStorage.setItem('currency', currentCurrency);
            displayCart();
        }

        function setCurrencySelector() {
            var selector = document.getElementById('currencySelector');
            if (selector) selector.value = currentCurrency;
        }

        loadCart();
        setCurrencySelector();
    </script>
</body>
</html>