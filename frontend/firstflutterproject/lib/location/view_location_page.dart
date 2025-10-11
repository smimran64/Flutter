

import 'package:firstflutterproject/entity/location_model.dart';
import 'package:firstflutterproject/service/location_service.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<Location> locations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final fetchedLocations = await LocationService().getAllLocations();
    setState(() {
      locations = fetchedLocations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final String baseUrl = "http://localhost:8082/images/locations";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: locations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75, // Adjust height/width ratio
          ),
          itemBuilder: (context, index) {
            final location = locations[index];
            final imageUrl = '$baseUrl/${Uri.encodeComponent(location.image)}';

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image, size: 40),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.deepPurple.shade50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: Text(
                      location.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
