import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../entity/hotel_model.dart';
import '../entity/hotel_photo_model.dart';
import '../service/hotel_photo_service.dart';
import '../service/hotel_service.dart';

class ViewGalleryPage extends StatefulWidget {
  @override
  _ViewGalleryPageState createState() => _ViewGalleryPageState();
}

class _ViewGalleryPageState extends State<ViewGalleryPage> {
  final String imageBaseUrl = 'http://localhost:8082'; // Your backend base URL

  List<Hotel> hotels = [];
  Hotel? selectedHotel;
  List<HotelPhoto> photos = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    try {
      hotels = await HotelService().getMyHotels();
      setState(() {});
    } catch (e) {
      print("Failed to fetch hotels: $e");
    }
  }

  Future<void> loadPhotos(int hotelId) async {
    setState(() {
      isLoading = true;
      photos = [];
    });

    try {
      photos = await HotelPhotoService().getPhotosByHotelId(hotelId);
      setState(() => isLoading = false);
    } catch (e) {
      print("Failed to load photos: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildHotelDropdown() {
    return DropdownButtonFormField<Hotel>(
      decoration: InputDecoration(
        labelText: "Select Hotel",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: selectedHotel,
      isExpanded: true,
      onChanged: (Hotel? value) {
        setState(() {
          selectedHotel = value;
        });
        if (value != null) {
          loadPhotos(value.id!);
        }
      },
      items: hotels.map((Hotel hotel) {
        return DropdownMenuItem<Hotel>(
          value: hotel,
          child: Text(hotel.name),
        );
      }).toList(),
    );
  }

  Widget buildPhotoGrid() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_album_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text("No photos available for this hotel."),
          ],
        ).animate().fade(duration: 600.ms).scale(),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: photos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1, // Make it square
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        final imageUrl = '$imageBaseUrl${photo.photoUrl}';

        return DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(16),
          dashPattern: [6, 3],
          color: Colors.tealAccent,
          strokeWidth: 2,
          padding: EdgeInsets.zero, // Important to remove extra space
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.shade200, // fallback background
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loading) {
                  if (loading == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
          ),
        )
            .animate()
            .fade(duration: 500.ms, delay: (100 * index).ms)
            .scale()
            .moveY(begin: 20, curve: Curves.easeOut);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text("Hotel Photo Gallery"),
        backgroundColor: Colors.teal.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildHotelDropdown(),
            SizedBox(height: 20),
            // Make grid scrollable by wrapping it with Expanded + scroll
            Expanded(
              child: photos.isEmpty && !isLoading
                  ? Center(child: Text("No photos available"))
                  : buildPhotoGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
