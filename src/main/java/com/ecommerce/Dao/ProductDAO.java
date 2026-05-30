package com.ecommerce.dao;

import com.ecommerce.config.DBConnection;
import com.ecommerce.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public boolean addProduct(Product product) {

        boolean status = false;

        try {

            Connection connection = DBConnection.getConnection();

            String sql = "INSERT INTO products(name, description, price, discount_price, category, brand, stock, status, image1, image2, image3) VALUES(?,?,?,?,?,?,?,?,?,?,?)";

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setDouble(4, product.getDiscountPrice());
            ps.setString(5, product.getCategory());
            ps.setString(6, product.getBrand());
            ps.setInt(7, product.getStock());
            ps.setString(8, product.getStatus());
            ps.setString(9, product.getImage1());
            ps.setString(10, product.getImage2());
            ps.setString(11, product.getImage3());

            int row = ps.executeUpdate();

            if (row > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public List<Product> getAllProducts() {

        List<Product> list = new ArrayList<Product>();

        try {

            Connection connection = DBConnection.getConnection();

            String sql = "SELECT * FROM products ORDER BY id DESC";

            PreparedStatement ps = connection.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

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

                list.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}