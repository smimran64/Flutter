import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:flutter/material.dart';

class ViewAllHotel extends StatefulWidget {
  const ViewAllHotel({super.key});

  @override
  State<ViewAllHotel> createState() => _ViewAllHotelState();
}

HotelService _hotelService = HotelService();

class _ViewAllHotelState extends State<ViewAllHotel> {

  late Future<List<Hotel>> _hotelsFuture;


  @override
  void initState() {
    super.initState();
    _hotelsFuture = HotelService().getAllHotels();
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://localhost:8082/images/hotels";
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Hotels"),
      ),

      body: FutureBuilder <List<Hotel>>(
          future: _hotelsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No hotels found."));
            }

            final hotels = snapshot.data!;

            return ListView.builder(

                itemCount: hotels.length,
                itemBuilder: (context, index) {
                  final hotel = hotels[index];

                  return Padding(

                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),

                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.
                                circular(12)),
                            child: Image.network(
                              // image url

                              '$baseUrl/${Uri.encodeComponent(
                                  hotel.image)}',

                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error,
                                  stackTrace) =>
                              const Icon(Icons.broken_image, size: 100),

                            ),
                          ),
                          // Hotel Info

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(
                              hotel.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hotel.address,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),

                            Row(
                                children: [
                                const Icon(Icons.star, color: Colors.orange,
                                size: 16),
                            const SizedBox(width: 4),
                            Text(hotel.rating),
                            const Spacer(),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.blueGrey),
                                  Text(hotel.location.name),
                                ],
                              ),
                            ]
                          )
                        ],

                      ),


                    ),
                    ],
                  ),

                  )
                  ,

                  );
                }
            );
          }
      ),
    );
  }
}
