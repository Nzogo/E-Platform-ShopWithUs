<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.model.SliderImage" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"admin".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    SliderImage slider = (SliderImage) request.getAttribute("slider");
    if (slider == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=Slider not found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Slider - Admin</title>
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
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .current-image { margin-top: 10px; }
        .current-image img { width: 200px; height: 120px; object-fit: cover; border-radius: 8px; border: 2px solid #0b4f3c; }
        .image-preview { width: 200px; height: 120px; object-fit: cover; border-radius: 8px; margin-top: 10px; border: 2px solid #0b4f3c; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background: #0b4f3c; color: white; }
        .btn-primary:hover { background: #0a3d2e; transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; transform: translateY(-2px); }
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
            <a href="${pageContext.request.contextPath}/admin/manage-sliders.jsp" class="btn btn-secondary">
                <i class="fas fa-images"></i> Sliders
            </a>
        </div>

        <div class="card">
            <h1><i class="fas fa-edit"></i> Edit Slider</h1>
            <p class="subtitle">Update slider information</p>

            <form action="${pageContext.request.contextPath}/admin/slider" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= slider.getId() %>">

                <div class="form-group">
                    <label>Title *</label>
                    <input type="text" name="title" value="<%= slider.getTitle() %>" required>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="3"><%= slider.getDescription() != null ? slider.getDescription() : "" %></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Discount %</label>
                        <input type="number" name="discountPercent" value="<%= slider.getDiscountPercent() %>">
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select name="category">
                            <option value="all" <%= "all".equals(slider.getCategory()) ? "selected" : "" %>>All Categories</option>
                            <option value="women" <%= "women".equals(slider.getCategory()) ? "selected" : "" %>>Women</option>
                            <option value="men" <%= "men".equals(slider.getCategory()) ? "selected" : "" %>>Men</option>
                            <option value="shoes" <%= "shoes".equals(slider.getCategory()) ? "selected" : "" %>>Shoes</option>
                            <option value="bags" <%= "bags".equals(slider.getCategory()) ? "selected" : "" %>>Bags</option>
                            <option value="beauty" <%= "beauty".equals(slider.getCategory()) ? "selected" : "" %>>Beauty</option>
                            <option value="electronics" <%= "electronics".equals(slider.getCategory()) ? "selected" : "" %>>Electronics</option>
                            <option value="home" <%= "home".equals(slider.getCategory()) ? "selected" : "" %>>Home</option>
                            <option value="sports" <%= "sports".equals(slider.getCategory()) ? "selected" : "" %>>Sports</option>
                            <option value="kids" <%= "kids".equals(slider.getCategory()) ? "selected" : "" %>>Kids</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Button Text</label>
                        <input type="text" name="buttonText" value="<%= slider.getButtonText() != null ? slider.getButtonText() : "Shop Now" %>">
                    </div>
                    <div class="form-group">
                        <label>Button Link</label>
                        <input type="text" name="buttonLink" value="<%= slider.getButtonLink() != null ? slider.getButtonLink() : "#" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Display Order</label>
                        <input type="number" name="displayOrder" value="<%= slider.getDisplayOrder() %>">
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="active">
                            <option value="on" <%= slider.isActive() ? "selected" : "" %>>Active</option>
                            <option value="off" <%= !slider.isActive() ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Current Image</label>
                    <div class="current-image">
                        <img src="<%= request.getContextPath() %>/<%= slider.getImageUrl() %>" alt="Current" onerror="this.src='https://via.placeholder.com/200x120'">
                    </div>
                </div>

                <div class="form-group">
                    <label>New Image (leave empty to keep current)</label>
                    <input type="file" name="imageFile" accept="image/*" onchange="previewImage(this)">
                    <div id="imagePreview"></div>
                    <small>OR Image URL:</small>
                    <input type="text" name="imageUrl" placeholder="https://...">
                </div>

                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Update Slider</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-sliders.jsp" class="btn btn-secondary"><i class="fas fa-times"></i> Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        function previewImage(input) {
            var preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = '<img src="' + e.target.result + '" class="image-preview">';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.innerHTML = '';
            }
        }
    </script>
</body>
</html>