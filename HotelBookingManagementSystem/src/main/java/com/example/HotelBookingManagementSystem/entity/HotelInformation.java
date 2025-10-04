package com.example.HotelBookingManagementSystem.entity;


import jakarta.persistence.*;

@Entity
@Table(name = "hotelInfo")
public class HotelInformation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;


    @Column(length = 1000 ,name = "owner_info", nullable = false)
    private String ownerSpeach;

    @Column(length = 1000)
    private String description;

    @Column(length = 1000)
    private String hotelPolicy;

    @OneToOne
    @JoinColumn(name = "hotel_id", nullable = false)
    private Hotel hotel;


    public HotelInformation() {
    }

    public HotelInformation(long id, String ownerSpeach, String description, String hotelPolicy, Hotel hotel) {
        this.id = id;
        this.ownerSpeach = ownerSpeach;
        this.description = description;
        this.hotelPolicy = hotelPolicy;
        this.hotel = hotel;
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

    public Hotel getHotel() {
        return hotel;
    }

    public void setHotel(Hotel hotel) {
        this.hotel = hotel;
    }
}
