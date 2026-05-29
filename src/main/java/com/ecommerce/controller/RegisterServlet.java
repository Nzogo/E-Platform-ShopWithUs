package com.ecommerce.controller;

import com.ecommerce.Dao.UserDAO;
import com.ecommerce.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Validation
        if (fullname == null || fullname.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.contains("@")) {
            request.setAttribute("error", "Valid email is required");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 4) {
            request.setAttribute("error", "Password must be at least 4 characters");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Generate nickname if empty
        if (nickname == null || nickname.trim().isEmpty()) {
            nickname = fullname.split(" ")[0].toLowerCase() + (int)(Math.random() * 1000);
        }

        // Check if email exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered. Please login.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Create user
        User user = new User();
        user.setFullname(fullname);
        user.setEmail(email);
        user.setNickname(nickname);
        user.setPassword(password);
        user.setPhone(phone != null ? phone : "");
        user.setAddress(address != null ? address : "");

        if (userDAO.registerUser(user)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        }
    }
}