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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Hotel Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.deepPurple.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0D3FF), Color(0xFFF9F7FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<Hotel>(
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
            final imageUrl =
                "http://localhost:8082/images/hotels/${hotel.image}";

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🌟 Fade-in Animation for Hotel Details
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 700),
                    child: Card(
                      color: Colors.white.withOpacity(0.9),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageUrl,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hotel.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hotel.address,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Location: ${hotel.location.name}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${hotel.rating} ⭐",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 🌐 Animated Fade-in for Rooms
                  FutureBuilder<List<Room>>(
                    future: futureRooms,
                    builder: (context, roomSnapshot) {
                      if (roomSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (roomSnapshot.hasError) {
                        return Text(
                          "Failed to load rooms: ${roomSnapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        );
                      } else if (!roomSnapshot.hasData ||
                          roomSnapshot.data!.isEmpty) {
                        return const Text("No rooms found for this hotel.");
                      }

                      final rooms = roomSnapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "🏨 Available Rooms",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rooms.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 180,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio:
                                      0.60, // ✅ Balanced ratio to avoid overflow
                                ),
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              final roomImageUrl =
                                  "http://localhost:8082/images/rooms/${room.image}";

                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 🖼 Image
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        roomImageUrl,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                height: 120,
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  height: 120,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.bed,
                                                    size: 60,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                                    ),

                                    // 🛏 Info + Button wrapped in Expanded
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              room.roomType,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "৳${room.price.toStringAsFixed(0)}",
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Adults: ${room.adults}, Children: ${room.children}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Available: ${room.availableRooms}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  // Save selected room & hotel info to SharedPreferences
                                                  SharedPreferences prefs =
                                                      await SharedPreferences.getInstance();
                                                  await prefs.setInt(
                                                    'hotelId',
                                                    hotel.id,
                                                  );
                                                  await prefs.setString(
                                                    'selectedHotel',
                                                    hotel.name,
                                                  );
                                                  await prefs.setString(
                                                    'selectedHotelAddress',
                                                    hotel.address,
                                                  );
                                                  await prefs.setString(
                                                    'selectedRoomType',
                                                    room.roomType,
                                                  );
                                                  await prefs.setInt(
                                                    'roomId',
                                                    room.id,
                                                  );
                                                  await prefs.setString(
                                                    'selectedPrice',
                                                    room.price.toString(),
                                                  );
                                                  await prefs.setString(
                                                    'selectedAdults',
                                                    room.adults.toString(),
                                                  );
                                                  await prefs.setString(
                                                    'selectedChildren',
                                                    room.children.toString(),
                                                  );

                                                  if (await authService
                                                          .isLoggedIn() &&
                                                      await authService
                                                          .isCustomer()) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            BookingsPage(),
                                                      ),
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
                                                              MaterialPageRoute(
                                                                builder: (_) =>
                                                                    BookingsPage(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.deepPurple,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
            );
          },
        ),
      ),
    );
  }
}
