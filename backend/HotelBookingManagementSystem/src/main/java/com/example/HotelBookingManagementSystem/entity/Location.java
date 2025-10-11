package com.example.HotelBookingManagementSystem.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "locations")
public class Location {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String name;
    private String image;
    @OneToMany(mappedBy = "location", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Hotel> hotels;




    public Location() {
    }

    public Location(long id, String name, String image, List<Hotel> hotels) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.hotels = hotels;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public List<Hotel> getHotels() {
        return hotels;
    }

    public void setHotels(List<Hotel> hotels) {
        this.hotels = hotels;
    }
}