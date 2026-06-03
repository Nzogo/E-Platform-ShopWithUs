<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="com.ecommerce.model.Product" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"admin".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    int productId = Integer.parseInt(request.getParameter("id"));
    ProductDAO productDAO = new ProductDAO();
    Product product = productDAO.getProductById(productId);

    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-products.jsp?error=Product not found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .card { background: white; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        h1 { font-size: 24px; color: #333; margin-bottom: 5px; }
        .subtitle { color: #666; font-size: 14px; margin-bottom: 25px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 13px; color: #333; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #0b4f3c; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .image-preview { display: flex; gap: 10px; margin-top: 10px; flex-wrap: wrap; }
        .image-preview img { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 2px solid #0b4f3c; }
        .current-images { font-size: 12px; color: #666; margin-top: 5px; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background: #0b4f3c; color: white; }
        .btn-primary:hover { background: #0a3d2e; transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; transform: translateY(-2px); }
        .btn-danger { background: #dc2626; color: white; }
        .btn-danger:hover { background: #b91c1c; transform: translateY(-2px); }
        .header-buttons { display: flex; gap: 10px; margin-bottom: 20px; justify-content: flex-end; }
        @media (max-width: 768px) { .form-row { grid-template-columns: 1fr; gap: 0; } }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-buttons">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/manage-products.jsp" class="btn btn-secondary">
                <i class="fas fa-box"></i> Products
            </a>
        </div>

        <div class="card">
            <h1><i class="fas fa-edit"></i> Edit Product</h1>
            <p class="subtitle">Update product information</p>

            <%
                String error = request.getParameter("error");
                if (error != null) {
                    out.println("<div style='background:#fee2e2; color:#991b1b; padding:12px; border-radius:8px; margin-bottom:20px;'><i class='fas fa-exclamation-triangle'></i> Error: " + error + "</div>");
                }
            %>

            <form action="${pageContext.request.contextPath}/admin/updateProduct" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="<%= product.getId() %>">

                <div class="form-group">
                    <label>Product Name *</label>
                    <input type="text" name="name" value="<%= product.getName() %>" required>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="4"><%= product.getDescription() != null ? product.getDescription() : "" %></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Price *</label>
                        <input type="number" step="0.01" name="price" value="<%= product.getPrice() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Discount Price</label>
                        <input type="number" step="0.01" name="discountPrice" value="<%= product.getDiscountPrice() %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="category" required>
                            <option value="women" <%= "women".equals(product.getCategory()) ? "selected" : "" %>>Women</option>
                            <option value="men" <%= "men".equals(product.getCategory()) ? "selected" : "" %>>Men</option>
                            <option value="shoes" <%= "shoes".equals(product.getCategory()) ? "selected" : "" %>>Shoes</option>
                            <option value="bags" <%= "bags".equals(product.getCategory()) ? "selected" : "" %>>Bags</option>
                            <option value="beauty" <%= "beauty".equals(product.getCategory()) ? "selected" : "" %>>Beauty</option>
                            <option value="electronics" <%= "electronics".equals(product.getCategory()) ? "selected" : "" %>>Electronics</option>
                            <option value="home" <%= "home".equals(product.getCategory()) ? "selected" : "" %>>Home</option>
                            <option value="kids" <%= "kids".equals(product.getCategory()) ? "selected" : "" %>>Kids</option>
                            <option value="sports" <%= "sports".equals(product.getCategory()) ? "selected" : "" %>>Sports</option>
                            <option value="gaming" <%= "gaming".equals(product.getCategory()) ? "selected" : "" %>>Gaming & Consoles</option>
                            <option value="fitness" <%= "fitness".equals(product.getCategory()) ? "selected" : "" %>>Fitness & Sportswear</option>
                            <option value="luxury" <%= "luxury".equals(product.getCategory()) ? "selected" : "" %>>Luxury Bags, Jewelry & Shoes</option>
                            <option value="toys" <%= "toys".equals(product.getCategory()) ? "selected" : "" %>>Toys & Games</option>
                            <option value="phones" <%= "phones".equals(product.getCategory()) ? "selected" : "" %>>Phones & Gadgets</option>
                            <option value="kitchen" <%= "kitchen".equals(product.getCategory()) ? "selected" : "" %>>Kitchen</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Brand</label>
                        <input type="text" name="brand" value="<%= product.getBrand() != null ? product.getBrand() : "" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Stock *</label>
                        <input type="number" name="stock" value="<%= product.getStock() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Status *</label>
                        <select name="status">
                            <option value="in-stock" <%= "in-stock".equals(product.getStatus()) ? "selected" : "" %>>In Stock</option>
                            <option value="out-of-stock" <%= "out-of-stock".equals(product.getStatus()) ? "selected" : "" %>>Out of Stock</option>
                            <option value="limited" <%= "limited".equals(product.getStatus()) ? "selected" : "" %>>Limited</option>
                            <option value="coming-soon" <%= "coming-soon".equals(product.getStatus()) ? "selected" : "" %>>Coming Soon</option>
                        </select>
                    </div>
                </div>

                <!-- Current Images -->
                <div class="form-group">
                    <label>Current Images</label>
                    <div class="image-preview">
                        <% if (product.getImage1() != null && !product.getImage1().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= product.getImage1() %>" alt="Image 1">
                        <% } %>
                        <% if (product.getImage2() != null && !product.getImage2().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= product.getImage2() %>" alt="Image 2">
                        <% } %>
                        <% if (product.getImage3() != null && !product.getImage3().isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= product.getImage3() %>" alt="Image 3">
                        <% } %>
                    </div>
                </div>

                <!-- New Images -->
                <div class="form-group">
                    <label>Main Image (upload new to replace)</label>
                    <input type="file" name="image1" accept="image/*">
                    <div class="current-images">Current: <%= product.getImage1() != null ? product.getImage1() : "No image" %></div>
                    <small>OR URL:</small>
                    <input type="text" name="image1_url" placeholder="https://...">
                </div>

                <div class="form-group">
                    <label>Image 2</label>
                    <input type="file" name="image2" accept="image/*">
                    <div class="current-images">Current: <%= product.getImage2() != null ? product.getImage2() : "No image" %></div>
                    <input type="text" name="image2_url" placeholder="https://...">
                </div>

                <div class="form-group">
                    <label>Image 3</label>
                    <input type="file" name="image3" accept="image/*">
                    <div class="current-images">Current: <%= product.getImage3() != null ? product.getImage3() : "No image" %></div>
                    <input type="text" name="image3_url" placeholder="https://...">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Product</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-products.jsp" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>