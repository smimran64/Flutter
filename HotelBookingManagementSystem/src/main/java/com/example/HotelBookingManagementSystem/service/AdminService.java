package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.AdminDTO;
import com.example.HotelBookingManagementSystem.dto.CustomerDTO;
import com.example.HotelBookingManagementSystem.entity.Admin;
import com.example.HotelBookingManagementSystem.entity.Customer;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.repository.AdminRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    // Fetch admin profile by email (used for logged-in admin)
    public AdminDTO getProfile(String email) {
        Admin admin = adminRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Customer not found"));

        return mapToDTO(admin);
    }


//    public AdminDTO getAdminProfile(int id) {
//        Admin admin = adminRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));
//
//        return new AdminDTO(
//                admin.getId(),
//                admin.getName(),
//                admin.getEmail(),
//                admin.getPhone(),
//                admin.getAddress(),
//                admin.getGender(),
//                admin.getDateOfBirth(),
//                admin.getImage()
//        );
//    }

    // Convert Admin entity to DTO
    private AdminDTO mapToDTO(Admin admin) {
        return new AdminDTO(
                admin.getId(),
                admin.getName(),
                admin.getEmail(),
                admin.getPhone(),
                admin.getAddress(),
                admin.getGender(),
                admin.getDateOfBirth(),
                admin.getImage()
        );
    }

    // Fetch all admins
    public List<AdminDTO> getAllAdmins() {
        List<Admin> admins = adminRepository.findAll();
        return admins.stream().map(this::mapToDTO).toList();
    }

    // Save a new admin
    public AdminDTO saveAdmin(Admin admin) {
        Admin savedAdmin = adminRepository.save(admin);
        return mapToDTO(savedAdmin);
    }

    // Delete admin by id
    public void deleteAdmin(Integer id) {
        if (!adminRepository.existsById(id)) {
            throw new EntityNotFoundException("Admin not found with id: " + id);
        }
        adminRepository.deleteById(id);
    }

    // Fetch admin by id (optional)
    public AdminDTO getAdminById(Integer id) {
        Admin admin = adminRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Admin not found with id: " + id));
        return mapToDTO(admin);
    }

    public AdminDTO findAdminById(Integer id) {
        Admin admin = adminRepository.findAdminByUser_Id(id);
        if (admin == null) {
            throw new EntityNotFoundException("Admin not found for user ID: " + id);
        }
        return mapToDTO(admin);
    }

}
