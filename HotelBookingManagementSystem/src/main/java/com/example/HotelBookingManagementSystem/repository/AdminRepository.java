package com.example.HotelBookingManagementSystem.repository;


import com.example.HotelBookingManagementSystem.entity.Admin;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdminRepository extends JpaRepository<Admin, Integer> {

    Optional<Admin> findByUserId(Integer id);

    Admin findAdminByUser_Id(Integer id);


    Optional<Admin> findByEmail(String email);
}
