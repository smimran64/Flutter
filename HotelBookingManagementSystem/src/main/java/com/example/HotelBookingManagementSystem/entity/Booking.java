package com.example.HotelBookingManagementSystem.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "bookings")
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String contractPersonName;
    private String phone;
    private Date checkIn;
    private Date checkOut;
    private int numberOfRooms;
    private double discountRate;

    private double totalAmount;
    private double advanceAmount;
    private double dueAmount;




    @ManyToOne
    @JoinColumn(name = "customerId", nullable = false)
    private Customer customer;

    @ManyToOne
    @JoinColumn(name = "hotelId", nullable = false)
    @JsonBackReference(value = "hotel-bookings")
    private Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "roomId", nullable = false)
    @JsonBackReference(value = "room-bookings")
    private Room room;

    public Booking() {
    }

    public Booking(Long id, String contractPersonName, String phone, Date checkIn, Date checkOut, int numberOfRooms, double discountRate, double totalAmount, double advanceAmount, double dueAmount, Customer customer, Hotel hotel, Room room) {
        this.id = id;
        this.contractPersonName = contractPersonName;
        this.phone = phone;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.numberOfRooms = numberOfRooms;
        this.discountRate = discountRate;
        this.totalAmount = totalAmount;
        this.advanceAmount = advanceAmount;
        this.dueAmount = dueAmount;
        this.customer = customer;
        this.hotel = hotel;
        this.room = room;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getContractPersonName() {
        return contractPersonName;
    }

    public void setContractPersonName(String contractPersonName) {
        this.contractPersonName = contractPersonName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Date checkIn) {
        this.checkIn = checkIn;
    }

    public Date getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public int getNumberOfRooms() {
        return numberOfRooms;
    }

    public void setNumberOfRooms(int numberOfRooms) {
        this.numberOfRooms = numberOfRooms;
    }

    public double getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(double discountRate) {
        this.discountRate = discountRate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getAdvanceAmount() {
        return advanceAmount;
    }

    public void setAdvanceAmount(double advanceAmount) {
        this.advanceAmount = advanceAmount;
    }

    public double getDueAmount() {
        return dueAmount;
    }

    public void setDueAmount(double dueAmount) {
        this.dueAmount = dueAmount;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Hotel getHotel() {
        return hotel;
    }

    public void setHotel(Hotel hotel) {
        this.hotel = hotel;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }
}
