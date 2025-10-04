package com.example.HotelBookingManagementSystem.restcontroller;

import com.example.HotelBookingManagementSystem.dto.HotelPhotoDTO;
import com.example.HotelBookingManagementSystem.entity.HotelPhoto;
import com.example.HotelBookingManagementSystem.service.HotelPhotoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hotelPhoto")
public class HotelPhotoRestController {

    private final HotelPhotoService photoService;

    public HotelPhotoRestController(HotelPhotoService photoService) {
        this.photoService = photoService;
    }

    @PostMapping("/upload/{hotelId}")
    public ResponseEntity<List<HotelPhotoDTO>> uploadPhotos(
            @PathVariable Long hotelId,
            @RequestParam("files") List<MultipartFile> files) {
        try {
            List<HotelPhotoDTO> savedPhotos = photoService.saveMultiplePhotos(hotelId, files);
            return ResponseEntity.ok(savedPhotos);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Get all photos of a hotel → return DTO list
    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<List<HotelPhotoDTO>> getPhotosByHotel(@PathVariable Long hotelId) {
        try {
            List<HotelPhotoDTO> photos = photoService.getPhotosByHotelId(hotelId);
            return ResponseEntity.ok(photos);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // Delete a photo by ID
    @DeleteMapping("/{photoId}")
    public ResponseEntity<String> deletePhoto(@PathVariable Long photoId) {
        try {
            photoService.deletePhoto(photoId);
            return ResponseEntity.ok("Photo deleted successfully");
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Delete failed!");
        }
    }
}
