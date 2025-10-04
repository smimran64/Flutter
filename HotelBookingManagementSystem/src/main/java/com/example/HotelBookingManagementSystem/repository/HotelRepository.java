package com.example.HotelBookingManagementSystem.repository;

import com.example.HotelBookingManagementSystem.entity.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, Long> {


    @Query("select h from  Hotel h where h.location.name= :locationName")
    List<Hotel> findHotelByLocationName(@Param("locationName") String locationName);

    @Query("SELECT h FROM Hotel h WHERE h.location.id = :locationId")
    List<Hotel> findHotelsByLocationId(@Param("locationId") Long locationId);



    List<Hotel> findByHotelAdminId(int hotelAdminId);

    Optional<Hotel> findByName(String name);


}
