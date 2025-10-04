package com.example.HotelBookingManagementSystem.dto;

public class HotelDTO {

    private long id;
    private String name;
    private String address;
    private String rating;
    private String image;

   private LocationDTO location;

    public HotelDTO() {}



    public HotelDTO(long id, String name, String address, String rating, String image, LocationDTO location) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.rating = rating;
        this.image = image;
        this.location = location;
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public LocationDTO getLocation() {
        return location;
    }

    public void setLocation(LocationDTO location) {
        this.location = location;
    }
}
