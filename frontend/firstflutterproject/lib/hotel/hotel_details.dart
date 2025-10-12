

import 'package:firstflutterproject/bookings/bookings_page.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/room_model.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/hotel_details_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HotelDetailsPage extends StatefulWidget {

  final int hotelId;

  const HotelDetailsPage({super.key, required this.hotelId});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {

  late Future<Hotel> futureHotel;
  late Future<List<Room>> futureRooms;
  final HotelDetailsService hotelDetailsService = HotelDetailsService();
  final AuthService authService = AuthService();


  @override
  void initState() {
    super.initState();
    
    futureHotel = hotelDetailsService.getHotelById(widget.hotelId);
    futureRooms = hotelDetailsService.fetchRoomByHotelId(widget.hotelId);
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
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🌟 Hotel Details Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 🏨 Hotel Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: 480,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 100, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🛏️ Room List Section
                    FutureBuilder<List<Room>>(
                      future: futureRooms,
                      builder: (context, roomSnapshot) {
                        if (roomSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (roomSnapshot.hasError) {
                          return Text(
                            "Failed to load rooms: ${roomSnapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          );
                        } else if (!roomSnapshot.hasData || roomSnapshot.data!.isEmpty) {
                          return const Text("No rooms found for this hotel.");
                        }

                        final rooms = roomSnapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),

                            // 🌟 Stylish Title
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "🏨 Available Rooms",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // 🌐 Grid View of Rooms
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: rooms.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // 👈 3 rooms per row
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.9, // height/width ratio
                              ),
                              itemBuilder: (context, index) {
                                final room = rooms[index];
                                final roomImageUrl =
                                    "http://localhost:8082/images/rooms/${room.image}";

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Room Image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          roomImageUrl,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.bed_outlined, size: 60),
                                        ),
                                      ),

                                      // Make details flexible
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                room.roomType,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "৳${room.price.toStringAsFixed(0)}",
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Adults : ${room.adults} " " && "
                                                    "Children :${room.children} ",
                                                style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Available: ${room.availableRooms}",
                                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                              ),

                                              const Spacer(),

                                              // Book Button aligned at bottom inside details
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    // Save selected room & hotel info to SharedPreferences
                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    await prefs.setInt('hotelId', hotel.id );
                                                    await prefs.setString('selectedHotel', hotel.name);
                                                    await prefs.setString('selectedHotelAddress', hotel.address);
                                                    await prefs.setString('selectedRoomType', room.roomType);
                                                    await prefs.setInt('roomId', room.id );
                                                    await prefs.setString('selectedPrice', room.price.toString());
                                                    await prefs.setString('selectedAdults', room.adults.toString());
                                                    await prefs.setString('selectedChildren', room.children.toString());

                                                    if (await authService.isLoggedIn() && await authService.isCustomer()) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (_) => BookingsPage()),
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => Loginpage(
                                                            redirectAfterLogin: () async {
                                                              // After login, push BookingsPage
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (_) => BookingsPage()),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.deepPurple,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Book Now",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );



                              },
                            ),
                          ],
                        );
                      },
                    ),




                  ],
                ),
              ),
            ),
          );

        },
      ),
    );

  }
}
