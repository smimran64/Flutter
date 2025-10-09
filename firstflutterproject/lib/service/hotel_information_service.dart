

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

}