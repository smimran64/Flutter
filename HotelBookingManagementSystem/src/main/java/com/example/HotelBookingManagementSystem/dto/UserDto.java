package com.example.HotelBookingManagementSystem.dto;

import com.example.HotelBookingManagementSystem.entity.Role;

public class UserDto {

    private int id;
    private String name;
    private String email;
    private String phone;
    private String image;
    private Role role;

    public UserDto() {
    }


    public UserDto(int id, String name, String email, String phone, String image, Role role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.image = image;
        this.role = role;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}
