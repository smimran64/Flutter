

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
        title: Text('Locations'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image from network or placeholder
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),


                  child: Image.network(
                    '$baseUrl/${Uri.encodeComponent(location.image)} ', // change as per your backend setup
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey,
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    location.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
