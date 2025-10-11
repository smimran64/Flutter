package com.example.HotelBookingManagementSystem.repository;

import ch.qos.logback.core.model.INamedModel;
import com.example.HotelBookingManagementSystem.entity.Customer;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HotelAdminRepository extends JpaRepository<HotelAdmin, Integer> {

    Optional<HotelAdmin> findByUserId(Integer id);

    HotelAdmin findHotelAdminByUser_Id(Integer id);





    @Query("select h from HotelAdmin h where h.user.email = :email")
    Optional<HotelAdmin> findByUserEmail(@Param("email") String email);


}
