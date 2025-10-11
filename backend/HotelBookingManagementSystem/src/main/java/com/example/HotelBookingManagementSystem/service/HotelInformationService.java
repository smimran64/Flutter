package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.HotelAmenitiesDTO;
import com.example.HotelBookingManagementSystem.dto.HotelInformationDTO;
import com.example.HotelBookingManagementSystem.entity.Hotel;
import com.example.HotelBookingManagementSystem.entity.HotelAmenities;
import com.example.HotelBookingManagementSystem.entity.HotelInformation;
import com.example.HotelBookingManagementSystem.repository.HotelAmenitiesRepository;
import com.example.HotelBookingManagementSystem.repository.HotelInformationRepository;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class HotelInformationService {

    private final HotelInformationRepository hotelInformationRepository;
    private final HotelRepository hotelRepository;

    public HotelInformationService(HotelInformationRepository hotelInformationRepository,
                                   HotelRepository hotelRepository) {
        this.hotelInformationRepository = hotelInformationRepository;
        this.hotelRepository = hotelRepository;
    }

                    //  Create


    public HotelInformationDTO saveHotelInfo(HotelInformationDTO dto) {
        Hotel hotel = hotelRepository.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel not found"));

        HotelInformation entity = new HotelInformation();
        entity.setOwnerSpeach(dto.getOwnerSpeach());
        entity.setDescription(dto.getDescription());
        entity.setHotelPolicy(dto.getHotelPolicy());
        entity.setHotel(hotel);

        HotelInformation saved = hotelInformationRepository.save(entity);

        return mapToDTO(saved);
    }

                        //  Read (find by id)

    public HotelInformationDTO getHotelInfoById(Long id) {
        HotelInformation entity = hotelInformationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("HotelInformation not found"));
        return mapToDTO(entity);
    }

                            //  Read (find all)

    public List<HotelInformationDTO> getAllHotelInfo() {
        return hotelInformationRepository.findAll()
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

                                //  Update

    public HotelInformationDTO updateHotelInfo(Long id, HotelInformationDTO dto) {
        HotelInformation entity = hotelInformationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("HotelInformation not found"));

        entity.setOwnerSpeach(dto.getOwnerSpeach());
        entity.setDescription(dto.getDescription());
        entity.setHotelPolicy(dto.getHotelPolicy());

        if (dto.getHotelId() != 0) {
            Hotel hotel = hotelRepository.findById(dto.getHotelId())
                    .orElseThrow(() -> new RuntimeException("Hotel not found"));
            entity.setHotel(hotel);
        }

        HotelInformation updated = hotelInformationRepository.save(entity);
        return mapToDTO(updated);
    }

                                // Delete

    public void deleteHotelInfo(Long id) {
        if (!hotelInformationRepository.existsById(id)) {
            throw new RuntimeException("HotelInformation not found");
        }
        hotelInformationRepository.deleteById(id);
    }

                            //  Custom method: Find by HotelId

    public HotelInformationDTO findHotelInformationByHotelId(Long hotelId) {
        HotelInformation entity = hotelInformationRepository.findHotelInformationByHotel_Id(hotelId)
                .orElseThrow(() -> new RuntimeException("HotelInformation not found for this hotel"));
        return mapToDTO(entity);
    }

                        //  Helper method to map Entity → DTO


    private HotelInformationDTO mapToDTO(HotelInformation entity) {
        return new HotelInformationDTO(
                entity.getId(),
                entity.getOwnerSpeach(),
                entity.getDescription(),
                entity.getHotelPolicy(),
                entity.getHotel().getId(),
                entity.getHotel().getName()
        );
    }
}
