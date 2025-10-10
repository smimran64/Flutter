


import 'dart:convert';
import 'package:firstflutterproject/entity/location_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;

class LocationService{


  final String baseUrl = 'http://localhost:8082';


  Future<List<Location>> getAllLocations() async {
    // String? token = await AuthService().getToken();
    //
    // if (token == null) {
    //   print('No token found, please login first');
    //   return [];
    // }

    final url = Uri.parse('$baseUrl/api/location/all');

    final response = await http.get(
      url,
      headers: {
        // 'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      },
    );

    print('Response: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((item) => Location.fromJson(item)).toList();
      } else {
        print('Unexpected response format: $data');
        return [];
      }
    } else {
      print('Failed to load locations: ${response.statusCode} - ${response.body}');
      return [];
    }
  }


  // delete Location

  Future<bool> deleteLocation(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/locations/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Delete failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during delete: $e');
      return false;
    }
  }

  // edit location


  Future<bool> updateLocation(int id, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/locations/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Update failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during update: $e');
      return false;
    }
  }
}