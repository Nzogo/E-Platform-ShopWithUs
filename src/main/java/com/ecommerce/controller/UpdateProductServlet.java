package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/admin/updateProduct")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class UpdateProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return null;
        }
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
                fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
                return fileName;
            }
        }
        return null;
    }

    private String saveFile(Part filePart, String subDirectory) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + subDirectory;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String originalFileName = getFileName(filePart);
        String fileExtension = "";
        if (originalFileName != null && originalFileName.lastIndexOf(".") != -1) {
            fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        }

        String fileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + fileExtension;
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return "uploads/" + subDirectory + "/" + fileName;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("id"));

        Product existingProduct = productDAO.getProductById(productId);
        if (existingProduct == null) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-products.jsp?error=Product not found");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String discountPriceStr = request.getParameter("discountPrice");
        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
        String stockStr = request.getParameter("stock");
        String status = request.getParameter("status");

        Part image1Part = request.getPart("image1");
        Part image2Part = request.getPart("image2");
        Part image3Part = request.getPart("image3");

        String image1Path = saveFile(image1Part, "products");
        String image2Path = saveFile(image2Part, "products");
        String image3Path = saveFile(image3Part, "products");

        String image1Url = request.getParameter("image1_url");
        String image2Url = request.getParameter("image2_url");
        String image3Url = request.getParameter("image3_url");

        String finalImage1 = image1Path != null ? image1Path :
                (image1Url != null && !image1Url.isEmpty() ? image1Url : existingProduct.getImage1());
        String finalImage2 = image2Path != null ? image2Path :
                (image2Url != null && !image2Url.isEmpty() ? image2Url : existingProduct.getImage2());
        String finalImage3 = image3Path != null ? image3Path :
                (image3Url != null && !image3Url.isEmpty() ? image3Url : existingProduct.getImage3());

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/edit-product.jsp?id=" + productId + "&error=Name required");
            return;
        }

        double price = 0, discountPrice = 0;
        int stock = 0;

        try {
            price = Double.parseDouble(priceStr);
            if (discountPriceStr != null && !discountPriceStr.isEmpty()) {
                discountPrice = Double.parseDouble(discountPriceStr);
            }
            stock = Integer.parseInt(stockStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/edit-product.jsp?id=" + productId + "&error=Invalid number format");
            return;
        }

        Product product = new Product();
        product.setId(productId);
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setDiscountPrice(discountPrice);
        product.setCategory(category);
        product.setBrand(brand);
        product.setStock(stock);
        product.setStatus(status);
        product.setImage1(finalImage1);
        product.setImage2(finalImage2);
        product.setImage3(finalImage3);

        boolean success = productDAO.updateProduct(product);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-products.jsp?success=Product updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/edit-product.jsp?id=" + productId + "&error=Update failed");
        }
    }
}