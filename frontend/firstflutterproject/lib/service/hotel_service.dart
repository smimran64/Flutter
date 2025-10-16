

import 'dart:convert';
import 'dart:io';

import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HotelService {

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
      print(
          'Failed to search hotels: ${response.statusCode} - ${response.body}');
      return [];
    }
  }

  // GEt hotel by Hotel admin id

  Future<List<Hotel>> getMyHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await http.get(
      Uri.parse('$baseUrl/api/hotel/myHotels'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((hotel) => Hotel.fromJson(hotel)).toList();
    } else {
      throw Exception('Failed to load hotels. Status: ${response.statusCode}');
    }
  }


  // save hotel


  Future<Map<String, dynamic>> addHotel({
    required Map<String, dynamic> hotelData,
    File? imageFile,
    required String token,
  }) async {
    var uri = Uri.parse('$baseUrl/api/hotel/save');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['hotel'] = jsonEncode(hotelData);

    if (imageFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add hotel: ${response.body}');
    }
  }
}