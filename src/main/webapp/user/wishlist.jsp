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
    <title>My Wishlist - ShopWithUs</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; }
        .top-bar { background: #0b4f3c; color: white; padding: 6px 0; text-align: center; font-size: 11px; }
        .navbar { background: white; padding: 12px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.08); flex-wrap: wrap; }
        .logo { font-size: 24px; font-weight: 800; color: #0b4f3c; text-decoration: none; cursor: pointer; }
        .nav-icons { display: flex; gap: 20px; align-items: center; }
        .nav-icons a { color: #333; text-decoration: none; font-size: 18px; cursor: pointer; }
        .cart-count { background: #ff6b6b; color: white; font-size: 10px; padding: 2px 5px; border-radius: 50%; margin-left: 5px; }
        .logout-btn { background: #dc2626; color: white !important; padding: 6px 15px; border-radius: 20px; font-size: 14px; }
        .currency-selector { padding: 6px 10px; border: 1px solid #ddd; border-radius: 8px; cursor: pointer; font-size: 13px; background: white; }
        .container { max-width: 1200px; margin: 40px auto; padding: 20px; }
        .wishlist-header { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; }
        .wishlist-header h1 { color: #333; font-size: 28px; }
        .wishlist-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 25px; }
        .wishlist-card { background: white; border-radius: 15px; overflow: hidden; transition: transform 0.3s; position: relative; }
        .wishlist-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .wishlist-image { width: 100%; height: 200px; object-fit: cover; cursor: pointer; }
        .wishlist-info { padding: 15px; }
        .wishlist-title { font-size: 16px; font-weight: 600; margin-bottom: 5px; cursor: pointer; }
        .wishlist-price { font-size: 18px; font-weight: 700; color: #0b4f3c; margin: 10px 0; }
        .wishlist-actions { display: flex; gap: 10px; }
        .add-to-cart-btn, .remove-btn { flex: 1; padding: 10px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; }
        .add-to-cart-btn { background: #0b4f3c; color: white; }
        .remove-btn { background: #dc2626; color: white; }
        .empty-wishlist { text-align: center; padding: 60px; background: white; border-radius: 12px; }
        .empty-wishlist i { font-size: 80px; color: #ccc; margin-bottom: 20px; }
        .continue-shop { background: #0b4f3c; color: white; border: none; padding: 12px 30px; border-radius: 8px; cursor: pointer; margin-top: 20px; font-size: 16px; }
        .back-btn { background: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; margin-bottom: 20px; }
        @media (max-width: 768px) { .navbar { padding: 15px 20px; } .container { margin-top: 20px; } }
    </style>
</head>
<body>
    <div class="top-bar">🚚 Free Shipping on orders $50+ | Free Returns | 24/7 Customer Support</div>
    <div class="navbar">
        <div class="logo" onclick="location.href='dashboard.jsp'">🛍️ ShopWithUs!</div>
        <div class="nav-icons">
            <select id="currencySelector" class="currency-selector" onchange="changeCurrency()">
                <option value="XAF">🇨🇲 XAF - CFA</option>
                <option value="USD">🇺🇸 USD - Dollar</option>
                <option value="CNY">🇨🇳 CNY - Yuan</option>
                <option value="EUR">🇪🇺 EUR - Euro</option>
                <option value="JPY">🇯🇵 JPY - Yen</option>
                <option value="AED">🇦🇪 AED - Dirham</option>
            </select>
            <a href="cart.jsp"><i class="fas fa-shopping-cart"></i> <span id="cartCount" class="cart-count">0</span></a>
            <a href="dashboard.jsp"><i class="fas fa-store"></i></a>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn">Logout</a>
        </div>
    </div>
    <div class="container">
        <button class="back-btn" onclick="location.href='dashboard.jsp'"><i class="fas fa-arrow-left"></i> Back to Shop</button>
        <div class="wishlist-header"><h1><i class="fas fa-heart"></i> My Wishlist</h1></div>
        <div id="wishlistContainer"></div>
    </div>
    <script>
        var wishlist = JSON.parse(localStorage.getItem('wishlist')) || [];
        var cart = JSON.parse(localStorage.getItem('cart')) || [];
        var exchangeRates = { USD:1, XAF:605, CNY:7.24, EUR:0.92, GBP:0.78, JPY:150, AED:3.67 };
        var currentCurrency = localStorage.getItem('currency') || 'XAF';
        function getSymbol() { var s = { USD:'$', XAF:'FCFA', CNY:'¥', EUR:'€', JPY:'¥', AED:'د.إ' }; return s[currentCurrency] || '$'; }
        function convertPrice(p) { var rate = exchangeRates[currentCurrency] || exchangeRates['XAF']; return (p * rate).toFixed(2); }
        function changeCurrency() { var s = document.getElementById('currencySelector'); currentCurrency = s.value; localStorage.setItem('currency', currentCurrency); displayWishlist(); }
        function displayWishlist() {
            var container = document.getElementById('wishlistContainer');
            var symbol = getSymbol();
            if (wishlist.length === 0) {
                container.innerHTML = '<div class="empty-wishlist"><i class="far fa-heart"></i><h2>Your wishlist is empty</h2><p>Save items you love to your wishlist!</p><button class="continue-shop" onclick="location.href=\'dashboard.jsp\'">Continue Shopping</button></div>';
                return;
            }
            var html = '<div class="wishlist-grid">';
            for (var i = 0; i < wishlist.length; i++) {
                var item = wishlist[i];
                html += '<div class="wishlist-card">';
                html += '<img src="' + (item.image || 'https://via.placeholder.com/250x200') + '" class="wishlist-image" onclick="viewProduct(' + item.id + ')">';
                html += '<div class="wishlist-info">';
                html += '<div class="wishlist-title" onclick="viewProduct(' + item.id + ')">' + item.name + '</div>';
                html += '<div class="wishlist-price">' + symbol + ' ' + convertPrice(item.price) + '</div>';
                html += '<div class="wishlist-actions">';
                html += '<button class="add-to-cart-btn" onclick="addToCart(' + item.id + ',\'' + item.name + '\',' + item.price + ')">Add to Cart</button>';
                html += '<button class="remove-btn" onclick="removeFromWishlist(' + item.id + ')">Remove</button>';
                html += '</div></div></div>';
            }
            html += '</div>';
            container.innerHTML = html;
            updateCartCount();
        }
        function addToCart(id, name, price) {
            var existing = cart.find(function(i) { return i.id == id; });
            if (existing) { existing.quantity++; } else { cart.push({id: id, name: name, price: price, quantity: 1}); }
            updateCartCount(); localStorage.setItem('cart', JSON.stringify(cart)); alert(name + ' added to cart!');
        }
        function removeFromWishlist(id) {
            wishlist = wishlist.filter(function(i) { return i.id != id; });
            localStorage.setItem('wishlist', JSON.stringify(wishlist)); displayWishlist(); alert('Removed from wishlist');
        }
        function viewProduct(id) { window.location.href = 'product.jsp?id=' + id; }
        function updateCartCount() { var count = 0; for (var i = 0; i < cart.length; i++) { count += cart[i].quantity; } document.getElementById('cartCount').innerHTML = count; }
        var selector = document.getElementById('currencySelector'); if (selector) selector.value = currentCurrency;
        displayWishlist();
    </script>
</body>
</html>