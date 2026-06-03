package com.ecommerce.controller;

import com.ecommerce.dao.SliderDAO;
import com.ecommerce.model.SliderImage;
import com.ecommerce.model.User;
import com.google.gson.Gson;
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

@WebServlet("/admin/slider")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class SliderServlet extends HttpServlet {

    private SliderDAO sliderDAO = new SliderDAO();
    private Gson gson = new Gson();

    // Tomcat 7 compatible - get file name from content-disposition
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

    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf("."));
    }

    private String saveImage(Part filePart) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "sliders";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String originalFileName = getFileName(filePart);
        String fileExtension = getFileExtension(originalFileName);
        String fileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + fileExtension;
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        return "uploads/sliders/" + fileName;
    }

    // Get all sliders for admin (including inactive)
    private java.util.List<SliderImage> getAllSlidersForAdmin() {
        String sql = "SELECT * FROM slider_images ORDER BY display_order ASC, id ASC";
        java.util.List<SliderImage> sliders = new java.util.ArrayList<>();
        try (java.sql.Connection conn = com.ecommerce.database.DBConnection.getConnection();
             java.sql.Statement stmt = conn.createStatement();
             java.sql.ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                sliders.add(extractSliderFromResultSet(rs));
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return sliders;
    }

    private SliderImage extractSliderFromResultSet(java.sql.ResultSet rs) throws java.sql.SQLException {
        SliderImage slider = new SliderImage();
        slider.setId(rs.getInt("id"));
        slider.setTitle(rs.getString("title"));
        slider.setDescription(rs.getString("description"));
        slider.setButtonText(rs.getString("button_text"));
        slider.setButtonLink(rs.getString("button_link"));
        slider.setDiscountPercent(rs.getInt("discount_percent"));
        slider.setCategory(rs.getString("category"));
        slider.setImageUrl(rs.getString("image_url"));
        slider.setDisplayOrder(rs.getInt("display_order"));
        slider.setActive(rs.getBoolean("active"));
        return slider;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // If admin, show admin page
        if (user != null && "admin".equals(user.getRole())) {
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                SliderImage slider = sliderDAO.getSliderById(id);
                request.setAttribute("slider", slider);
                request.getRequestDispatcher("/admin/edit-slider.jsp").forward(request, response);
                return;
            } else if ("list".equals(action)) {
                java.util.List<SliderImage> sliders = getAllSlidersForAdmin();
                request.setAttribute("sliders", sliders);
                request.getRequestDispatcher("/admin/manage-sliders.jsp").forward(request, response);
                return;
            }
        }

        // Public API - return JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        java.util.List<SliderImage> sliders = sliderDAO.getAllActiveSliders();
        response.getWriter().print(gson.toJson(sliders));
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

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String buttonText = request.getParameter("buttonText");
            String buttonLink = request.getParameter("buttonLink");
            String discountPercentStr = request.getParameter("discountPercent");
            String category = request.getParameter("category");
            String displayOrderStr = request.getParameter("displayOrder");

            // Handle file upload
            Part imagePart = request.getPart("imageFile");
            String savedImagePath = saveImage(imagePart);
            String imageUrl = request.getParameter("imageUrl");

            String finalImageUrl = savedImagePath;
            if (finalImageUrl == null || finalImageUrl.trim().isEmpty()) {
                finalImageUrl = imageUrl;
            }

            if (finalImageUrl == null || finalImageUrl.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=Image is required");
                return;
            }

            int discountPercent = 0;
            int displayOrder = 0;
            try {
                if (discountPercentStr != null && !discountPercentStr.isEmpty()) {
                    discountPercent = Integer.parseInt(discountPercentStr);
                }
                if (displayOrderStr != null && !displayOrderStr.isEmpty()) {
                    displayOrder = Integer.parseInt(displayOrderStr);
                }
            } catch (NumberFormatException e) {}

            SliderImage slider = new SliderImage();
            slider.setTitle(title);
            slider.setDescription(description);
            slider.setButtonText(buttonText != null && !buttonText.isEmpty() ? buttonText : "Shop Now");
            slider.setButtonLink(buttonLink != null && !buttonLink.isEmpty() ? buttonLink : "#");
            slider.setDiscountPercent(discountPercent);
            slider.setCategory(category);
            slider.setImageUrl(finalImageUrl);
            slider.setDisplayOrder(displayOrder);
            slider.setActive(true);

            boolean success = sliderDAO.addSlider(slider);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?success=Slider added successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=Failed to add slider");
            }
        } else if ("update".equals(action)) {
            String idStr = request.getParameter("id");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String buttonText = request.getParameter("buttonText");
            String buttonLink = request.getParameter("buttonLink");
            String discountPercentStr = request.getParameter("discountPercent");
            String category = request.getParameter("category");
            String displayOrderStr = request.getParameter("displayOrder");
            String activeStr = request.getParameter("active");

            Part imagePart = request.getPart("imageFile");
            String savedImagePath = saveImage(imagePart);
            String imageUrl = request.getParameter("imageUrl");

            String finalImageUrl = savedImagePath;
            if (finalImageUrl == null || finalImageUrl.trim().isEmpty()) {
                finalImageUrl = imageUrl;
            }

            int id = Integer.parseInt(idStr);
            int discountPercent = 0;
            int displayOrder = 0;
            try {
                if (discountPercentStr != null && !discountPercentStr.isEmpty()) {
                    discountPercent = Integer.parseInt(discountPercentStr);
                }
                if (displayOrderStr != null && !displayOrderStr.isEmpty()) {
                    displayOrder = Integer.parseInt(displayOrderStr);
                }
            } catch (NumberFormatException e) {}

            SliderImage slider = sliderDAO.getSliderById(id);
            if (slider != null) {
                slider.setTitle(title);
                slider.setDescription(description);
                slider.setButtonText(buttonText != null && !buttonText.isEmpty() ? buttonText : "Shop Now");
                slider.setButtonLink(buttonLink != null && !buttonLink.isEmpty() ? buttonLink : "#");
                slider.setDiscountPercent(discountPercent);
                slider.setCategory(category);
                if (finalImageUrl != null && !finalImageUrl.trim().isEmpty()) {
                    slider.setImageUrl(finalImageUrl);
                }
                slider.setDisplayOrder(displayOrder);
                slider.setActive("on".equals(activeStr) || "true".equals(activeStr));

                boolean success = sliderDAO.updateSlider(slider);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?success=Slider updated successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=Failed to update slider");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=Slider not found");
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                boolean success = sliderDAO.deleteSlider(id);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?success=Slider deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=Failed to delete slider");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manage-sliders.jsp?error=No ID provided");
            }
        }
    }
}