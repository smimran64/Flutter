import 'package:flutter/material.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/hotel_photo_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/hotel_photo_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HotelPhotoGalleryPage extends StatefulWidget {
  const HotelPhotoGalleryPage({Key? key}) : super(key: key);

  @override
  State<HotelPhotoGalleryPage> createState() => _HotelPhotoGalleryPageState();
}

class _HotelPhotoGalleryPageState extends State<HotelPhotoGalleryPage> {
  Hotel? _selectedHotel;
  final String imageBaseUrl = 'http://localhost:8082';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Hotel Photo Gallery",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // Gradient Body Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9D2), Color(0xFFA6E3E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Hotel>>(
          future: HotelService().getAllHotels(),
          builder: (context, hotelSnapshot) {
            if (hotelSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (hotelSnapshot.hasError) {
              return Center(child: Text('Error: ${hotelSnapshot.error}'));
            } else if (!hotelSnapshot.hasData || hotelSnapshot.data!.isEmpty) {
              return const Center(child: Text('No hotels found'));
            }

            final hotels = hotelSnapshot.data!;
            _selectedHotel ??= hotels[0];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label with FontAwesome icon
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.hotel, size: 20, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        "Select Hotel",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedHotel?.id,
                      isExpanded: true,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                      items: hotels.map((hotel) {
                        return DropdownMenuItem<int>(
                          value: hotel.id,
                          child: Text(hotel.name),
                        );
                      }).toList(),
                      onChanged: (int? selectedId) {
                        if (selectedId != null) {
                          setState(() {
                            _selectedHotel = hotels.firstWhere((hotel) => hotel.id == selectedId);
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Photo Grid
                Expanded(
                  child: FutureBuilder<List<HotelPhoto>>(
                    future: HotelPhotoService().getPhotosByHotelId(_selectedHotel!.id),
                    builder: (context, photoSnapshot) {
                      if (photoSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (photoSnapshot.hasError) {
                        return Center(child: Text('Error: ${photoSnapshot.error}'));
                      } else if (!photoSnapshot.hasData || photoSnapshot.data!.isEmpty) {
                        return const Center(child: Text("No photos found"));
                      }

                      final photos = photoSnapshot.data!;

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          final photo = photos[index];
                          final imageUrl = '$imageBaseUrl${photo.photoUrl}';

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(2, 4),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loading) {
                                  if (loading == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
