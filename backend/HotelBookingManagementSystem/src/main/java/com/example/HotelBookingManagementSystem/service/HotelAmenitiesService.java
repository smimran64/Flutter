package com.example.HotelBookingManagementSystem.service;


import com.example.HotelBookingManagementSystem.dto.HotelAmenitiesDTO;
import com.example.HotelBookingManagementSystem.entity.Hotel;
import com.example.HotelBookingManagementSystem.entity.HotelAmenities;
import com.example.HotelBookingManagementSystem.repository.HotelAmenitiesRepository;
import com.example.HotelBookingManagementSystem.repository.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class HotelAmenitiesService {

    @Autowired
    private HotelAmenitiesRepository hotelAmenitiesRepository;

    @Autowired
    private HotelRepository hotelRepository;

                    //  Add Amenities for a Hotel

    public HotelAmenitiesDTO addAmenities(HotelAmenitiesDTO dto) {
        Hotel hotel = hotelRepository.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel not found with id " + dto.getHotelId()));

        HotelAmenities entity = mapToEntity(dto, hotel);
        HotelAmenities saved = hotelAmenitiesRepository.save(entity);

        return mapToDTO(saved);
    }

                //  Get all amenities (with hotel info)

    public List<HotelAmenitiesDTO> getAllAmenities() {
        return hotelAmenitiesRepository.findAll()
                .stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

            //  Get amenities by ID

    public Optional<HotelAmenitiesDTO> getAmenitiesById(Long id) {
        return hotelAmenitiesRepository.findById(id).map(this::mapToDTO);
    }
            // Get amenities by hotel id

    public Optional<HotelAmenitiesDTO> findHotelAmenitiesByHotelId(Long hotelId) {
        return hotelAmenitiesRepository.findHotelAmenitiesByHotelId(hotelId)
                .map(this::mapToDTO); // entity → dto
    }

                    //  Update amenities

    public HotelAmenitiesDTO updateAmenities(Long id, HotelAmenitiesDTO dto) {
        HotelAmenities entity = hotelAmenitiesRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Amenities not found with id " + id));

        Hotel hotel = hotelRepository.findById(dto.getHotelId())
                .orElseThrow(() -> new RuntimeException("Hotel not found with id " + dto.getHotelId()));

        entity.setFreeWifi(dto.isFreeWifi());
        entity.setFreeParking(dto.isFreeParking());
        entity.setSwimmingPool(dto.isSwimmingPool());
        entity.setGym(dto.isGym());
        entity.setRestaurant(dto.isRestaurant());
        entity.setRoomService(dto.isRoomService());
        entity.setAirConditioning(dto.isAirConditioning());
        entity.setLaundryService(dto.isLaundryService());
        entity.setWheelchairAccessible(dto.isWheelchairAccessible());
        entity.setHealthServices(dto.isHealthServices());
        entity.setPlayGround(dto.isPlayGround());
        entity.setAirportSuttle(dto.isAirportSuttle());
        entity.setBreakFast(dto.isBreakFast());
        entity.setHotel(hotel);

        HotelAmenities updated = hotelAmenitiesRepository.save(entity);
        return mapToDTO(updated);
    }

                //  Delete amenities

    public void deleteAmenities(Long id) {
        hotelAmenitiesRepository.deleteById(id);
    }

    private HotelAmenitiesDTO mapToDTO(HotelAmenities entity) {
        return new HotelAmenitiesDTO(
                entity.getId(),
                entity.isFreeWifi(),
                entity.isFreeParking(),
                entity.isSwimmingPool(),
                entity.isGym(),
                entity.isRestaurant(),
                entity.isRoomService(),
                entity.isAirConditioning(),
                entity.isLaundryService(),
                entity.isWheelchairAccessible(),
                entity.isHealthServices(),
                entity.isPlayGround(),
                entity.isAirportSuttle(),
                entity.isBreakFast(),
                entity.getHotel().getId(),
                entity.getHotel().getName()
        );
    }

    private HotelAmenities mapToEntity(HotelAmenitiesDTO dto, Hotel hotel) {
        HotelAmenities entity = new HotelAmenities();
        entity.setId(dto.getId());
        entity.setFreeWifi(dto.isFreeWifi());
        entity.setFreeParking(dto.isFreeParking());
        entity.setSwimmingPool(dto.isSwimmingPool());
        entity.setGym(dto.isGym());
        entity.setRestaurant(dto.isRestaurant());
        entity.setRoomService(dto.isRoomService());
        entity.setAirConditioning(dto.isAirConditioning());
        entity.setLaundryService(dto.isLaundryService());
        entity.setWheelchairAccessible(dto.isWheelchairAccessible());
        entity.setHealthServices(dto.isHealthServices());
        entity.setPlayGround(dto.isPlayGround());
        entity.setAirportSuttle(dto.isAirportSuttle());
        entity.setBreakFast(dto.isBreakFast());
        entity.setHotel(hotel);
        return entity;
    }
}
