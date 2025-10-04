package com.example.HotelBookingManagementSystem.dto;

public class HotelPhotoDTO {

    private Long id;
    private String photoUrl;
    private Long hotelId;
    private String hotelName;

    public HotelPhotoDTO() {
    }

    public HotelPhotoDTO(Long id, String photoUrl, Long hotelId, String hotelName) {
        this.id = id;
        this.photoUrl = photoUrl;
        this.hotelId = hotelId;
        this.hotelName = hotelName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public Long getHotelId() {
        return hotelId;
    }

    public void setHotelId(Long hotelId) {
        this.hotelId = hotelId;
    }

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }
}
