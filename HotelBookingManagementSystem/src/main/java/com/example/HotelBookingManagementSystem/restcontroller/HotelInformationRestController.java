package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.HotelInformationDTO;
import com.example.HotelBookingManagementSystem.service.HotelInformationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/hotel/information")
public class HotelInformationRestController {

    private final HotelInformationService hotelInformationService;

    public HotelInformationRestController(HotelInformationService hotelInformationService) {
        this.hotelInformationService = hotelInformationService;
    }

                            //  Create

    @PostMapping("/save")
    public ResponseEntity<HotelInformationDTO> saveHotelInfo(@RequestBody HotelInformationDTO dto) {
        return ResponseEntity.ok(hotelInformationService.saveHotelInfo(dto));
    }

                        //  Read (find by id)

    @GetMapping("/{id}")
    public ResponseEntity<HotelInformationDTO> getHotelInfoById(@PathVariable Long id) {
        return ResponseEntity.ok(hotelInformationService.getHotelInfoById(id));
    }

                             // Read (find all)

    @GetMapping("/all")
    public ResponseEntity<List<HotelInformationDTO>> getAllHotelInfo() {
        return ResponseEntity.ok(hotelInformationService.getAllHotelInfo());
    }

                            //  Update

    @PutMapping("/edit/{id}")
    public ResponseEntity<HotelInformationDTO> updateHotelInfo(@PathVariable Long id,
                                                               @RequestBody HotelInformationDTO dto) {
        return ResponseEntity.ok(hotelInformationService.updateHotelInfo(id, dto));
    }

                                // Delete

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteHotelInfo(@PathVariable Long id) {
        hotelInformationService.deleteHotelInfo(id);
        return ResponseEntity.ok("Hotel Information deleted successfully!");
    }

                    // Custom: Find by HotelId

    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<HotelInformationDTO> getHotelInfoByHotelId(@PathVariable Long hotelId) {
        return ResponseEntity.ok(hotelInformationService.findHotelInformationByHotelId(hotelId));
    }
}
