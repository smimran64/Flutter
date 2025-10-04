package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.LocationDTO;
import com.example.HotelBookingManagementSystem.entity.Location;
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
public class LocationService {
    @Autowired
    private LocationRepository locationRepository;

    Location location = new Location();


    @Value("src/main/resources/static/images")
    private String uploadDir;

    public List<LocationDTO> getAllLocations() {
        return locationRepository.findAll()
                .stream()
                .map(loc -> new LocationDTO(loc.getId(), loc.getName(), loc.getImage()))
                .collect(Collectors.toList());
    }


    public void saveLocation(Location location, MultipartFile imageFile) throws IOException {

        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFileName = saveImage(imageFile, location);

            location.setImage(imageFileName);
        }

        locationRepository.save(location);
    }

    public Location getLocationById(long id) {

        return locationRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Location with id: " + id + " not found!"));

    }

    public boolean deleteLocation(long id) {
        if (locationRepository.existsById(id)) {
            locationRepository.deleteById(id);
            return true;
        }
        return false;
    }


    public Location updateLocation(long id, Location updateLocation, MultipartFile imageFile) throws IOException {

        Location existingLocation = locationRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Location with id: " + id + " not found!"));
        if (updateLocation.getName() != null) {
            existingLocation.setName(updateLocation.getName());
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = saveImage(imageFile, existingLocation);

            existingLocation.setImage(fileName);
        }

        return locationRepository.save(existingLocation);
    }


    public void updateLocation(Location location) {
        locationRepository.save(location);
    }


    private String saveImage(MultipartFile file, Location location) throws IOException {

        Path uploadPath = Paths.get(uploadDir + "/locations");

        if (!Files.exists(uploadPath)) {
            Files.createDirectory(uploadPath);
        }
//        String locationName = location.getName();
//        String saveFileName = locationName.trim().replaceAll("\\s+", "_");

        String fileName = location.getName() + "_" + UUID.randomUUID();

        Path filePath = uploadPath.resolve(fileName);

        Files.copy(file.getInputStream(), filePath);

        return fileName;


    }
}
