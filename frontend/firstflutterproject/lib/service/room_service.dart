

import 'dart:convert';
import 'dart:io';
import 'package:firstflutterproject/entity/room_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

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

 // save room

  // ✅ Save room (works for both Mobile & Web)
  Future<void> saveRoom(Room room, {File? imageFile, Uint8List? imageBytes}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("authToken");

    var uri = Uri.parse('$baseUrl/save');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    var roomJson = {
      "roomType": room.roomType,
      "totalRooms": room.totalRooms,
      "adults": room.adults,
      "children": room.children,
      "price": room.price,
      "availableRooms": room.availableRooms,
      "bookedRooms": room.bookedRooms,
      "hotelId": room.hotel.id,
    };

    request.fields['room'] = jsonEncode(roomJson);

    // ✅ Add image file or bytes
    if (kIsWeb && imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'room_image.png',
      ));
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var response = await request.send();

    var responseBody = await response.stream.bytesToString();
    print("🔹 Server Response: $responseBody");

    if (response.statusCode == 200) {
      print("✅ Room saved successfully");
    } else {
      throw Exception("❌ Room save failed (${response.statusCode}): $responseBody");
    }
  }




}