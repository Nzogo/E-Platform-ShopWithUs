package com.ecommerce.service;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    public boolean registerUser(User user) {
        // Additional business logic can be added here
        // Example: Password encryption, email validation, etc.

        if (userDAO.emailExists(user.getEmail())) {
            return false;
        }

        return userDAO.registerUser(user);
    }

    public boolean isEmailRegistered(String email) {
        return userDAO.emailExists(email);
    }

    public User getUserDetails(String email) {
        return userDAO.getUserByEmail(email);
    }
}