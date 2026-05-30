package com.ecommerce.servlet;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/addProduct")
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Product product = new Product();

        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(Double.parseDouble(request.getParameter("price")));
        product.setDiscountPrice(Double.parseDouble(request.getParameter("discountPrice")));
        product.setCategory(request.getParameter("category"));
        product.setBrand(request.getParameter("brand"));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        product.setStatus(request.getParameter("status"));
        product.setImage1(request.getParameter("image1"));
        product.setImage2(request.getParameter("image2"));
        product.setImage3(request.getParameter("image3"));

        ProductDAO dao = new ProductDAO();

        boolean status = dao.addProduct(product);

        if (status) {
            response.sendRedirect("admin-dashboard.jsp?success=1");
        } else {
            response.sendRedirect("admin-dashboard.jsp?error=1");
        }
    }
}