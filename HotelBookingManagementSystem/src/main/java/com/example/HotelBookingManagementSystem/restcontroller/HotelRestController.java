package com.example.HotelBookingManagementSystem.restcontroller;

import com.example.HotelBookingManagementSystem.dto.HotelDTO;
import com.example.HotelBookingManagementSystem.entity.*;
import com.example.HotelBookingManagementSystem.repository.HotelAdminRepository;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import com.example.HotelBookingManagementSystem.repository.LocationRepository;
import com.example.HotelBookingManagementSystem.repository.UserRepository;
import com.example.HotelBookingManagementSystem.service.HotelService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hotel")
public class HotelRestController {

    @Autowired
    private HotelService hotelService;

    @Autowired
    private HotelRepository hotelRepository;

    @Autowired
    private HotelAdminRepository hotelAdminRepository;

    @Autowired
    private LocationRepository locationRepository;

    @Autowired
    private UserRepository userRepository;


    @GetMapping("/all")
    public ResponseEntity<List<HotelDTO>> getAllHotels() {
        List<HotelDTO> hotels = hotelService.getAllHotels();
        return ResponseEntity.ok(hotels);
    }


    // Save hotel
    @PostMapping("/save")
    public ResponseEntity<?> saveHotel(
            @RequestPart("hotel") String hotelJson,
            @RequestPart(value = "image", required = false) MultipartFile image,
            Authentication authentication
    ) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            HotelDTO hotelDTO = mapper.readValue(hotelJson, HotelDTO.class);

            String username = authentication.getName();
            HotelAdmin admin = hotelAdminRepository.findByUserEmail(username)
                    .orElseThrow(() -> new RuntimeException("Admin not found"));

            Hotel savedHotel = hotelService.saveHotel(hotelDTO, image, admin);

            return ResponseEntity.ok(Map.of("message", "Hotel saved successfully", "hotel", savedHotel));

        } catch (Exception e) {
            e.printStackTrace(); // <-- console log
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Hotel save failed", "error", e.getMessage()));
        }
    }


    @GetMapping("/{id}")
    public ResponseEntity<HotelDTO> findHotelById(@PathVariable long id) {
        try {
            HotelDTO hotelDTO = hotelService.findHotelById(id);
            return ResponseEntity.ok(hotelDTO);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @GetMapping("/h/searchhotel")
    public ResponseEntity<List<Hotel>> findHotelByLocationName(@RequestParam(value = "locationName") String locationName) {

        List<Hotel> hotels = hotelService.findHotelByLocationName(locationName);
        return ResponseEntity.ok(hotels);
    }

    // for home page hotel search


    @GetMapping("/search")
    public ResponseEntity<List<HotelDTO>> searchHotels(
            @RequestParam Long locationId,
            @RequestParam String checkIn,
            @RequestParam String checkOut) {
        List<HotelDTO> hotels = hotelService.searchHotels(locationId, checkIn, checkOut);
        return ResponseEntity.ok(hotels);
    }

    @GetMapping("/{id}/rooms")
    public ResponseEntity<List<Room>> getRoomsByHotel(@PathVariable Long id) {
        List<Room> rooms = hotelService.getRoomsByHotelId(id);
        return ResponseEntity.ok(rooms);

    }

    @GetMapping("/myHotels")
    public ResponseEntity<List<HotelDTO>> getMyHotels(Authentication authentication) {
        String email = authentication.getName();
        HotelAdmin admin = hotelAdminRepository.findByUserEmail(email)
                .orElseThrow(() -> new RuntimeException("Admin not found"));
        List<HotelDTO> hotels = hotelService.getHotelsByAdminId(admin.getId());
        return ResponseEntity.ok(hotels);
    }

    @GetMapping("/hotelbyhoteladmin/{hotelAdminId}")
    public List<HotelDTO> getHotelByAdminId(@PathVariable int hotelAdminId) {
        return hotelService.findHotelByHotelAdminId(hotelAdminId);
    }






    @GetMapping("/h/searchhotelname")
    public ResponseEntity<Hotel> findHotelByName(@RequestParam(value = "name") String name) {

        Hotel hotels = hotelService.findHotelByName(name);
        return ResponseEntity.ok(hotels);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteHotel(@PathVariable long id) {
        try {
            hotelService.deleteHotel(id);
            return ResponseEntity.ok("Hotel deleted successfully");
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }


    @PutMapping("/update/{id}")
    public ResponseEntity<Hotel> updateHotel(
            @PathVariable long id,
            @RequestPart Hotel hotel,
            @RequestParam(value = "image", required = true) MultipartFile file
    )

            throws IOException {
        Hotel updatedHotel = hotelService.updateHotel(id, hotel, file);
        return ResponseEntity.ok(updatedHotel);
    }

}
