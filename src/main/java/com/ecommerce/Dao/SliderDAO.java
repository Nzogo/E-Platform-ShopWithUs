package com.ecommerce.dao;

import com.ecommerce.database.DBConnection;
import com.ecommerce.model.SliderImage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SliderDAO {

    // Get all active sliders
    public List<SliderImage> getAllActiveSliders() {
        List<SliderImage> sliders = new ArrayList<>();
        String sql = "SELECT * FROM slider_images WHERE active = 1 ORDER BY display_order ASC, id ASC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                sliders.add(extractSliderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sliders;
    }

    // Get active sliders by category
    public List<SliderImage> getActiveSlidersByCategory(String category) {
        List<SliderImage> sliders = new ArrayList<>();
        String sql = "SELECT * FROM slider_images WHERE active = 1 AND category = ? ORDER BY display_order ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                sliders.add(extractSliderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sliders;
    }

    // Get slider by ID
    public SliderImage getSliderById(int id) {
        String sql = "SELECT * FROM slider_images WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractSliderFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add new slider
    public boolean addSlider(SliderImage slider) {
        String sql = "INSERT INTO slider_images (title, description, button_text, button_link, discount_percent, category, image_url, display_order, active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, slider.getTitle());
            pstmt.setString(2, slider.getDescription());
            pstmt.setString(3, slider.getButtonText());
            pstmt.setString(4, slider.getButtonLink());
            pstmt.setInt(5, slider.getDiscountPercent());
            pstmt.setString(6, slider.getCategory());
            pstmt.setString(7, slider.getImageUrl());
            pstmt.setInt(8, slider.getDisplayOrder());
            pstmt.setBoolean(9, slider.isActive());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update existing slider
    public boolean updateSlider(SliderImage slider) {
        String sql = "UPDATE slider_images SET title=?, description=?, button_text=?, button_link=?, discount_percent=?, category=?, image_url=?, display_order=?, active=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, slider.getTitle());
            pstmt.setString(2, slider.getDescription());
            pstmt.setString(3, slider.getButtonText());
            pstmt.setString(4, slider.getButtonLink());
            pstmt.setInt(5, slider.getDiscountPercent());
            pstmt.setString(6, slider.getCategory());
            pstmt.setString(7, slider.getImageUrl());
            pstmt.setInt(8, slider.getDisplayOrder());
            pstmt.setBoolean(9, slider.isActive());
            pstmt.setInt(10, slider.getId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete slider
    public boolean deleteSlider(int id) {
        String sql = "DELETE FROM slider_images WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get total count of sliders
    public int getSliderCount() {
        String sql = "SELECT COUNT(*) as total FROM slider_images WHERE active = 1";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Update slider active status
    public boolean updateSliderStatus(int id, boolean active) {
        String sql = "UPDATE slider_images SET active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setBoolean(1, active);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Reorder sliders
    public boolean reorderSliders(int id, int newOrder) {
        String sql = "UPDATE slider_images SET display_order = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, newOrder);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Extract slider from ResultSet (handles MySQL 5 timestamp issues)
    private SliderImage extractSliderFromResultSet(ResultSet rs) throws SQLException {
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
        slider.setCreatedAt(rs.getTimestamp("created_at"));

        // Handle updated_at safely for MySQL 5 (might be null or '0000-00-00')
        try {
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            if (updatedAt != null && !updatedAt.toString().startsWith("0000")) {
                slider.setUpdatedAt(updatedAt);
            } else {
                slider.setUpdatedAt(null);
            }
        } catch (SQLException e) {
            slider.setUpdatedAt(null);
        }

        return slider;
    }
}