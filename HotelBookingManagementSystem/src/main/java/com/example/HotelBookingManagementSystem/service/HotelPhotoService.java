package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.HotelPhotoDTO;
import com.example.HotelBookingManagementSystem.entity.Hotel;
import com.example.HotelBookingManagementSystem.entity.HotelPhoto;
import com.example.HotelBookingManagementSystem.repository.HotelPhotoRepository;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class HotelPhotoService {


    private final HotelRepository hotelRepository;
    private final HotelPhotoRepository photoRepository;





    @Value("src/main/resources/static/images")
    private String uploadDir;


    public HotelPhotoService(HotelRepository hotelRepository, HotelPhotoRepository photoRepository) {
        this.hotelRepository = hotelRepository;
        this.photoRepository = photoRepository;
    }


                //Get all photos for a specific hotel


    // Get all photos for a hotel → return DTO list
    public List<HotelPhotoDTO> getPhotosByHotelId(Long hotelId) {
        List<HotelPhoto> photos = photoRepository.findByHotelId(hotelId);
        List<HotelPhotoDTO> dtos = new ArrayList<>();
        for (HotelPhoto photo : photos) {
            dtos.add(mapToDTO(photo));
        }
        return dtos;
    }

    // Delete a photo
    public void deletePhoto(Long photoId) throws IOException {
        HotelPhoto photo = photoRepository.findById(photoId)
                .orElseThrow(() -> new RuntimeException("Photo not found with id " + photoId));

        Path filePath = Paths.get(uploadDir, "gallery", Paths.get(photo.getPhotoUrl()).getFileName().toString());
        Files.deleteIfExists(filePath);

        photoRepository.delete(photo);
    }

    // Save multiple photos → return DTO list
    public List<HotelPhotoDTO> saveMultiplePhotos(Long hotelId, List<MultipartFile> files) throws IOException {
        Hotel hotel = hotelRepository.findById(hotelId)
                .orElseThrow(() -> new RuntimeException("Hotel not found with id " + hotelId));

        List<HotelPhotoDTO> savedDtos = new ArrayList<>();
        for (MultipartFile file : files) {
            String photoUrl = saveImage(file);
            HotelPhoto photo = new HotelPhoto();
            photo.setPhotoUrl(photoUrl);
            photo.setHotel(hotel);
            HotelPhoto savedPhoto = photoRepository.save(photo);

            savedDtos.add(mapToDTO(savedPhoto));
        }
        return savedDtos;
    }

    // Save single image to disk
    public String saveImage(MultipartFile file) throws IOException {
        Path uploadPath = Paths.get(uploadDir + "/gallery");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String originalName = file.getOriginalFilename();
        String cleanName = (originalName != null ? originalName.trim().replaceAll("\\s+", "_") : "photo");
        String savedFileName = UUID.randomUUID().toString() + "_" + cleanName;

        Path filePath = uploadPath.resolve(savedFileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return savedFileName;
    }

    // Map entity → DTO
    private HotelPhotoDTO mapToDTO(HotelPhoto photo) {
        return new HotelPhotoDTO(
                photo.getId(),
                "/images/gallery/" + photo.getPhotoUrl(), // full relative URL
                photo.getHotel().getId(),
                photo.getHotel().getName()
        );
    }


}
