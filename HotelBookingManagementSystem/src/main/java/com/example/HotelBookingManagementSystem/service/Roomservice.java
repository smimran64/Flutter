package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.HotelDTO;
import com.example.HotelBookingManagementSystem.dto.LocationDTO;
import com.example.HotelBookingManagementSystem.dto.RoomDTO;
import com.example.HotelBookingManagementSystem.entity.Hotel;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.entity.Location;
import com.example.HotelBookingManagementSystem.entity.Room;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import com.example.HotelBookingManagementSystem.repository.RoomRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class Roomservice {

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private HotelRepository hotelRepository;


    @Value("src/main/resources/static/images")
    private String uploadDir;


    // ✅ Get all rooms - now returns proper RoomDTO with HotelDTO
    public List<RoomDTO> getAllRooms() {
        List<Room> rooms = roomRepository.findAll();

        return rooms.stream()
                .map(room -> new RoomDTO(
                        room.getId(),
                        room.getRoomType(),
                        room.getImage(),
                        room.getTotalRooms(),
                        room.getAdults(),
                        room.getChildren(),
                        room.getPrice(),
                        room.getAvailableRooms(),  // ✅ add availableRooms
                        room.getBookedRooms(),     // ✅ add bookedRooms
                        new HotelDTO(              // ✅ HotelDTO mapping
                                room.getHotel().getId(),
                                room.getHotel().getName(),
                                room.getHotel().getAddress(),
                                room.getHotel().getRating(),
                                room.getHotel().getImage(),
                                null // location pore lagle set kora jabe
                        )
                ))
                .collect(Collectors.toList());
    }



    public List<RoomDTO> getRoomsForHotelAdmin(int hotelAdminId) {
        List<Hotel> hotels = hotelRepository.findByHotelAdminId(hotelAdminId);
        if (hotels.isEmpty()) {
            throw new RuntimeException("No hotels found for this admin");
        }


        Hotel hotel = hotels.get(0);
        List<Room> rooms = roomRepository.findByHotelId(hotel.getId());
        return rooms.stream().map(this::mapToDTO).collect(Collectors.toList());
    }


    public List<RoomDTO> getRoomsByHotelId(long hotelId) {
        List<Room> rooms = roomRepository.findRoomByHotelId(hotelId);
        return rooms.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    public Optional<RoomDTO> findRoomById(long id) {
        return roomRepository.findById(id)
                .map(room -> new RoomDTO(
                        room.getId(),
                        room.getRoomType(),
                        room.getImage(),
                        room.getTotalRooms(),
                        room.getAdults(),
                        room.getChildren(),
                        room.getPrice(),
                        room.getAvailableRooms(),
                        room.getBookedRooms(),
                        new HotelDTO(
                                room.getHotel().getId(),
                                room.getHotel().getName(),
                                room.getHotel().getAddress(),
                                room.getHotel().getRating(),
                                room.getHotel().getImage(),
                                room.getHotel().getLocation() != null
                                        ? new LocationDTO(
                                        room.getHotel().getLocation().getId(),
                                        room.getHotel().getLocation().getName()

                                )
                                        : null
                        )
                ));
    }

    private RoomDTO mapToDTO(Room room) {
        return new RoomDTO(
                room.getId(),
                room.getRoomType(),
                room.getImage(),
                room.getTotalRooms(),
                room.getAdults(),
                room.getChildren(),
                room.getPrice(),
                room.getAvailableRooms(),
                room.getBookedRooms(),
                new HotelDTO(
                        room.getHotel().getId(),
                        room.getHotel().getName(),
                        room.getHotel().getAddress(),
                        room.getHotel().getRating(),
                        room.getHotel().getImage(),
                        null // location optional
                )
        );
    }

    public List<Room> findRoomByHotelName(String hotelName) {
        return roomRepository.findRoomByHotelName(hotelName);
    }



    public boolean deleteRoom(long id) {
        if (roomRepository.existsById(id)) {
            roomRepository.deleteById(id);
            return true;
        }
        return false;
    }


    // Save Room
    public void saveRoom(RoomDTO dto, MultipartFile imageFile, HotelAdmin hotelAdmin) throws IOException {
        Room room = new Room();
        room.setRoomType(dto.getRoomType());
        room.setAdults(dto.getAdults());
        room.setChildren(dto.getChildren());
        room.setTotalRooms(dto.getTotalRooms());
        room.setPrice(dto.getPrice());
        room.setAvailableRooms(dto.getTotalRooms());
        room.setBookedRooms(0);

        // Fetch hotel by ID

        Hotel hotel = hotelRepository.findById(dto.getHotelDTO().getId())
                .orElseThrow(() -> new EntityNotFoundException("Hotel not found with id: " + dto.getHotelDTO()));


        // Verify that the logged-in admin owns this hotel

        Integer hotelAdminId = hotel.getHotelAdmin() != null ? hotel.getHotelAdmin().getId() : null;
        if (hotel.getHotelAdmin() == null || hotel.getHotelAdmin().getId() != hotelAdmin.getId()) {
            throw new RuntimeException("You are not authorized to add rooms for this hotel");
        }


        room.setHotel(hotel);

        // Save image if provided
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFileName = saveImage(imageFile, room);
            room.setImage(imageFileName);
        }

        roomRepository.save(room);
    }

    // Roomservice.java - updateRoom method

    public Room updateRoom(long id, RoomDTO dto, MultipartFile imageFile, HotelAdmin hotelAdmin) throws IOException {
        Room existingRoom = roomRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Room not found with id: " + id));

        // Fetch hotel by ID from DTO
        Hotel hotel = hotelRepository.findById(dto.getHotelDTO().getId())
                .orElseThrow(() -> new EntityNotFoundException("Hotel not found with id: " + dto.getHotelDTO().getId()));

        // Verify that the logged-in admin owns this hotel
        Integer hotelAdminId = hotel.getHotelAdmin() != null ? hotel.getHotelAdmin().getId() : null;
        if (hotelAdminId == null || !hotelAdminId.equals(hotelAdmin.getId())) {
            throw new RuntimeException("You are not authorized to update rooms for this hotel");
        }

        // Update room fields
        existingRoom.setRoomType(dto.getRoomType());
        existingRoom.setAdults(dto.getAdults());
        existingRoom.setChildren(dto.getChildren());
        existingRoom.setTotalRooms(dto.getTotalRooms());
        existingRoom.setPrice(dto.getPrice());

        // Recalculate available rooms if totalRooms changed
        int booked = existingRoom.getBookedRooms();
        int newTotal = dto.getTotalRooms();
        existingRoom.setAvailableRooms(newTotal - booked);

        existingRoom.setHotel(hotel);

        // Update image if provided
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFileName = saveImage(imageFile, existingRoom);
            existingRoom.setImage(imageFileName);
        }

        return roomRepository.save(existingRoom);
    }


    private String saveImage(MultipartFile file, Room room) throws IOException {

        Path uploadPath = Paths.get(uploadDir + "/rooms");

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }


        String fileName = room.getRoomType() + "_" + UUID.randomUUID();

        Path filePath = uploadPath.resolve(fileName);

        Files.copy(file.getInputStream(), filePath);

        return fileName;


    }


}
