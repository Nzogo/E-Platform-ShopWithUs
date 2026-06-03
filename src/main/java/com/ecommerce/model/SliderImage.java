package com.ecommerce.model;

import java.sql.Timestamp;

public class SliderImage {
    private int id;
    private String title;
    private String description;
    private String buttonText;
    private String buttonLink;
    private int discountPercent;
    private String category;
    private String imageUrl;
    private int displayOrder;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default constructor
    public SliderImage() {}

    // Constructor with required fields
    public SliderImage(String title, String description, String buttonText, String buttonLink,
                       int discountPercent, String category, String imageUrl) {
        this.title = title;
        this.description = description;
        this.buttonText = buttonText;
        this.buttonLink = buttonLink;
        this.discountPercent = discountPercent;
        this.category = category;
        this.imageUrl = imageUrl;
        this.active = true;
        this.displayOrder = 0;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getButtonText() { return buttonText; }
    public void setButtonText(String buttonText) { this.buttonText = buttonText; }

    public String getButtonLink() { return buttonLink; }
    public void setButtonLink(String buttonLink) { this.buttonLink = buttonLink; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}