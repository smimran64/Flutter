



import 'dart:convert';

import 'package:firstflutterproject/entity/hotel_Aminities_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelAminitiesService{

  final String baseUrl = "http://localhost:8082";

  Future<List<Amenities>> getAllAmenities() async {
    try {
      String? token = await AuthService().getToken();

      if (token == null) {
        if (kDebugMode) print("No token found");
        return [];
      }

      final url = Uri.parse('$baseUrl/api/amenities/all');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data.map((item) => Amenities.fromJson(item)).toList();
        } else {
          if (kDebugMode) print('Unexpected response format');
          return [];
        }
      } else {
        if (kDebugMode) print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      if (kDebugMode) print('Exception: $e');
      return [];
    }
  }


  Future<Amenities?> saveAmenities(Amenities amenities) async {
    final url = Uri.parse("$baseUrl/api/amenities/save");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': amenities.id,
        'freeWifi': amenities.freeWifi,
        'freeParking': amenities.freeParking,
        'swimmingPool': amenities.swimmingPool,
        'gym': amenities.gym,
        'restaurant': amenities.restaurant,
        'roomService': amenities.roomService,
        'airConditioning': amenities.airConditioning,
        'laundryService': amenities.laundryService,
        'wheelchairAccessible': amenities.wheelchairAccessible,
        'healthServices': amenities.healthServices,
        'playGround': amenities.playGround,
        'airportSuttle': amenities.airportSuttle,
        'breakFast': amenities.breakFast,
        'hotelId': amenities.hotelId,
        'hotelName': amenities.hotelName,
      }),
    );

    if (response.statusCode == 200) {
      return Amenities.fromJson(jsonDecode(response.body));
    } else {
      print("Failed to save amenities: ${response.statusCode}");
      return null;
    }
  }


  Future<Amenities?> getAmenitiesByHotelId(int hotelId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final url = Uri.parse('$baseUrl/api/amenities/hotel/$hotelId'); // Matches your Spring Boot endpoint

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Amenities.fromJson(jsonData);
    } else {
      print('Failed to load amenities (Status: ${response.statusCode})');
      return null;
    }
  }

}