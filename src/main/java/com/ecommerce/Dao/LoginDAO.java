package com.ecommerce.Dao;

import com.ecommerce.database.DBConnection;
import com.ecommerce.model.User;
import java.sql.*;

public class LoginDAO {

    private UserDAO userDAO = new UserDAO();

    // Authenticate user login (can use email)
    public User authenticateUser(String username, String password) {
        String sql = "SELECT id, fullname, email, nickname, phone, address FROM users WHERE (email = ?) AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = userDAO.getUserByEmail(rs.getString("email"));
                if (user != null) {
                    // Update last login if you have that column
                    // userDAO.updateLastLogin(user.getId());
                }
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}