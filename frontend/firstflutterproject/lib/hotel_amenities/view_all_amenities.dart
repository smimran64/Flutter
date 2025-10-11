

import 'package:firstflutterproject/entity/hotel_Aminities_model.dart';
import 'package:firstflutterproject/service/hotel_aminities_service.dart';
import 'package:flutter/material.dart';

class ViewAllAmenities extends StatefulWidget {
  const ViewAllAmenities({super.key});

  @override
  State<ViewAllAmenities> createState() => _ViewAllAmenitiesState();
}

class _ViewAllAmenitiesState extends State<ViewAllAmenities> {


  late Future<List<Amenities>> _futureAmenities;

 final HotelAminitiesService hotelAminitiesService = HotelAminitiesService();

  @override
  void initState() {

    super.initState();
    _futureAmenities = hotelAminitiesService.getAllAmenities();

  }

  Widget buildAmenity(String label, bool value) {
    return Row(
      children: [
        Icon(value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red, size: 18),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // ✅ Back to AdminProfilePage
            },
          ),

          title: const Text("All Hotel Amenities")
      ),
      body: FutureBuilder<List<Amenities>>(
        future: _futureAmenities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No amenities found"));
          }

          final amenitiesList = snapshot.data!;

          return ListView.builder(
            itemCount: amenitiesList.length,
            itemBuilder: (context, index) {
              final item = amenitiesList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.hotelName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          buildAmenity("Free Wifi", item.freeWifi),
                          buildAmenity("Parking", item.freeParking),
                          buildAmenity("Swimming Pool", item.swimmingPool),
                          buildAmenity("Gym", item.gym),
                          buildAmenity("Restaurant", item.restaurant),
                          buildAmenity("Room Service", item.roomService),
                          buildAmenity("AC", item.airConditioning),
                          buildAmenity("Laundry", item.laundryService),
                          buildAmenity("Wheelchair", item.wheelchairAccessible),
                          buildAmenity("Health", item.healthServices),
                          buildAmenity("Playground", item.playGround),
                          buildAmenity("Shuttle", item.airportSuttle),
                          buildAmenity("Breakfast", item.breakFast),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );;
  }


}
