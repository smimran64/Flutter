package com.example.HotelBookingManagementSystem.dto;

import java.util.Date;

public class BookingDTO {
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


        private CustomerDTO customerdto;
        private HotelDTO hoteldto;
        private RoomDTO roomdto;

        public BookingDTO() {
        }

        public BookingDTO(Long id, String contractPersonName, String phone, Date checkIn, Date checkOut, int numberOfRooms, double discountRate, double totalAmount, double advanceAmount, double dueAmount, CustomerDTO customerdto, HotelDTO hoteldto, RoomDTO roomdto) {
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
                this.customerdto = customerdto;
                this.hoteldto = hoteldto;
                this.roomdto = roomdto;
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

        public CustomerDTO getCustomerdto() {
                return customerdto;
        }

        public void setCustomerdto(CustomerDTO customerdto) {
                this.customerdto = customerdto;
        }

        public HotelDTO getHoteldto() {
                return hoteldto;
        }

        public void setHoteldto(HotelDTO hoteldto) {
                this.hoteldto = hoteldto;
        }

        public RoomDTO getRoomdto() {
                return roomdto;
        }

        public void setRoomdto(RoomDTO roomdto) {
                this.roomdto = roomdto;
        }
}
