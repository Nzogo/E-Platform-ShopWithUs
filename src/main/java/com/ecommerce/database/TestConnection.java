package com.ecommerce.database;

public class TestConnection {
    public static void main(String[] args) {
        try {
            if (DBConnection.getConnection() != null) {
                System.out.println("Database connection successful!");
                System.out.println("Connected to: ecommerce_db");
            }
        } catch (Exception e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}