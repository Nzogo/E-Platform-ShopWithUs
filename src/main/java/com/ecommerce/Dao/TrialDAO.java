package com.ecommerce.dao;

import com.ecommerce.database.DBConnection;
import java.sql.*;

public class TrialDAO {

    // Save trial request
    public boolean saveTrialRequest(String email, String name) {
        String sql = "INSERT INTO trial_requests (email, name) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            pstmt.setString(2, name);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if trial already requested
    public boolean trialRequestExists(String email) {
        String sql = "SELECT id FROM trial_requests WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update trial request status
    public boolean updateTrialStatus(String email, String status) {
        String sql = "UPDATE trial_requests SET status = ? WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, email);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}