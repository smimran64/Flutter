



import 'dart:convert';

import 'package:firstflutterproject/entity/hotel_Aminities_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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

}