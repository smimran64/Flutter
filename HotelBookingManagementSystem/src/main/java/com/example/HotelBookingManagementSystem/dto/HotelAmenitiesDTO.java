package com.example.HotelBookingManagementSystem.dto;

public class HotelAmenitiesDTO {

    private Long id;

    private boolean freeWifi;
    private boolean freeParking;
    private boolean swimmingPool;
    private boolean gym;
    private boolean restaurant;
    private boolean roomService;
    private boolean airConditioning;
    private boolean laundryService;
    private boolean wheelchairAccessible;
    private boolean healthServices;
    private boolean playGround;
    private boolean airportSuttle;
    private boolean breakFast;

    private long hotelId;
    private String hotelName;

    public HotelAmenitiesDTO() {
    }

    public HotelAmenitiesDTO(Long id, boolean freeWifi, boolean freeParking, boolean swimmingPool, boolean gym, boolean restaurant, boolean roomService, boolean airConditioning, boolean laundryService, boolean wheelchairAccessible, boolean healthServices, boolean playGround, boolean airportSuttle, boolean breakFast, long hotelId, String hotelName) {
        this.id = id;
        this.freeWifi = freeWifi;
        this.freeParking = freeParking;
        this.swimmingPool = swimmingPool;
        this.gym = gym;
        this.restaurant = restaurant;
        this.roomService = roomService;
        this.airConditioning = airConditioning;
        this.laundryService = laundryService;
        this.wheelchairAccessible = wheelchairAccessible;
        this.healthServices = healthServices;
        this.playGround = playGround;
        this.airportSuttle = airportSuttle;
        this.breakFast = breakFast;
        this.hotelId = hotelId;
        this.hotelName = hotelName;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public boolean isFreeWifi() {
        return freeWifi;
    }

    public void setFreeWifi(boolean freeWifi) {
        this.freeWifi = freeWifi;
    }

    public boolean isFreeParking() {
        return freeParking;
    }

    public void setFreeParking(boolean freeParking) {
        this.freeParking = freeParking;
    }

    public boolean isSwimmingPool() {
        return swimmingPool;
    }

    public void setSwimmingPool(boolean swimmingPool) {
        this.swimmingPool = swimmingPool;
    }

    public boolean isGym() {
        return gym;
    }

    public void setGym(boolean gym) {
        this.gym = gym;
    }

    public boolean isRestaurant() {
        return restaurant;
    }

    public void setRestaurant(boolean restaurant) {
        this.restaurant = restaurant;
    }

    public boolean isRoomService() {
        return roomService;
    }

    public void setRoomService(boolean roomService) {
        this.roomService = roomService;
    }

    public boolean isAirConditioning() {
        return airConditioning;
    }

    public void setAirConditioning(boolean airConditioning) {
        this.airConditioning = airConditioning;
    }

    public boolean isLaundryService() {
        return laundryService;
    }

    public void setLaundryService(boolean laundryService) {
        this.laundryService = laundryService;
    }

    public boolean isWheelchairAccessible() {
        return wheelchairAccessible;
    }

    public void setWheelchairAccessible(boolean wheelchairAccessible) {
        this.wheelchairAccessible = wheelchairAccessible;
    }

    public boolean isHealthServices() {
        return healthServices;
    }

    public void setHealthServices(boolean healthServices) {
        this.healthServices = healthServices;
    }

    public boolean isPlayGround() {
        return playGround;
    }

    public void setPlayGround(boolean playGround) {
        this.playGround = playGround;
    }

    public boolean isAirportSuttle() {
        return airportSuttle;
    }

    public void setAirportSuttle(boolean airportSuttle) {
        this.airportSuttle = airportSuttle;
    }

    public boolean isBreakFast() {
        return breakFast;
    }

    public void setBreakFast(boolean breakFast) {
        this.breakFast = breakFast;
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
