package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.HotelAdminDTO;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.entity.User;
import com.example.HotelBookingManagementSystem.repository.HotelAdminRepository;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import com.example.HotelBookingManagementSystem.service.AuthService;
import com.example.HotelBookingManagementSystem.service.CustomerService;
import com.example.HotelBookingManagementSystem.service.HotelAminService;
import com.example.HotelBookingManagementSystem.service.UserService;
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
@RequestMapping("/api/hoteladmin")
public class HotelAdminRestController {


    @Autowired
    private UserService userService;

    @Autowired
    private HotelAminService hotelAminService;

    @Autowired
    private UserRepository userRepository;


    @Autowired
    private AuthService authService;
    @Autowired
    private CustomerService customerService;

    @Autowired
    private HotelAdminRepository hotelAdminRepository;

    @GetMapping("")
    public ResponseEntity<?> getMyHotelAdminProfile(Authentication authentication) {
        return hotelAdminRepository.findByUserEmail(authentication.getName())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/reg")
    public ResponseEntity<Map<String, String>> registerHotelAdmin(
            @RequestPart(value = "user") String userJson,
            @RequestPart(value = "hotelAdmin") String hotelAdminJson,
            @RequestParam(value = "image") MultipartFile file
    ) throws JsonProcessingException {

        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.readValue(userJson, User.class);
        HotelAdmin hotelAdmin = objectMapper.readValue(hotelAdminJson,HotelAdmin.class);
        try {
            authService.registerHotelAdmin(user, file, hotelAdmin);
            Map<String, String> response = new HashMap<>();

            response.put("Message", "Hotel Admin registered successfully");

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {

            Map<String, String> errorResponse = new HashMap<>();

            errorResponse.put("Message", "HotelAdmin Registration Failed" + e);

            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);


        }


    }

    @GetMapping("/all")
    public ResponseEntity<List<HotelAdminDTO>> getAllHotelAdmins() {
        List<HotelAdminDTO> admins = hotelAminService.getAllHotelAdmins();
        return ResponseEntity.ok(admins);
    }

    @GetMapping("/profile")
    public ResponseEntity<HotelAdminDTO> getProfile(Authentication authentication) {
        // Current logged-in user email
        String email = authentication.getName();

        // Find user entity by email
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Get HotelAdmin profile using userId and convert to DTO
        HotelAdminDTO profile = hotelAminService.getProfileById(user.getEmail());

        return ResponseEntity.ok(profile);
    }

    @GetMapping("/{id}")
    public ResponseEntity<HotelAdminDTO> findHotelAdminById(@PathVariable Integer id) {
        HotelAdminDTO dto = hotelAminService.findHotelAdminById(id);
        return ResponseEntity.ok(dto);
    }







}
