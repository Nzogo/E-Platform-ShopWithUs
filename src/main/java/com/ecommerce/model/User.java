package com.ecommerce.model;

public class User {
    private int id;
    private String fullname;
    private String email;
    private String nickname;
    private String password;
    private String phone;
    private String address;

    // Default constructor
    public User() {}

    // Constructor with basic fields
    public User(String fullname, String email, String nickname, String password, String phone, String address) {
        this.fullname = fullname;
        this.email = email;
        this.nickname = nickname;
        this.password = password;
        this.phone = phone;
        this.address = address;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}