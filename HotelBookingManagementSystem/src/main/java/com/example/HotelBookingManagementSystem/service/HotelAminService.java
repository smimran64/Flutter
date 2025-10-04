package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.HotelAdminDTO;
import com.example.HotelBookingManagementSystem.entity.Customer;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.repository.HotelAdminRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HotelAminService {

    @Autowired
    private HotelAdminRepository hotelAdminRepository;


    public List<HotelAdminDTO> getAllHotelAdmins() {
        List<HotelAdmin> admins = hotelAdminRepository.findAll();
        return admins.stream()
                .map(this::mapToDTO)
                .toList(); // যদি Java 8 হয়, তাহলে .collect(Collectors.toList()) ব্যবহার করবে
    }

    public Optional<HotelAdmin> getHotelAdminById(Integer id) {
        return hotelAdminRepository.findById(id);
    }


    public HotelAdmin saveHotelAdmin(HotelAdmin hotelAdmin) {
        return hotelAdminRepository.save(hotelAdmin);
    }

    public void deleteHotelAdmin(Integer id) {
        hotelAdminRepository.deleteById(id);
    }

//    public HotelAdmin getProfileByUserId(Integer userId) {
//        return hotelAdminRepository.findByUserId(userId)
//                .orElseThrow(() -> new RuntimeException("HotelAdmin not found"));
//    }


    public HotelAdminDTO getProfileById(String email) {
        HotelAdmin admin = hotelAdminRepository.findByUserEmail(email)
                .orElseThrow(() -> new RuntimeException("HotelAdmin not found"));

        return new HotelAdminDTO(
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


    // Entity → DTO mapper method
    private HotelAdminDTO mapToDTO(HotelAdmin admin) {
        return new HotelAdminDTO(
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

    public HotelAdminDTO findHotelAdminById(Integer id) {
        HotelAdmin hotelAdmin = hotelAdminRepository.findHotelAdminByUser_Id(id);
        if (hotelAdmin == null) {
            throw new EntityNotFoundException("HotelAdmin not found for user ID: " + id);
        }
        return mapToDTO(hotelAdmin);
    }




}
