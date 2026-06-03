package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/deleteProduct")
public class DeleteProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("id"));
        boolean success = productDAO.deleteProduct(productId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-products.jsp?success=Product deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-products.jsp?error=Delete failed");
        }
    }
}