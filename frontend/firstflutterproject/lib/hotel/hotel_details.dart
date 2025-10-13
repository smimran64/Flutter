import 'package:firstflutterproject/bookings/bookings_page.dart';
import 'package:firstflutterproject/entity/hotel_information_model.dart';
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
  late Future<HotelInformation> futureHotelInfo;
  final HotelDetailsService hotelDetailsService = HotelDetailsService();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    futureHotel = hotelDetailsService.getHotelById(widget.hotelId);
    futureRooms = hotelDetailsService.fetchRoomByHotelId(widget.hotelId);
    futureHotelInfo = hotelDetailsService.fetchHotelInfo(widget.hotelId);
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              final roomImageUrl =
                                  "http://localhost:8082/images/rooms/${room.image}";

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                    await prefs.setInt('hotelId', hotel.id);
                                    await prefs.setString('selectedHotel', hotel.name);
                                    await prefs.setString('selectedHotelAddress', hotel.address);
                                    await prefs.setString('selectedRoomType', room.roomType);
                                    await prefs.setInt('roomId', room.id);
                                    await prefs.setString('selectedPrice', room.price.toString());
                                    await prefs.setString('selectedAdults', room.adults.toString());
                                    await prefs.setString('selectedChildren', room.children.toString());

                                    if (await authService.isLoggedIn() &&
                                        await authService.isCustomer()) {
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
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SizedBox(
                                      height: 140,
                                      child: Row(
                                        children: [
                                          // Left Half: Image
                                          Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.horizontal(
                                                left: Radius.circular(16),
                                              ),
                                              child: Image.network(
                                                roomImageUrl,
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      child: const Icon(
                                                        Icons.bed,
                                                        size: 60,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),

                                          // Right Half: Room Details
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )



                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  FutureBuilder<HotelInformation>(
                    future: futureHotelInfo,
                    builder: (context, infoSnapshot) {
                      if (infoSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (infoSnapshot.hasError) {
                        return Text(
                          "Error loading hotel info: ${infoSnapshot.error}",
                          style: const TextStyle(color: Colors.red),
                        );
                      } else if (!infoSnapshot.hasData) {
                        return const SizedBox(); // Nothing to show
                      }

                      final info = infoSnapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "🏨 Hotel Information",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            color: Colors.white.withOpacity(0.95),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "📣 Owner's Message",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    info.ownerSpeach,
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 16),

                                  const Text(
                                    "📝 Description",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    info.description,
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 16),

                                  const Text(
                                    "📜 Hotel Policy",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    info.hotelPolicy.trim().replaceAll(RegExp(r'\n+'), '\n\n'),
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
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
