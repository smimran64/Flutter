

import 'dart:convert';
import 'package:firstflutterproject/entity/room_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RoomService{

  final String baseUrl = "http://localhost:8082";


  Future<List<Room>> getRoomsByHotelId(int hotelId)async{

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    print("🔹 Fetching rooms for hotelId: $hotelId");

    final response = await http.get(
      Uri.parse('$baseUrl/api/room/hotell/$hotelId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("🔹 Response status: ${response.statusCode}");
    print("🔹 Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((room) => Room.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms. Status: ${response.statusCode}');
    }

  }

  // update room




}