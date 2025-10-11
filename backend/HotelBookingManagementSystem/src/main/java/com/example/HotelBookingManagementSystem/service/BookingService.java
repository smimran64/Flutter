package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.BookingDTO;
import com.example.HotelBookingManagementSystem.dto.CustomerDTO;
import com.example.HotelBookingManagementSystem.dto.HotelDTO;
import com.example.HotelBookingManagementSystem.dto.RoomDTO;
import com.example.HotelBookingManagementSystem.entity.Booking;
import com.example.HotelBookingManagementSystem.entity.Customer;
import com.example.HotelBookingManagementSystem.entity.Hotel;
import com.example.HotelBookingManagementSystem.entity.Room;
import com.example.HotelBookingManagementSystem.repository.BookingRepository;
import com.example.HotelBookingManagementSystem.repository.CustomerRepository;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import com.example.HotelBookingManagementSystem.repository.RoomRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final RoomRepository roomRepository;
    private final CustomerRepository customerRepository;
    private final HotelRepository hotelRepository;

    public BookingService(BookingRepository bookingRepository, RoomRepository roomRepository,
                          CustomerRepository customerRepository, HotelRepository hotelRepository) {
        this.bookingRepository = bookingRepository;
        this.roomRepository = roomRepository;
        this.customerRepository = customerRepository;
        this.hotelRepository = hotelRepository;
    }

                //Create Booking with all calculation

    @Transactional
    public BookingDTO createBooking(BookingDTO bookingDTO) {


        System.out.println(bookingDTO.getRoomdto().getId()+"1111111111111111111111111111111111111111111111");
        // Validate nested DTOs
        if (bookingDTO.getRoomdto() == null) {
            throw new RuntimeException("RoomDTO cannot be null");
        }
        if (bookingDTO.getCustomerdto() == null) {
            throw new RuntimeException("CustomerDTO cannot be null");
        }
        if (bookingDTO.getHoteldto() == null) {
            throw new RuntimeException("HotelDTO cannot be null");
        }



        Room room = roomRepository.findById(bookingDTO.getRoomdto().getId())
                .orElseThrow(() -> new RuntimeException("Room not found"));

        Customer customer = customerRepository.findById(bookingDTO.getCustomerdto().getId())
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        Hotel hotel = hotelRepository.findById(bookingDTO.getHoteldto().getId())
                .orElseThrow(() -> new RuntimeException("Hotel not found"));

        //Check room availability
        if (room.getAvailableRooms() < bookingDTO.getNumberOfRooms()) {
            throw new RuntimeException("Not enough available rooms");
        }

        //Calculate days between check-in and check-out
        Date checkIn = bookingDTO.getCheckIn();
        Date checkOut = bookingDTO.getCheckOut();
        long diffInMillies = checkOut.getTime() - checkIn.getTime();
        long days = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
        if (days <= 0) {
            throw new RuntimeException("Check-out date must be after check-in date");
        }

        // Calculate total
        double totalPrice = room.getPrice() * bookingDTO.getNumberOfRooms() * days;

        // Apply discount
        if (bookingDTO.getDiscountRate() > 0) {
            totalPrice -= totalPrice * bookingDTO.getDiscountRate() / 100;
        }

        double advance = bookingDTO.getAdvanceAmount();
        double due = totalPrice - advance;

        // Create booking entity
        Booking booking = new Booking();
        booking.setContractPersonName(bookingDTO.getContractPersonName());
        booking.setPhone(bookingDTO.getPhone());
        booking.setCheckIn(checkIn);
        booking.setCheckOut(checkOut);
        booking.setNumberOfRooms(bookingDTO.getNumberOfRooms());
        booking.setDiscountRate(bookingDTO.getDiscountRate());
        booking.setAdvanceAmount(advance);
        booking.setTotalAmount(totalPrice);
        booking.setDueAmount(due);
        booking.setRoom(room);
        booking.setHotel(hotel);
        booking.setCustomer(customer);

        // Update room availability
        room.setAvailableRooms(room.getAvailableRooms() - bookingDTO.getNumberOfRooms());
        room.setBookedRooms(room.getBookedRooms() + bookingDTO.getNumberOfRooms());

        // Save
        roomRepository.save(room);
        Booking savedBooking = bookingRepository.save(booking);

        return mapToDTO(savedBooking);
    }





//    @Transactional
//    public BookingDTO createBooking(BookingDTO bookingDTO) {
//
//        Room room = roomRepository.findById(bookingDTO.getRoomdto().getId())
//                .orElseThrow(() -> new RuntimeException("Room not found"));
//
//        Customer customer = customerRepository.findById(bookingDTO.getCustomerdto().getId())
//                .orElseThrow(() -> new RuntimeException("Customer not found"));
//
//        Hotel hotel = hotelRepository.findById(bookingDTO.getHoteldto().getId())
//                .orElseThrow(() -> new RuntimeException("Hotel not found"));
//
//                    //Check room availability
//
//        if (room.getAvailableRooms() < bookingDTO.getNumberOfRooms()) {
//            throw new RuntimeException("Not enough available rooms");
//        }
//
//                    //Calculate days between check-in and check-out
//
//        Date checkIn = bookingDTO.getCheckIn();
//        Date checkOut = bookingDTO.getCheckOut();
//        long diffInMillies = checkOut.getTime() - checkIn.getTime();
//        long days = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
//
//        if (days <= 0) {
//            throw new RuntimeException("Check-out date must be after check-in date");
//        }
//
//                    // Base total calculation
//
//        double totalPrice = room.getPrice() * bookingDTO.getNumberOfRooms() * days;
//
//                    //Apply discount calculation
//
//
//        if (bookingDTO.getDiscountRate() > 0) {
//            totalPrice = totalPrice - (totalPrice * bookingDTO.getDiscountRate() / 100);
//        }
//
//                    // Due calculation
//
//
//        double advance = bookingDTO.getAdvanceAmount();
//        double due = totalPrice - advance;
//
//        // Create Booking entity
//
//        Booking booking = new Booking();
//        booking.setContractPersonName(bookingDTO.getContractPersonName());
//        booking.setPhone(bookingDTO.getPhone());
//        booking.setCheckIn(checkIn);
//        booking.setCheckOut(checkOut);
//        booking.setNumberOfRooms(bookingDTO.getNumberOfRooms());
//        booking.setDiscountRate(bookingDTO.getDiscountRate());
//        booking.setAdvanceAmount(advance);
//        booking.setTotalAmount(totalPrice);
//        booking.setDueAmount(due);
//        booking.setRoom(room);
//        booking.setHotel(hotel);
//        booking.setCustomer(customer);
//
//        // Update room availability
//
//        room.setAvailableRooms(room.getAvailableRooms() - bookingDTO.getNumberOfRooms());
//        room.setBookedRooms(room.getBookedRooms() + bookingDTO.getNumberOfRooms());
//
//        // Save
//
//        roomRepository.save(room);
//        Booking savedBooking = bookingRepository.save(booking);
//
//        return mapToDTO(savedBooking);
//    }

                //Delete Booking and restore room availability

    @Transactional
    public void deleteBooking(Long id) {
        Booking existingBooking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        Room room = existingBooking.getRoom();

        room.setAvailableRooms(room.getAvailableRooms() + existingBooking.getNumberOfRooms());
        room.setBookedRooms(room.getBookedRooms() - existingBooking.getNumberOfRooms());

        roomRepository.save(room);
        bookingRepository.delete(existingBooking);
    }

                // Find by customer id

    public List<BookingDTO> getBookingsByCustomerId(Long customerId) {
        return bookingRepository.findBookingsByCustomerId(customerId)
                .stream().map(this::mapToDTO).collect(Collectors.toList());
    }

                        // Find by hotel id

    public List<BookingDTO> getBookingsByHotelId(Long hotelId) {
        return bookingRepository.findBookingsByHotelId(hotelId)
                .stream().map(this::mapToDTO).collect(Collectors.toList());
    }

                            //Find by room id

    public List<BookingDTO> getBookingsByRoomId(Long roomId) {
        return bookingRepository.findBookingsByRoomId(roomId)
                .stream().map(this::mapToDTO).collect(Collectors.toList());
    }

                            //Find by booking id

    public BookingDTO getBookingById(Long id) {
        return bookingRepository.findById(id)
                .map(this::mapToDTO)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
    }

    // ================== Mapping Methods ==================
    private BookingDTO mapToDTO(Booking booking) {
        BookingDTO dto = new BookingDTO();
        dto.setId(booking.getId());
        dto.setContractPersonName(booking.getContractPersonName());
        dto.setPhone(booking.getPhone());
        dto.setCheckIn(booking.getCheckIn());
        dto.setCheckOut(booking.getCheckOut());
        dto.setNumberOfRooms(booking.getNumberOfRooms());
        dto.setDiscountRate(booking.getDiscountRate());
        dto.setTotalAmount(booking.getTotalAmount());
        dto.setAdvanceAmount(booking.getAdvanceAmount());
        dto.setDueAmount(booking.getDueAmount());

        if (booking.getCustomer() != null) {
            dto.setCustomerdto(new CustomerDTO(
                    booking.getCustomer().getId(),
                    booking.getCustomer().getName(),
                    booking.getCustomer().getEmail(),
                    booking.getCustomer().getPhone(),
                    booking.getCustomer().getAddress(),
                    booking.getCustomer().getGender(),
                    booking.getCustomer().getDateOfBirth(),
                    booking.getCustomer().getImage()
            ));
        }

        if (booking.getHotel() != null) {
            dto.setHoteldto(new HotelDTO(
                    booking.getHotel().getId(),
                    booking.getHotel().getName(),
                    booking.getHotel().getAddress(),
                    booking.getHotel().getRating(),
                    booking.getHotel().getImage(),
                    null
            ));
        }

        if (booking.getRoom() != null) {
            dto.setRoomdto(new RoomDTO(
                    booking.getRoom().getId(),
                    booking.getRoom().getRoomType(),
                    booking.getRoom().getImage(),
                    booking.getRoom().getTotalRooms(),
                    booking.getRoom().getAdults(),
                    booking.getRoom().getChildren(),
                    booking.getRoom().getPrice(),
                    booking.getRoom().getAvailableRooms(),
                    booking.getRoom().getBookedRooms(),
                    null
            ));
        }

        return dto;
    }


}
