<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"admin".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ShopWithUs</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; }
        .sidebar { position: fixed; left: 0; top: 0; width: 260px; height: 100%; background: #0b4f3c; color: white; padding: 20px 0; }
        .sidebar-header { text-align: center; padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-header h3 { margin-top: 10px; }
        .sidebar-menu { list-style: none; padding: 0; margin-top: 20px; }
        .sidebar-menu li { padding: 12px 25px; cursor: pointer; transition: 0.3s; }
        .sidebar-menu li:hover, .sidebar-menu li.active { background: rgba(255,255,255,0.1); border-left: 4px solid white; }
        .sidebar-menu li i { width: 25px; margin-right: 10px; }
        .main-content { margin-left: 260px; padding: 20px; }
        .top-bar { background: white; padding: 15px 25px; border-radius: 10px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-size: 24px; font-weight: 600; color: #333; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; text-align: center; }
        .stat-card h3 { font-size: 32px; color: #0b4f3c; }
        .content-panel { background: white; border-radius: 12px; padding: 25px; display: none; }
        .content-panel.active { display: block; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; font-weight: 600; }
        .btn { padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; margin: 0 3px; }
        .btn-primary { background: #0b4f3c; color: white; }
        .btn-warning { background: #f59e0b; color: white; }
        .btn-danger { background: #dc2626; color: white; }
        .btn-success { background: #10b981; color: white; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: white; border-radius: 12px; max-width: 600px; width: 90%; padding: 25px; max-height: 80vh; overflow-y: auto; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; }
        .product-image { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        @media (max-width: 768px) { .sidebar { left: -260px; } .main-content { margin-left: 0; } }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-store" style="font-size: 40px;"></i><h3>Admin Panel</h3></div>
        <ul class="sidebar-menu">
            <li onclick="showPanel('dashboard')" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</li>
            <li onclick="showPanel('products')"><i class="fas fa-box"></i> Products</li>
            <li onclick="showPanel('orders')"><i class="fas fa-shopping-cart"></i> Orders</li>
            <li onclick="showPanel('users')"><i class="fas fa-users"></i> Users</li>
        </ul>
    </div>
    <div class="main-content">
        <div class="top-bar"><h2 class="page-title" id="pageTitle">Dashboard</h2><a href="${pageContext.request.contextPath}/user/dashboard.jsp" style="color:#0b4f3c;"><i class="fas fa-store"></i> View Store</a></div>

        <div id="dashboardPanel" class="content-panel active">
            <div class="stats-grid">
                <div class="stat-card"><h3 id="totalProducts">0</h3><p>Total Products</p></div>
                <div class="stat-card"><h3 id="totalOrders">0</h3><p>Total Orders</p></div>
                <div class="stat-card"><h3 id="totalUsers">0</h3><p>Total Users</p></div>
                <div class="stat-card"><h3 id="lowStock">0</h3><p>Low Stock Items</p></div>
            </div>
        </div>

        <div id="productsPanel" class="content-panel">
            <button class="btn btn-primary" onclick="openProductModal()" style="margin-bottom:15px;"><i class="fas fa-plus"></i> Add Product</button>
            <div style="overflow-x:auto;"><table id="productsTable"><thead><tr><th>ID</th><th>Image</th><th>Name</th><th>Category</th><th>Price</th><th>Stock</th><th>Status</th><th>Actions</th></tr></thead><tbody id="productsTableBody"></tbody></table></div>
        </div>

        <div id="ordersPanel" class="content-panel"><div style="text-align:center; padding:50px;"><i class="fas fa-shopping-cart" style="font-size:48px; color:#ccc;"></i><h3>Orders Management Coming Soon</h3></div></div>
        <div id="usersPanel" class="content-panel"><div style="text-align:center; padding:50px;"><i class="fas fa-users" style="font-size:48px; color:#ccc;"></i><h3>User Management Coming Soon</h3></div></div>
    </div>

    <div id="productModal" class="modal"><div class="modal-content"><h3 id="modalTitle">Add Product</h3><form id="productForm"><input type="hidden" id="productId"><div class="form-group"><label>Product Name</label><input type="text" id="productName" required></div><div class="form-group"><label>Description</label><textarea id="productDescription" rows="3"></textarea></div><div class="form-group"><label>Category</label><input type="text" id="productCategory" required></div><div class="form-group"><label>Brand</label><input type="text" id="productBrand"></div><div class="form-group"><label>Price</label><input type="number" step="0.01" id="productPrice" required></div><div class="form-group"><label>Discount Price</label><input type="number" step="0.01" id="productDiscountPrice"></div><div class="form-group"><label>Stock</label><input type="number" id="productStock" required></div><div class="form-group"><label>Status</label><select id="productStatus"><option value="in-stock">In Stock</option><option value="out-of-stock">Out of Stock</option><option value="limited">Limited</option><option value="coming-soon">Coming Soon</option></select></div><div class="form-group"><label>Image URL</label><input type="text" id="productImage1"></div><div class="form-group"><button type="submit" class="btn btn-primary">Save</button><button type="button" class="btn btn-danger" onclick="closeProductModal()" style="margin-left:10px;">Cancel</button></div></form></div></div>

    <script>
        var products = [];
        function showPanel(panel){ document.querySelectorAll('.content-panel').forEach(p=>p.classList.remove('active')); document.getElementById(panel+'Panel').classList.add('active'); document.getElementById('pageTitle').innerText=panel.charAt(0).toUpperCase()+panel.slice(1); if(panel==='products') loadProducts(); if(panel==='dashboard') loadStats(); }
        function loadProducts(){ fetch('${pageContext.request.contextPath}/products?ajax=1').then(r=>r.json()).then(data=>{ products=data; var html=''; data.forEach(p=>{ html+='<tr><td>'+p.id+'</td><td><img src="'+(p.image1||'https://via.placeholder.com/50')+'" class="product-image"></td><td>'+p.name+'</td><td>'+(p.category||'-')+'</td><td>$'+p.price+'</td><td>'+p.stock+'</td><td>'+p.status+'</td><td><button class="btn btn-warning" onclick="editProduct('+p.id+')"><i class="fas fa-edit"></i></button> <button class="btn btn-danger" onclick="deleteProduct('+p.id+')"><i class="fas fa-trash"></i></button></td></tr>'; }); document.getElementById('productsTableBody').innerHTML=html; }); }
        function loadStats(){ fetch('${pageContext.request.contextPath}/products?count=1').then(r=>r.json()).then(data=>{ document.getElementById('totalProducts').innerText=data.total||0; document.getElementById('totalOrders').innerText=0; document.getElementById('totalUsers').innerText=0; document.getElementById('lowStock').innerText=0; }); }
        function openProductModal(){ document.getElementById('modalTitle').innerText='Add Product'; document.getElementById('productForm').reset(); document.getElementById('productId').value=''; document.getElementById('productModal').style.display='flex'; }
        function closeProductModal(){ document.getElementById('productModal').style.display='none'; }
        function editProduct(id){ var p=products.find(x=>x.id==id); if(p){ document.getElementById('modalTitle').innerText='Edit Product'; document.getElementById('productId').value=p.id; document.getElementById('productName').value=p.name; document.getElementById('productDescription').value=p.description||''; document.getElementById('productCategory').value=p.category||''; document.getElementById('productBrand').value=p.brand||''; document.getElementById('productPrice').value=p.price; document.getElementById('productDiscountPrice').value=p.discountPrice||''; document.getElementById('productStock').value=p.stock; document.getElementById('productStatus').value=p.status||'in-stock'; document.getElementById('productImage1').value=p.image1||''; document.getElementById('productModal').style.display='flex'; } }
        function deleteProduct(id){ if(confirm('Delete this product?')){ fetch('${pageContext.request.contextPath}/deleteProduct?id='+id,{method:'DELETE'}).then(()=>loadProducts()); } }
        document.getElementById('productForm').addEventListener('submit',function(e){ e.preventDefault(); var product={id:document.getElementById('productId').value,name:document.getElementById('productName').value,description:document.getElementById('productDescription').value,category:document.getElementById('productCategory').value,brand:document.getElementById('productBrand').value,price:parseFloat(document.getElementById('productPrice').value),discountPrice:parseFloat(document.getElementById('productDiscountPrice').value)||0,stock:parseInt(document.getElementById('productStock').value),status:document.getElementById('productStatus').value,image1:document.getElementById('productImage1').value}; var method=product.id?'PUT':'POST'; var url=product.id?'${pageContext.request.contextPath}/updateProduct':'${pageContext.request.contextPath}/addProduct'; fetch(url,{method:method,headers:{'Content-Type':'application/json'},body:JSON.stringify(product)}).then(()=>{closeProductModal(); loadProducts();}); });
        loadStats(); loadProducts();
    </script>
</body>
</html>