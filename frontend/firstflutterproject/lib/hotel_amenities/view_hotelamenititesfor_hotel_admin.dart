

import 'package:flutter/material.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/hotel_Aminities_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/hotel_aminities_service.dart';

class ViewAllAmenitiesByHotelPage extends StatefulWidget {
  @override
  _ViewAllAmenitiesByHotelPageState createState() => _ViewAllAmenitiesByHotelPageState();
}

class _ViewAllAmenitiesByHotelPageState extends State<ViewAllAmenitiesByHotelPage> {
  final hotelService = HotelService();
  final amenitiesService = HotelAminitiesService();

  List<Hotel> hotels = [];
  Hotel? selectedHotel;
  Amenities? amenities;

  bool isLoadingHotels = true;
  bool isLoadingAmenities = false;

  @override
  void initState() {
    super.initState();
    loadHotels();
  }

  Future<void> loadHotels() async {
    try {
      List<Hotel> fetchedHotels = await hotelService.getMyHotels();
      setState(() {
        hotels = fetchedHotels;
        isLoadingHotels = false;
      });
    } catch (e) {
      setState(() => isLoadingHotels = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load hotels.")),
      );
    }
  }

  Future<void> fetchAmenities(int hotelId) async {
    setState(() {
      isLoadingAmenities = true;
      amenities = null;
    });

    Amenities? data = await amenitiesService.getAmenitiesByHotelId(hotelId);

    setState(() {
      amenities = data;
      isLoadingAmenities = false;
    });
  }

  Widget _buildAmenityRow(String title, bool value) {
    return ListTile(
      leading: Icon(
        value ? Icons.check_circle : Icons.cancel,
        color: value ? Colors.green : Colors.red,
      ),
      title: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Hotel Amenities"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoadingHotels
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Hotel>(
              decoration: InputDecoration(
                labelText: "Select a Hotel",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              value: selectedHotel,
              items: hotels.map((hotel) {
                return DropdownMenuItem<Hotel>(
                  value: hotel,
                  child: Text(hotel.name),
                );
              }).toList(),
              onChanged: (Hotel? value) {
                setState(() {
                  selectedHotel = value;
                });
                if (value != null) {
                  fetchAmenities(value.id);
                }
              },
              validator: (value) => value == null ? "Please select a hotel" : null,
            ),
            SizedBox(height: 20),

            if (isLoadingAmenities)
              Center(child: CircularProgressIndicator())
            else if (amenities != null)
              Expanded(
                child: ListView(
                  children: [
                    _buildAmenityRow("Free Wifi", amenities!.freeWifi),
                    _buildAmenityRow("Free Parking", amenities!.freeParking),
                    _buildAmenityRow("Swimming Pool", amenities!.swimmingPool),
                    _buildAmenityRow("Gym", amenities!.gym),
                    _buildAmenityRow("Restaurant", amenities!.restaurant),
                    _buildAmenityRow("Room Service", amenities!.roomService),
                    _buildAmenityRow("Air Conditioning", amenities!.airConditioning),
                    _buildAmenityRow("Laundry Service", amenities!.laundryService),
                    _buildAmenityRow("Wheelchair Accessible", amenities!.wheelchairAccessible),
                    _buildAmenityRow("Health Services", amenities!.healthServices),
                    _buildAmenityRow("Play Ground", amenities!.playGround),
                    _buildAmenityRow("Airport Shuttle", amenities!.airportSuttle),
                    _buildAmenityRow("Breakfast", amenities!.breakFast),
                  ],
                ),
              )
            else if (selectedHotel != null)
                Text("No amenities found for this hotel."),
          ],
        ),
      ),
    );
  }
}
