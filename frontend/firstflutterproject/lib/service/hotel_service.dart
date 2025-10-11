

import 'dart:convert';

import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;

class HotelService{

  final String baseUrl = 'http://localhost:8082';

  Future<List<Hotel>> getAllHotels() async {
    // String? token = await AuthService().getToken();
    //
    // if (token == null) {
    //   print('No token found, please login first');
    //   return [];
    // }

    final url = Uri.parse('$baseUrl/api/hotel/all');

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
        return data.map((item) => Hotel.fromJson(item)).toList();
      } else {
        print('Unexpected response format: $data');
        return [];
      }
    } else {
      print('Failed to load Hotels: ${response.statusCode} - ${response.body}');
      return [];
    }
  }

  // Search hotels by location & date

  Future<List<Hotel>> searchHotels({
    required int locationId,
    required String checkIn,
    required String checkOut,
  }) async {
    // String? token = await AuthService().getToken();
    //
    // if (token == null) {
    //   print('No token found, please login first');
    //   return [];
    // }

    final url = Uri.parse(
        '$baseUrl/api/hotel/search?locationId=$locationId&checkIn=$checkIn&checkOut=$checkOut');

    final response = await http.get(
      url,
      headers: {
        // 'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      },
    );

    print('🔎 Search API Response: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((item) => Hotel.fromJson(item)).toList();
      } else {
        print('Unexpected response format: $data');
        return [];
      }
    } else {
      print('Failed to search hotels: ${response.statusCode} - ${response.body}');
      return [];
    }
  }


}