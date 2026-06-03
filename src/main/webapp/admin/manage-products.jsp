<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="com.ecommerce.dao.ProductDAO" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"admin".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/user/login.jsp");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.getAllProducts();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Admin</title>
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
        .products-table { background: white; border-radius: 12px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        th { background: #f8f9fa; font-weight: 600; }
        .product-image { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; display: inline-block; }
        .status-in-stock { background: #d1fae5; color: #065f46; }
        .status-out-of-stock { background: #fee2e2; color: #991b1b; }
        .status-limited { background: #fed7aa; color: #92400e; }
        .status-coming-soon { background: #e0e7ff; color: #3730a3; }
        .alert-success { background: #d1fae5; color: #065f46; padding: 12px 15px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background: #fee2e2; color: #991b1b; padding: 12px 15px; border-radius: 8px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: white; border-radius: 12px; padding: 25px; width: 550px; max-width: 90%; max-height: 85vh; overflow-y: auto; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 13px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        .form-group input[type="file"] { padding: 5px; }
        .image-preview { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; margin-top: 5px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .action-buttons { display: flex; gap: 5px; flex-wrap: wrap; }
        .header-buttons { display: flex; gap: 10px; }
        @media (max-width: 768px) {
            .form-row { grid-template-columns: 1fr; gap: 0; }
            .action-buttons { flex-direction: column; }
            .header-buttons { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1><i class="fas fa-box"></i> Product Management</h1>
                <p class="subtitle">Add, edit or remove products from your store</p>
            </div>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Add New Product
                </button>
            </div>
        </div>

        <% if (success != null) { %>
            <div class="alert-success"><i class="fas fa-check-circle"></i> <%= success %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="alert-error"><i class="fas fa-exclamation-triangle"></i> Error: <%= error %></div>
        <% } %>

        <div class="products-table">
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Stock</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products != null && !products.isEmpty()) { %>
                        <% for (Product p : products) { %>
                            <tr>
                                <td>
                                    <img src="<%= request.getContextPath() %>/<%= p.getImage1() != null && !p.getImage1().isEmpty() ? p.getImage1() : "uploads/products/placeholder.jpg" %>"
                                         class="product-image"
                                         onerror="this.src='https://via.placeholder.com/50'">
                                </td>
                                <td><%= p.getName() %></td>
                                <td><%= p.getCategory() != null ? p.getCategory() : "-" %></td>
                                <td>$<%= String.format("%.2f", p.getPrice()) %></td>
                                <td><%= p.getDiscountPrice() > 0 ? "$"+String.format("%.2f", p.getDiscountPrice()) : "-" %></td>
                                <td><%= p.getStock() %></td>
                                <td>
                                    <span class="status-badge status-<%= p.getStatus() != null ? p.getStatus().replace("-", "") : "in-stock" %>">
                                        <%= p.getStatus() != null ? p.getStatus() : "in-stock" %>
                                    </span>
                                </td>
                                <td class="action-buttons">
                                    <button class="btn btn-warning btn-sm" onclick="editProduct(<%= p.getId() %>)">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button class="btn btn-danger btn-sm" onclick="deleteProduct(<%= p.getId() %>, '<%= p.getName() %>')">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                        <% } %>
                    <% } else { %>
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 40px;">
                                <i class="fas fa-box-open" style="font-size: 48px; color: #ccc;"></i>
                                <p style="margin-top: 10px; color: #666;">No products found. Click "Add New Product" to get started.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div id="productModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Add Product</h3>
                <span onclick="closeModal()" style="font-size:28px; cursor:pointer;">&times;</span>
            </div>
            <form id="productForm" action="${pageContext.request.contextPath}/admin/addProduct" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label>Product Name *</label>
                    <input type="text" name="name" id="name" required>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" id="description" rows="3"></textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Price *</label>
                        <input type="number" step="0.01" name="price" id="price" required>
                    </div>
                    <div class="form-group">
                        <label>Discount Price</label>
                        <input type="number" step="0.01" name="discountPrice" id="discountPrice">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Category *</label>
                        <select name="category" id="category" required>
                            <option value="">Select Category</option>
                            <option value="women">Women</option>
                            <option value="men">Men</option>
                            <option value="shoes">Shoes</option>
                            <option value="bags">Bags</option>
                            <option value="beauty">Beauty</option>
                            <option value="electronics">Electronics</option>
                            <option value="home">Home</option>
                            <option value="kids">Kids</option>
                            <option value="sports">Sports</option>
                            <option value="gaming">Gaming & Consoles</option>
                            <option value="fitness">Fitness & Sportswear</option>
                            <option value="luxury">Luxury Bags, Jewelry & Shoes</option>
                            <option value="toys">Toys & Games</option>
                            <option value="phones">Phones & Gadgets</option>
                            <option value="kitchen">Kitchen</option>
                            <option value="OTHER">+ Add New Category...</option>
                        </select>
                        <input type="text" id="customCategory" name="customCategory" placeholder="Enter new category name" style="display:none; margin-top:10px;">
                    </div>
                    <div class="form-group">
                        <label>Brand</label>
                        <input type="text" name="brand" id="brand">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Stock *</label>
                        <input type="number" name="stock" id="stock" required>
                    </div>
                    <div class="form-group">
                        <label>Status *</label>
                        <select name="status" id="status">
                            <option value="in-stock">In Stock</option>
                            <option value="out-of-stock">Out of Stock</option>
                            <option value="limited">Limited</option>
                            <option value="coming-soon">Coming Soon</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Main Image</label>
                    <input type="file" name="image1" id="image1" accept="image/*" onchange="previewImage(this, 'preview1')">
                    <div id="preview1"></div>
                    <small>OR URL:</small>
                    <input type="text" name="image1_url" id="image1_url" placeholder="https://...">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Image 2</label>
                        <input type="file" name="image2" id="image2" accept="image/*" onchange="previewImage(this, 'preview2')">
                        <div id="preview2"></div>
                        <input type="text" name="image2_url" id="image2_url" placeholder="URL">
                    </div>
                    <div class="form-group">
                        <label>Image 3</label>
                        <input type="file" name="image3" id="image3" accept="image/*" onchange="previewImage(this, 'preview3')">
                        <div id="preview3"></div>
                        <input type="text" name="image3_url" id="image3_url" placeholder="URL">
                    </div>
                </div>
                <div style="display: flex; gap: 10px; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">Save Product</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        var contextPath = '${pageContext.request.contextPath}';

        function previewImage(input, previewId) {
            var preview = document.getElementById(previewId);
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

        function toggleCategoryInput() {
            var select = document.getElementById('category');
            var customInput = document.getElementById('customCategory');
            if (select.value === 'OTHER') {
                customInput.style.display = 'block';
                customInput.required = true;
            } else {
                customInput.style.display = 'none';
                customInput.required = false;
            }
        }

        document.getElementById('category').addEventListener('change', toggleCategoryInput);

        document.getElementById('productForm').onsubmit = function() {
            var select = document.getElementById('category');
            var customInput = document.getElementById('customCategory');
            if (select.value === 'OTHER') {
                var hiddenInput = document.createElement('input');
                hiddenInput.type = 'hidden';
                hiddenInput.name = 'category';
                hiddenInput.value = customInput.value.toLowerCase().replace(/ /g, '-');
                this.appendChild(hiddenInput);
                select.disabled = true;
            }
            return true;
        };

        function openAddModal() {
            document.getElementById('modalTitle').innerText = 'Add Product';
            document.getElementById('productForm').reset();
            document.getElementById('preview1').innerHTML = '';
            document.getElementById('preview2').innerHTML = '';
            document.getElementById('preview3').innerHTML = '';
            document.getElementById('customCategory').style.display = 'none';
            document.getElementById('category').disabled = false;
            document.getElementById('productModal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('productModal').style.display = 'none';
        }

        function editProduct(id) {
            window.location.href = contextPath + '/admin/edit-product.jsp?id=' + id;
        }

        function deleteProduct(id, name) {
            if (confirm('Are you sure you want to delete "' + name + '"? This action cannot be undone.')) {
                window.location.href = contextPath + '/admin/deleteProduct?id=' + id;
            }
        }

        window.onclick = function(event) {
            var modal = document.getElementById('productModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>