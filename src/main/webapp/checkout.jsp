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
    <title>Checkout - ShopWithUs</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; }
        .navbar { background: white; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.08); flex-wrap: wrap; }
        .logo { font-size: 24px; font-weight: 800; color: #0b4f3c; text-decoration: none; cursor: pointer; }
        .container { max-width: 1200px; margin: 40px auto; padding: 20px; }
        .checkout-container { display: flex; gap: 30px; flex-wrap: wrap; }
        .delivery-form { flex: 2; background: white; border-radius: 20px; padding: 30px; }
        .order-summary { flex: 1; background: white; border-radius: 20px; padding: 30px; position: sticky; top: 20px; height: fit-content; }
        h2 { margin-bottom: 20px; color: #333; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #555; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .order-item { display: flex; gap: 15px; padding: 15px 0; border-bottom: 1px solid #eee; }
        .order-item-image { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
        .order-item-details { flex: 1; }
        .order-item-title { font-weight: 600; }
        .order-item-price { color: #0b4f3c; font-weight: 600; }
        .order-total { margin-top: 20px; padding-top: 20px; border-top: 2px solid #eee; text-align: right; }
        .order-total h3 { font-size: 24px; color: #0b4f3c; }
        .place-order-btn { width: 100%; padding: 15px; background: #0b4f3c; color: white; border: none; border-radius: 10px; font-size: 18px; font-weight: 600; cursor: pointer; margin-top: 20px; }
        .place-order-btn:hover { background: #0a3d2e; }
        .back-btn { background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; margin-bottom: 20px; }
        @media (max-width: 768px) { .form-row { grid-template-columns: 1fr; } .navbar { padding: 15px 20px; } }
    </style>
</head>
<body>
    <div class="navbar"><div class="logo" onclick="location.href='user/dashboard.jsp'">🛍️ ShopWithUs!</div></div>
    <div class="container">
        <button class="back-btn" onclick="history.back()"><i class="fas fa-arrow-left"></i> Back to Cart</button>
        <div class="checkout-container">
            <div class="delivery-form">
                <h2><i class="fas fa-truck"></i> Delivery Information</h2>
                <form id="checkoutForm">
                    <div class="form-row">
                        <div class="form-group"><label>Full Name *</label><input type="text" id="fullName" value="<%= user.getName() %>" required></div>
                        <div class="form-group"><label>Email *</label><input type="email" id="email" value="<%= user.getEmail() %>" required></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Phone Number *</label><input type="tel" id="phone" placeholder="Your phone number" required></div>
                        <div class="form-group"><label>Alternative Phone</label><input type="tel" id="altPhone" placeholder="Alternative contact"></div>
                    </div>
                    <div class="form-group"><label>Street Address *</label><input type="text" id="address" placeholder="House number and street name" required></div>
                    <div class="form-row">
                        <div class="form-group"><label>City *</label><input type="text" id="city" placeholder="City" required></div>
                        <div class="form-group"><label>State/Province *</label><input type="text" id="state" placeholder="State/Province" required></div>
                    </div>
                    <div class="form-row">
                        <div class="form-group"><label>Postal Code</label><input type="text" id="postalCode" placeholder="Postal code"></div>
                        <div class="form-group"><label>Country *</label><select id="country"><option value="Cameroon">Cameroon</option><option value="China">China</option><option value="USA">USA</option><option value="UK">UK</option><option value="France">France</option><option value="Nigeria">Nigeria</option></select></div>
                    </div>
                    <div class="form-group"><label>Delivery Instructions (Optional)</label><textarea id="instructions" rows="3" placeholder="Special instructions for delivery"></textarea></div>
                    <div class="form-group"><label>Payment Method *</label><select id="paymentMethod"><option value="cash">Cash on Delivery</option><option value="card">Credit/Debit Card</option><option value="mobile">Mobile Money</option><option value="paypal">PayPal</option></select></div>
                </form>
            </div>
            <div class="order-summary">
                <h2><i class="fas fa-receipt"></i> Order Summary</h2>
                <div id="orderItems"></div>
                <div class="order-total"><h3>Total: <span id="orderTotal">$0.00</span></h3></div>
                <button class="place-order-btn" onclick="placeOrder()"><i class="fas fa-check-circle"></i> Place Order</button>
                <p style="font-size: 12px; color: #666; margin-top: 15px; text-align: center;">By placing your order, you agree to our Terms and Conditions.</p>
            </div>
        </div>
    </div>
    <script>
        var cart = JSON.parse(localStorage.getItem('cart')) || [];
        var exchangeRates = { USD:1, XAF:605, CNY:7.24, GBP:0.78, EUR:0.92, NGN:1500 };
        var currentCurrency = localStorage.getItem('currency') || 'CNY';
        function getSymbol() { var s={CNY:'¥',XAF:'FCFA',USD:'$',GBP:'£',EUR:'€',NGN:'₦'}; return s[currentCurrency]||'¥'; }
        function convertPrice(p) { var rate=exchangeRates[currentCurrency]||1; return (p*rate).toFixed(2); }
        function displayOrderSummary() { var container=document.getElementById('orderItems'); var total=0; var html=''; for(var i=0;i<cart.length;i++){ var item=cart[i]; var itemTotal=item.price*item.quantity; total+=itemTotal; html+='<div class="order-item"><img src="'+(item.image||'https://via.placeholder.com/60')+'" class="order-item-image"><div class="order-item-details"><div class="order-item-title">'+item.name+'</div><div class="order-item-price">'+getSymbol()+' '+convertPrice(item.price)+' x '+item.quantity+'</div></div><div>'+getSymbol()+' '+convertPrice(itemTotal)+'</div></div>'; } container.innerHTML=html; document.getElementById('orderTotal').innerHTML=getSymbol()+' '+convertPrice(total); }
        function placeOrder(){ var name=document.getElementById('fullName').value; var email=document.getElementById('email').value; var phone=document.getElementById('phone').value; var address=document.getElementById('address').value; var city=document.getElementById('city').value; var state=document.getElementById('state').value; var country=document.getElementById('country').value; var payment=document.getElementById('paymentMethod').value; if(!name||!email||!phone||!address||!city||!state){ alert('Please fill in all required fields'); return; } if(cart.length===0){ alert('Your cart is empty'); return; } alert('Order placed successfully!\n\nThank you for your order!\nWe will contact you shortly.\n\nOrder details will be sent to: '+email); localStorage.removeItem('cart'); window.location.href='user/dashboard.jsp'; }
        displayOrderSummary();
    </script>
</body>
</html>