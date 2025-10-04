package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.HotelDTO;
import com.example.HotelBookingManagementSystem.dto.LocationDTO;
import com.example.HotelBookingManagementSystem.entity.Hotel;
import com.example.HotelBookingManagementSystem.entity.HotelAdmin;
import com.example.HotelBookingManagementSystem.entity.Location;
import com.example.HotelBookingManagementSystem.entity.Room;
import com.example.HotelBookingManagementSystem.repository.HotelAdminRepository;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import com.example.HotelBookingManagementSystem.repository.LocationRepository;
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
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class HotelService {
    @Autowired
    private HotelRepository hotelRepository;
    @Autowired
    private LocationRepository locationRepository;

    @Autowired
    private HotelAdminRepository hotelAdminRepository;

    @Value("src/main/resources/static/images")
    private String uploadDir;

    public List<HotelDTO> getAllHotels() {
        List<Hotel> hotels = hotelRepository.findAll();

        return hotels.stream().map(hotel -> {
            // Create LocationDTO if location exists
            LocationDTO locationDTO = null;
            if (hotel.getLocation() != null) {
                locationDTO = new LocationDTO(
                        hotel.getLocation().getId(),
                        hotel.getLocation().getName(),
                        hotel.getLocation().getImage()
                );
            }

            // Create HotelDTO
            HotelDTO dto = new HotelDTO(
                    hotel.getId(),
                    hotel.getName(),
                    hotel.getAddress(),
                    hotel.getRating(),
                    hotel.getImage(),
                    locationDTO
            );

            return dto;
        }).collect(Collectors.toList());
    }

    public Hotel saveHotel(HotelDTO hotelDTO, MultipartFile image, HotelAdmin admin) throws IOException {
        Hotel hotel = new Hotel();
        hotel.setName(hotelDTO.getName());
        hotel.setAddress(hotelDTO.getAddress());
        hotel.setRating(hotelDTO.getRating());

        // Set Location
        Location location = locationRepository.findById(hotelDTO.getLocation().getId())
                .orElseThrow(() -> new RuntimeException("Location not found"));

        hotel.setLocation(location);

        // Set Admin
        hotel.setHotelAdmin(admin);

        // Handle Image
        if (image != null && !image.isEmpty()) {
            Path uploadPath = Paths.get(uploadDir + "/hotels");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            String fileName = System.currentTimeMillis() + "_" + image.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(image.getInputStream(), filePath);
            hotel.setImage(fileName);
        }

        return hotelRepository.save(hotel);
    }



    public HotelDTO findHotelById(long id) {
        Hotel hotel = hotelRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Hotel with id: " + id + " not found!"));

        // Entity → DTO রূপান্তর
        return mapToDTO(hotel);
    }

    private HotelDTO mapToDTO(Hotel hotel) {
        LocationDTO locationDTO = null;
        if (hotel.getLocation() != null) {
            locationDTO = new LocationDTO(
                    hotel.getLocation().getId(),
                    hotel.getLocation().getName(),
                    hotel.getLocation().getImage()
            );
        }

        return new HotelDTO(
                hotel.getId(),
                hotel.getName(),
                hotel.getAddress(),
                hotel.getRating(),
                hotel.getImage(),
                locationDTO
        );
    }


    public Hotel findHotelByName(String name) {

        return hotelRepository.findByName(name)
                .orElseThrow(() -> new EntityNotFoundException("Hotel with id: " + name + " not found!"));
    }


    public List<Hotel> findHotelByLocationName(String locationName) {
        return hotelRepository.findHotelByLocationName(locationName);
    }


                    // for home page search

    public List<HotelDTO> searchHotels(Long locationId, String checkIn, String checkOut) {
        List<Hotel> hotels = hotelRepository.findHotelsByLocationId(locationId);


        return hotels.stream().map(hotel -> {
            LocationDTO locationDTO = null;
            if (hotel.getLocation() != null) {
                locationDTO = new LocationDTO(
                        hotel.getLocation().getId(),
                        hotel.getLocation().getName(),
                        hotel.getLocation().getImage()
                );
            }
            return new HotelDTO(
                    hotel.getId(),
                    hotel.getName(),
                    hotel.getAddress(),
                    hotel.getRating(),
                    hotel.getImage(),
                    locationDTO
            );
        }).collect(Collectors.toList());
    }

    public List<Room> getRoomsByHotelId(Long hotelId) {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new EntityNotFoundException("Hotel with id " + hotelId + " not found!"));
        return hotel.getRooms();
    }

    public List<HotelDTO> getHotelsByAdminId(int hotelAdminId) {
        List<Hotel> hotels = hotelRepository.findByHotelAdminId(hotelAdminId);
        return hotels.stream().map(hotel -> new HotelDTO(
                hotel.getId(),
                hotel.getName(),
                hotel.getAddress(),
                hotel.getRating(),
                hotel.getImage(),
                null
        )).collect(Collectors.toList());
    }


    public Hotel updateHotel(long id, Hotel updatehotel, MultipartFile imageFile) throws IOException {
        Hotel existingHotel = hotelRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Hotel with id: " + id + " not found!"));

        existingHotel.setName(updatehotel.getName());
        existingHotel.setAddress(updatehotel.getAddress());
        existingHotel.setRating(updatehotel.getRating());
        existingHotel.setImage(updatehotel.getImage());

        //update locations
        Location location = locationRepository.findById(updatehotel.getLocation().getId())
                .orElseThrow(() -> new EntityNotFoundException("Location with id: " + updatehotel.getLocation().getId() + " not found!"));

        existingHotel.setLocation(location);


        HotelAdmin hotelAdmin = hotelAdminRepository.findById(updatehotel.getHotelAdmin().getId())
                .orElseThrow(() -> new EntityNotFoundException("HotelAdmin with id: " + updatehotel.getHotelAdmin().getId() + " not found!"));


        existingHotel.setHotelAdmin(hotelAdmin);
        //update image

        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = saveImage(imageFile, existingHotel);

            existingHotel.setImage(fileName);
        }


        return hotelRepository.save(existingHotel);
    }

    public boolean deleteHotel(long id) {
        if (hotelRepository.existsById(id)) {
            hotelRepository.deleteById(id);
            return true;
        }
        return false;
    }


    private String saveImage(MultipartFile file, Hotel hotel) throws IOException {

        Path uploadPath = Paths.get(uploadDir + "/hotels");

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String hotelName = hotel.getName();
        String fileName = hotelName.trim().replaceAll("\\s+", "_");

        String savedFileName = fileName + "_" + UUID.randomUUID().toString();



        Path filePath = uploadPath.resolve(savedFileName);

        Files.copy(file.getInputStream(), filePath);

        return fileName;


    }



//    private String saveImage(MultipartFile file, Hotel hotel) throws IOException {
//        Path uploadPath = Paths.get(uploadDir + "/hotels");
//        if (!Files.exists(uploadPath)) {
//            Files.createDirectories(uploadPath);
//        }
//
//        // Preserve original file extension
//        String originalExtension = "";
//        String originalName = file.getOriginalFilename();
//        if (originalName != null && originalName.contains(".")) {
//            originalExtension = originalName.substring(originalName.lastIndexOf("."));
//        }
//
//        String fileName = hotel.getName() + "_" + UUID.randomUUID() + originalExtension;
//
//        Path filePath = uploadPath.resolve(fileName);
//        Files.copy(file.getInputStream(), filePath);
//
//        return fileName;
//    }

    public List<HotelDTO> findHotelByHotelAdminId(int hotelAdminId) {
        List<Hotel> hotels = hotelRepository.findByHotelAdminId(hotelAdminId);
        return hotels.stream().map(hotel -> new HotelDTO(
                hotel.getId(),
                hotel.getName(),
                hotel.getAddress(),
                hotel.getRating(),
                hotel.getImage(),
                null
        )).collect(Collectors.toList());
    }
}
