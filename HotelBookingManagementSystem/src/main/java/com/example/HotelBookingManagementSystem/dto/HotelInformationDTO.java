package com.example.HotelBookingManagementSystem.dto;

public class HotelInformationDTO {

    private long id;
    private String ownerSpeach;
    private String description;
    private String hotelPolicy;

    private long hotelId;
    private String hotelName;

    public HotelInformationDTO() {
    }

    public HotelInformationDTO(long id, String ownerSpeach, String description, String hotelPolicy, long hotelId, String hotelName) {
        this.id = id;
        this.ownerSpeach = ownerSpeach;
        this.description = description;
        this.hotelPolicy = hotelPolicy;
        this.hotelId = hotelId;
        this.hotelName = hotelName;
    }


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getOwnerSpeach() {
        return ownerSpeach;
    }

    public void setOwnerSpeach(String ownerSpeach) {
        this.ownerSpeach = ownerSpeach;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHotelPolicy() {
        return hotelPolicy;
    }

    public void setHotelPolicy(String hotelPolicy) {
        this.hotelPolicy = hotelPolicy;
    }

    public long getHotelId() {
        return hotelId;
    }

    public void setHotelId(long hotelId) {
        this.hotelId = hotelId;
    }

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }
}
