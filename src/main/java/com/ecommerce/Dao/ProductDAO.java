package com.ecommerce.dao;

import com.ecommerce.database.DBConnection;
import com.ecommerce.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, discount_price, category, brand, stock, status, image1, image2, image3) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setDouble(4, product.getDiscountPrice());
            pstmt.setString(5, product.getCategory());
            pstmt.setString(6, product.getBrand());
            pstmt.setInt(7, product.getStock());
            pstmt.setString(8, product.getStatus());
            pstmt.setString(9, product.getImage1());
            pstmt.setString(10, product.getImage2());
            pstmt.setString(11, product.getImage3());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setDiscountPrice(rs.getDouble("discount_price"));
                product.setCategory(rs.getString("category"));
                product.setBrand(rs.getString("brand"));
                product.setStock(rs.getInt("stock"));
                product.setStatus(rs.getString("status"));
                product.setImage1(rs.getString("image1"));
                product.setImage2(rs.getString("image2"));
                product.setImage3(rs.getString("image3"));
                products.add(product);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setDiscountPrice(rs.getDouble("discount_price"));
                product.setCategory(rs.getString("category"));
                product.setBrand(rs.getString("brand"));
                product.setStock(rs.getInt("stock"));
                product.setStatus(rs.getString("status"));
                product.setImage1(rs.getString("image1"));
                product.setImage2(rs.getString("image2"));
                product.setImage3(rs.getString("image3"));
                return product;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name=?, description=?, price=?, discount_price=?, category=?, brand=?, stock=?, status=?, image1=?, image2=?, image3=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, product.getName());
            pstmt.setString(2, product.getDescription());
            pstmt.setDouble(3, product.getPrice());
            pstmt.setDouble(4, product.getDiscountPrice());
            pstmt.setString(5, product.getCategory());
            pstmt.setString(6, product.getBrand());
            pstmt.setInt(7, product.getStock());
            pstmt.setString(8, product.getStatus());
            pstmt.setString(9, product.getImage1());
            pstmt.setString(10, product.getImage2());
            pstmt.setString(11, product.getImage3());
            pstmt.setInt(12, product.getId());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}