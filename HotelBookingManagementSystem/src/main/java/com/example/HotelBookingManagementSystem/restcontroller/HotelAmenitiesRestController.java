package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.HotelAmenitiesDTO;
import com.example.HotelBookingManagementSystem.service.HotelAmenitiesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/amenities")
public class HotelAmenitiesRestController {

    @Autowired
    private HotelAmenitiesService hotelAmenitiesService;

                //  Add new amenities for a hotel


    @PostMapping("/save")
    public ResponseEntity<HotelAmenitiesDTO> addAmenities(@RequestBody HotelAmenitiesDTO dto) {
        HotelAmenitiesDTO saved = hotelAmenitiesService.addAmenities(dto);
        return ResponseEntity.ok(saved);
    }

                    //  Get all amenities


    @GetMapping("/all")
    public ResponseEntity<List<HotelAmenitiesDTO>> getAllAmenities() {
        return ResponseEntity.ok(hotelAmenitiesService.getAllAmenities());
    }

                    //  Get amenities by id

    @GetMapping("/{id}")
    public ResponseEntity<HotelAmenitiesDTO> getAmenitiesById(@PathVariable Long id) {
        Optional<HotelAmenitiesDTO> dto = hotelAmenitiesService.getAmenitiesById(id);
        return dto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

                        //  Get amenities by hotelId

    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<HotelAmenitiesDTO> getAmenitiesByHotelId(@PathVariable Long hotelId) {
        Optional<HotelAmenitiesDTO> dto = hotelAmenitiesService.findHotelAmenitiesByHotelId(hotelId);
        return dto.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

                        //  Update amenities

    @PutMapping("/edit/{id}")
    public ResponseEntity<HotelAmenitiesDTO> updateAmenities(@PathVariable Long id, @RequestBody HotelAmenitiesDTO dto) {
        HotelAmenitiesDTO updated = hotelAmenitiesService.updateAmenities(id, dto);
        return ResponseEntity.ok(updated);
    }

                //  Delete amenities

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteAmenities(@PathVariable Long id) {
        hotelAmenitiesService.deleteAmenities(id);
        return ResponseEntity.noContent().build();
    }
}
