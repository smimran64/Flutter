package com.example.HotelBookingManagementSystem.restcontroller;


import com.example.HotelBookingManagementSystem.dto.BookingDTO;
import com.example.HotelBookingManagementSystem.entity.Booking;
import com.example.HotelBookingManagementSystem.entity.Room;
import com.example.HotelBookingManagementSystem.repository.BookingRepository;
import com.example.HotelBookingManagementSystem.repository.RoomRepository;
import com.example.HotelBookingManagementSystem.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/booking")
public class BookingRestController {

    private final BookingService bookingService;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private RoomRepository roomRepository;

    public BookingRestController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping("/save")
    public ResponseEntity<BookingDTO> createBooking(@RequestBody BookingDTO bookingDTO) {
        BookingDTO savedBooking = bookingService.createBooking(bookingDTO);
        return ResponseEntity.ok(savedBooking);
    }

    @GetMapping("/customer/{customerId}")
    public ResponseEntity<List<BookingDTO>> getBookingsByCustomerId(@PathVariable Long customerId) {
        List<BookingDTO> bookings = bookingService.getBookingsByCustomerId(customerId);
        return ResponseEntity.ok(bookings);
    }

    @GetMapping("/{id}")
    public ResponseEntity<BookingDTO> getBookingById(@PathVariable Long id) {
        BookingDTO bookingDTO = bookingService.getBookingById(id);
        return ResponseEntity.ok(bookingDTO);
    }


    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<List<BookingDTO>> getBookingsByHotelId(@PathVariable Long hotelId) {
        List<BookingDTO> bookings = bookingService.getBookingsByHotelId(hotelId);
        return ResponseEntity.ok(bookings);
    }

    @GetMapping("/room/{roomId}")
    public ResponseEntity<List<BookingDTO>> getBookingsByRoomId(@PathVariable Long roomId) {
        List<BookingDTO> bookings = bookingService.getBookingsByRoomId(roomId);
        return ResponseEntity.ok(bookings);
    }


    //  Delete booking
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBooking(@PathVariable Long id) {
        bookingService.deleteBooking(id);
        return ResponseEntity.noContent().build();
    }

}
