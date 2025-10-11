

import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/hotel_details_service.dart';
import 'package:flutter/material.dart';


class HotelDetailsPage extends StatefulWidget {

  final int hotelId;

  const HotelDetailsPage({super.key, required this.hotelId});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {

  late Future<Hotel> futureHotel;
  final HotelDetailsService hotelDetailsService = HotelDetailsService();


  @override
  void initState() {
    super.initState();
    
    futureHotel = hotelDetailsService.getHotelById(widget.hotelId);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Hotel Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.2,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 3,
      ),
      body: FutureBuilder<Hotel>(
        future: futureHotel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No hotel details found"));
          }

          final hotel = snapshot.data!;
          final imageUrl = "http://localhost:8082/images/hotels/${hotel.image}";

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000), // 👈 web এ center box
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🏨 Hotel Image (responsive)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 480,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🏨 Hotel Name
                        Text(
                          hotel.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ⭐ Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.black, size: 22),
                            const SizedBox(width: 4),
                            Text(
                              "${hotel.rating} Star Hotel",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 📍 Address
                        Text(
                          hotel.address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 25),

                        // 🌍 Location Info (simple text)
                        Text(
                          "Location: ${hotel.location.name}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Location ID: ${hotel.location.id}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );


  }
}
