package com.example.HotelBookingManagementSystem.repository;


import com.example.HotelBookingManagementSystem.entity.HotelPhoto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelPhotoRepository  extends JpaRepository<HotelPhoto, Long> {

    List<HotelPhoto> findByHotelId(Long hotelId);


}
