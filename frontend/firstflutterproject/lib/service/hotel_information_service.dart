

import 'dart:convert';

import 'package:firstflutterproject/entity/hotel_information_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;

class HotelInformationService{

  final String baseUrl = 'http://localhost:8082';

  Future<List<HotelInformation>> getAllHotelInformation() async {
    String? token = await AuthService().getToken();

    if (token == null) {
      print('No token found. Please login first.');
      return [];
    }

    final url = Uri.parse('$baseUrl/api/hotel/information/all');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => HotelInformation.fromJson(e)).toList();
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  }


  // save hotel informaton


  Future<HotelInformation> saveHotelInformation(HotelInformation info) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/hotel/information/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': info.id,
        'ownerSpeach': info.ownerSpeach,
        'description': info.description,
        'hotelPolicy': info.hotelPolicy,
        'hotelId': info.hotelId,
        'hotelName': info.hotelName,
      }),
    );

    if (response.statusCode == 200) {
      return HotelInformation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save hotel information');
    }
  }


  Future<HotelInformation?> getHotelInformationByHotelId(int hotelId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/hotel/information/hotel/$hotelId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return HotelInformation.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load hotel information');
    }
  }

}