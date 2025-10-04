package com.example.HotelBookingManagementSystem.restcontroller;

import com.example.HotelBookingManagementSystem.dto.LocationDTO;
import com.example.HotelBookingManagementSystem.entity.Location;
import com.example.HotelBookingManagementSystem.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/location")
@CrossOrigin("*")
public class LocationRestController {


    @Autowired
    private LocationService locationService;

    @GetMapping("/all")
    public ResponseEntity<List<LocationDTO>> getAllLocations() {
        return ResponseEntity.ok(locationService.getAllLocations());
    }


    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> saveLocation(
            @RequestPart("location") Location location,
            @RequestPart("image") MultipartFile file
    ) throws IOException {
        locationService.saveLocation(location, file);

        Map<String, String> res = new HashMap<>();
        res.put("message", "Location saved successfully");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }



    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteLocation(@PathVariable int id) {
        boolean deleted = locationService.deleteLocation(id);
        if (deleted) {
            return ResponseEntity.ok("Location deleted successfully");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Location not found");
        }
    }



    @PutMapping("/update/{id}")
    public ResponseEntity<Location> updateLocation(
            @PathVariable int id,
            @RequestPart Location location,
            @RequestParam(value = "image", required = true) MultipartFile file
    )

            throws IOException {
        Location updatedLocation = locationService.updateLocation(id, location,file);
        return ResponseEntity.ok().body(updatedLocation);
    }


}
