package com.example.HotelBookingManagementSystem.repository;


import com.example.HotelBookingManagementSystem.entity.HotelAmenities;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HotelAmenitiesRepository  extends JpaRepository<HotelAmenities,Long> {

    Optional<HotelAmenities> findHotelAmenitiesByHotelId(Long hotelId);
}
