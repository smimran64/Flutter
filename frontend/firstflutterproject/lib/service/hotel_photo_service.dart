

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firstflutterproject/entity/hotel_photo_model.dart';
import 'package:firstflutterproject/service/authservice.dart';

class HotelPhotoService {
  final String baseUrl = 'http://localhost:8082';

  Future<List<HotelPhoto>> getPhotosByHotelId(int hotelId) async {
    // String? token = await AuthService().getToken();
    //
    // if (token == null) {
    //   print('No token found. Please login first.');
    //   return [];
    // }

    final url = Uri.parse('$baseUrl/api/hotelPhoto/hotel/$hotelId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => HotelPhoto.fromJson(e)).toList();
    } else {
      print("Failed to load photos: ${response.statusCode}");
      return [];
    }
  }
}
