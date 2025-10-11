package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.RoomDTO;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.entity.Room;
import com.example.HotelBookingManagementSystem.repository.HotelAdminRepository;
import com.example.HotelBookingManagementSystem.service.Roomservice;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/room")
public class RoomRestController {

    @Autowired
    private Roomservice roomService;

    @Autowired
    private HotelAdminRepository hotelAdminRepository;

    // Get all rooms
//    @GetMapping("/all")
//    public List<RoomDTO> getAllRooms() {
//        return roomService.getAllRooms();
//    }


    @GetMapping("/all")
    public List<RoomDTO> getAllRooms(Authentication authentication) {
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (isAdmin) {
            return roomService.getAllRooms();
        } else {
            String email = authentication.getName();
            HotelAdmin admin = hotelAdminRepository.findByUserEmail(email)
                    .orElseThrow(() -> new RuntimeException("Admin not found"));

            // শুধুমাত্র তাদের hotel এর room
            return roomService.getRoomsForHotelAdmin(admin.getId());
        }
    }


    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<List<RoomDTO>> getRoomsByHotelId(
            @PathVariable long hotelId,
            Authentication authentication
    ) {
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (isAdmin) {
            return ResponseEntity.ok(roomService.getRoomsByHotelId(hotelId));
        } else {
            // hotelAdmin check
            String email = authentication.getName();
            HotelAdmin admin = hotelAdminRepository.findByUserEmail(email)
                    .orElseThrow(() -> new RuntimeException("Admin not found"));

            List<RoomDTO> rooms = roomService.getRoomsForHotelAdmin(admin.getId())
                    .stream()
                    .filter(r -> r.getHotelDTO().getId() == hotelId)
                    .toList();

            return ResponseEntity.ok(rooms);
        }
    }



                // for public

    @GetMapping("/hotell/{hotelId}")
    public ResponseEntity<List<RoomDTO>> getRoomsByHotelIdPublic(
            @PathVariable long hotelId
    ) {


            List<RoomDTO> rooms = roomService.getRoomsByHotelId( hotelId)
                    .stream()
                    .filter(r -> r.getHotelDTO().getId() == hotelId)
                    .toList();

            return ResponseEntity.ok(rooms);
        }



    // Save new room
    @PostMapping("/save")
    public ResponseEntity<?> saveRoom(
            @RequestPart("room") RoomDTO roomDTO,
            @RequestPart(value = "image", required = false) MultipartFile image,
            Authentication authentication
    ) {
        try {
            String username = authentication.getName();
            HotelAdmin admin = hotelAdminRepository.findByUserEmail(username)
                    .orElseThrow(() -> new RuntimeException("Admin not found"));

            roomService.saveRoom(roomDTO, image, admin);
            return ResponseEntity.ok(Map.of("message", "Room saved successfully"));

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Image upload failed: " + e.getMessage());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Room save failed: " + e.getMessage());
        }
    }

    // Update existing room
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateRoom(
            @PathVariable long id,
            @RequestPart("room") RoomDTO roomDTO,
            @RequestPart(value = "image", required = false) MultipartFile image,
            Authentication authentication
    ) {
        try {
            String username = authentication.getName();
            HotelAdmin admin = hotelAdminRepository.findByUserEmail(username)
                    .orElseThrow(() -> new RuntimeException("Admin not found"));

            Room updatedRoom = roomService.updateRoom(id, roomDTO, image, admin);

            return ResponseEntity.ok().body("Room updated successfully");

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Image upload failed: " + e.getMessage());
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Room update failed: " + e.getMessage());
        }
    }


    @GetMapping("/r/searchRoom")
    public ResponseEntity<List<Room>> findRoomByHotelName(@RequestParam(value = "hotelName") String hotelName) {

        List<Room> rooms = roomService.findRoomByHotelName(hotelName);
        return ResponseEntity.ok(rooms);
    }


    @GetMapping("/{id}")
    public Optional<RoomDTO> getRoomById(@PathVariable long id) {

        return roomService.findRoomById(id);
    }

    // Delete room

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteRoom(@PathVariable long id) {
        if (roomService.deleteRoom(id)) {
            return ResponseEntity.ok().body("Room deleted successfully");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Room not found");
        }
    }
}
