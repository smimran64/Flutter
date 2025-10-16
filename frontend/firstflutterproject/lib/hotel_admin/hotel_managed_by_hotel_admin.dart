import 'package:flutter/material.dart';
import '../entity/hotel_model.dart';
import '../service/hotel_service.dart';

class MyHotelsPage extends StatefulWidget {
  const MyHotelsPage({super.key});

  @override
  State<MyHotelsPage> createState() => _MyHotelsPageState();
}

class _MyHotelsPageState extends State<MyHotelsPage> {
  late Future<List<Hotel>> _futureHotels;
  final HotelService _hotelService = HotelService();

  @override
  void initState() {
    super.initState();
    _futureHotels = _hotelService.getMyHotels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Hotels",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Hotel>>(
        future: _futureHotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final hotels = snapshot.data ?? [];

          if (hotels.isEmpty) {
            return const Center(child: Text("No hotels found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ======== IMAGE SECTION ========
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.network(
                        'http://localhost:8082/images/hotels/${hotel.image}',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 180,
                          child: Center(child: Icon(Icons.image_not_supported, size: 60)),
                        ),
                      ),
                    ),

                    // ======== HOTEL INFO SECTION ========
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            hotel.address,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                hotel.rating,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // ======== BUTTONS SECTION ========
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                ),
                                onPressed: () {
                                  // TODO: Edit hotel action
                                },
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                ),
                                onPressed: () {
                                  // TODO: Delete hotel action
                                },
                                icon: const Icon(Icons.delete, color: Colors.white),
                                label: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
