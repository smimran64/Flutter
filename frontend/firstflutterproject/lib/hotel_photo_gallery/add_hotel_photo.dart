import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../entity/hotel_model.dart';
import '../service/hotel_service.dart';
import '../service/hotel_photo_service.dart';

class AddHotelPhotoPage extends StatefulWidget {
  @override
  _AddHotelPhotoPageState createState() => _AddHotelPhotoPageState();
}

class _AddHotelPhotoPageState extends State<AddHotelPhotoPage>
    with SingleTickerProviderStateMixin {
  List<Hotel> hotels = [];
  Hotel? selectedHotel;
  List<XFile> selectedImages = [];
  bool isUploading = false;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    fetchHotels();

    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  Future<void> fetchHotels() async {
    try {
      hotels = await HotelService().getMyHotels();
      setState(() {});
    } catch (e) {
      print("Failed to fetch hotels: $e");
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null) {
      selectedImages = picked;
      _controller.reset();
      _controller.forward();
      setState(() {});
    }
  }

  Future<void> uploadImages() async {
    if (selectedHotel == null || selectedImages.isEmpty) return;

    setState(() => isUploading = true);

    try {
      var uploadedPhotos = await HotelPhotoService().uploadHotelPhotos(
        selectedHotel!.id!,
        selectedImages,
      );

      setState(() {
        selectedImages.clear();
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Uploaded ${uploadedPhotos.length} photo(s)!")),
      );
    } catch (e) {
      print("Upload failed: $e");
      setState(() => isUploading = false);
    }
  }

  Future<Uint8List> readFileBytes(XFile file) async {
    return await file.readAsBytes();
  }

  Widget buildImagePreview(XFile file) {
    return FadeTransition(
      opacity: _fadeIn,
      child: FutureBuilder<Uint8List>(
        future: readFileBytes(file),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.all(6),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(3, 3),
                  ),
                ],
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.contain,
                ),
              ),
            );
          } else {
            return Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get primaryColor => Colors.teal.shade400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text("Add Hotel Photos"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Hotel>(
              decoration: InputDecoration(
                labelText: "Select Hotel",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedHotel,
              isExpanded: true,
              onChanged: (Hotel? value) {
                setState(() {
                  selectedHotel = value;
                });
              },
              items: hotels.map((Hotel hotel) {
                return DropdownMenuItem<Hotel>(
                  value: hotel,
                  child: Text(hotel.name),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: pickImages,
              icon: Icon(Icons.photo_library),
              label: Text("Pick Images"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            if (selectedImages.isNotEmpty)
              Wrap(
                spacing: 10,
                children: selectedImages.map(buildImagePreview).toList(),
              ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isUploading ? null : uploadImages,
                icon: isUploading
                    ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : Icon(Icons.cloud_upload),
                label: Text(isUploading ? "Uploading..." : "Upload Photos"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUploading ? Colors.grey : primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
