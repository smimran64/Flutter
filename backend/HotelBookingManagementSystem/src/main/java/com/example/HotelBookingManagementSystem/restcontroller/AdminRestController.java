package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.AdminDTO;
import com.example.HotelBookingManagementSystem.dto.CustomerDTO;
import com.example.HotelBookingManagementSystem.entity.Admin;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.entity.User;
import com.example.HotelBookingManagementSystem.repository.AdminRepository;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import com.example.HotelBookingManagementSystem.service.AdminService;
import com.example.HotelBookingManagementSystem.service.AuthService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin")
public class AdminRestController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private AuthService authService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    // Admin Registration
    @PostMapping("/reg")
    public ResponseEntity<Map<String, String>> registerAdmin(
            @RequestPart("user") String userJson,
            @RequestPart("admin") String adminJson,
            @RequestPart(value = "image", required = false) MultipartFile file
//             @RequestParam("adminCode") String adminCode
    ) throws JsonProcessingException {


//        if (!"SECRET123".equals(adminCode)) {
//            return ResponseEntity.status(HttpStatus.FORBIDDEN)
//                    .body(Map.of("error", "Invalid Admin Code"));
//        }


        User user = objectMapper.readValue(userJson, User.class);
        Admin admin = objectMapper.readValue(adminJson, Admin.class);

        try {
            authService.registerAdmin(user, file, admin);
            Map<String, String> response = new HashMap<>();
            response.put("message", "Admin registered successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Admin registration failed: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    // Get all admins
    @GetMapping("/all")
    public ResponseEntity<List<AdminDTO>> getAllAdmins() {
        List<AdminDTO> admins = adminService.getAllAdmins();
        return ResponseEntity.ok(admins);
    }

    // Get logged-in admin profile
    @GetMapping("/profile")
    public ResponseEntity<AdminDTO> getProfile(Authentication authentication) {
        String email = authentication.getName(); // logged-in user's email
        AdminDTO adminDTO = adminService.getProfile(email);
        return ResponseEntity.ok(adminDTO);
    }


    @GetMapping("/{id}")
    public ResponseEntity<AdminDTO> findAdminById(@PathVariable Integer id) {
        AdminDTO dto = adminService.findAdminById(id);
        return ResponseEntity.ok(dto);
    }


//    @GetMapping("profile/{id}")
//    public AdminDTO getAdminProfile(@PathVariable int id) {
//        return adminService.getAdminProfile(id);
//    }
}
