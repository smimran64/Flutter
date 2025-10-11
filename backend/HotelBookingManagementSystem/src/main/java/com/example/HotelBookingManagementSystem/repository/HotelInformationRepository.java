package com.example.HotelBookingManagementSystem.repository;


import com.example.HotelBookingManagementSystem.entity.HotelInformation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HotelInformationRepository extends JpaRepository<HotelInformation,Long> {

    Optional<HotelInformation> findHotelInformationByHotel_Id(Long hotelId);


}
