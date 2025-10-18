

import 'dart:convert';
import 'dart:io';

import 'package:firstflutterproject/entity/hotel_model.dart' hide Location;
import 'package:firstflutterproject/entity/location_model.dart';
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


  /// Fetch all locations for dropdown
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


  // save hotel


  Future<Map<String, dynamic>> saveHotel(Hotel hotel, File? imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final hotelJson = jsonEncode({
        "name": hotel.name,
        "address": hotel.address,
        "rating": hotel.rating,
        "locationId": hotel.location.id, // backend expects this
      });

      var uri = Uri.parse('$baseUrl/hotel/save');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['hotel'] = hotelJson;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        return jsonDecode(respStr);
      } else {
        throw Exception('Failed to save hotel. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving hotel: $e');
    }
  }
}