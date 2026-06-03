<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.dao.SliderDAO" %>
<%@ page import="com.ecommerce.model.SliderImage" %>
<%@ page import="java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"admin".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    SliderDAO sliderDAO = new SliderDAO();
    List<SliderImage> sliders = sliderDAO.getAllActiveSliders();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Sliders - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #f0f2f5; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; }
        .header { background: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        h1 { font-size: 24px; color: #333; }
        .subtitle { color: #666; font-size: 13px; margin-top: 5px; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; transition: 0.3s; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background: #0b4f3c; color: white; }
        .btn-primary:hover { background: #0a3d2e; transform: translateY(-2px); }
        .btn-danger { background: #dc2626; color: white; }
        .btn-danger:hover { background: #b91c1c; transform: translateY(-2px); }
        .btn-warning { background: #f59e0b; color: white; }
        .btn-warning:hover { background: #d97706; transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; transform: translateY(-2px); }
        .btn-sm { padding: 5px 12px; font-size: 12px; margin: 0 3px; }
        .sliders-table { background: white; border-radius: 12px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; font-weight: 600; }
        .slider-image { width: 80px; height: 50px; object-fit: cover; border-radius: 8px; }
        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-block; }
        .status-active { background: #d1fae5; color: #065f46; }
        .status-inactive { background: #fee2e2; color: #991b1b; }
        .alert-success { background: #d1fae5; color: #065f46; padding: 12px 15px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background: #fee2e2; color: #991b1b; padding: 12px 15px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: white; border-radius: 12px; padding: 25px; width: 600px; max-width: 90%; max-height: 85vh; overflow-y: auto; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 13px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .image-preview { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; margin-top: 10px; border: 2px solid #0b4f3c; }
        .header-buttons { display: flex; gap: 10px; }
        @media (max-width: 768px) {
            .form-row { grid-template-columns: 1fr; gap: 0; }
            .header-buttons { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1><i class="fas fa-images"></i> Manage Hero Sliders</h1>
                <p class="subtitle">Add, edit or remove images that appear on the homepage</p>
            </div>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Add New Slider
                </button>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert-error"><i class="fas fa-exclamation-triangle"></i> Error: <%= error %></div>
        <% } %>

        <div class="sliders-table">
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Discount</th>
                        <th>Category</th>
                        <th>Order</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (sliders != null && !sliders.isEmpty()) { %>
                        <% for (SliderImage s : sliders) { %>
                            <tr>
                                <td><img src="<%= request.getContextPath() %>/<%= s.getImageUrl() %>" class="slider-image" onerror="this.src='https://via.placeholder.com/80x50'"></td>
                                <td><%= s.getTitle() %></td>
                                <td><%= s.getDiscountPercent() %>% OFF</td>
                                <td><%= s.getCategory() %></td>
                                <td><%= s.getDisplayOrder() %></td>
                                <td><span class="status-badge status-<%= s.isActive() ? "active" : "inactive" %>"><%= s.isActive() ? "Active" : "Inactive" %></span></td>
                                <td>
                                    <button class="btn btn-warning btn-sm" onclick="editSlider(<%= s.getId() %>)"><i class="fas fa-edit"></i> Edit</button>
                                    <button class="btn btn-danger btn-sm" onclick="deleteSlider(<%= s.getId() %>, '<%= s.getTitle() %>')"><i class="fas fa-trash"></i> Delete</button>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="7" style="text-align:center; padding:40px;">No sliders found. Click "Add New Slider" to get started.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Slider Modal -->
    <div id="sliderModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Add Slider</h3>
                <span onclick="closeModal()" style="font-size:28px; cursor:pointer;">&times;</span>
            </div>
            <form id="sliderForm" action="${pageContext.request.contextPath}/admin/slider" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="sliderId">

                <div class="form-group">
                    <label>Title *</label>
                    <input type="text" name="title" id="title" required>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" id="description" rows="2"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Discount %</label>
                        <input type="number" name="discountPercent" id="discountPercent" value="0">
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" id="category">
                            <option value="all">All Categories</option>
                            <option value="women">Women</option>
                            <option value="men">Men</option>
                            <option value="shoes">Shoes</option>
                            <option value="bags">Bags</option>
                            <option value="beauty">Beauty</option>
                            <option value="electronics">Electronics</option>
                            <option value="home">Home</option>
                            <option value="sports">Sports</option>
                            <option value="kids">Kids</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Button Text</label>
                        <input type="text" name="buttonText" id="buttonText" placeholder="Shop Now">
                    </div>
                    <div class="form-group">
                        <label>Button Link</label>
                        <input type="text" name="buttonLink" id="buttonLink" placeholder="#">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Display Order</label>
                        <input type="number" name="displayOrder" id="displayOrder" value="0">
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="active" id="active">
                            <option value="on">Active</option>
                            <option value="off">Inactive</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Image</label>
                    <input type="file" name="imageFile" id="imageFile" accept="image/*" onchange="previewImage(this)">
                    <div id="imagePreview"></div>
                    <small>OR Image URL:</small>
                    <input type="text" name="imageUrl" id="imageUrl" placeholder="https://...">
                </div>
                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">Save Slider</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        var contextPath = '${pageContext.request.contextPath}';

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

        function openAddModal() {
            document.getElementById('modalTitle').innerText = 'Add Slider';
            document.getElementById('formAction').value = 'add';
            document.getElementById('sliderForm').reset();
            document.getElementById('imagePreview').innerHTML = '';
            document.getElementById('sliderModal').style.display = 'flex';
        }

        function editSlider(id) {
            window.location.href = contextPath + '/admin/slider?action=edit&id=' + id;
        }

        function deleteSlider(id, name) {
            if (confirm('Delete slider "' + name + '"? This action cannot be undone.')) {
                window.location.href = contextPath + '/admin/slider?action=delete&id=' + id;
            }
        }

        function closeModal() {
            document.getElementById('sliderModal').style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target === document.getElementById('sliderModal')) {
                closeModal();
            }
        }
    </script>
</body>
</html>