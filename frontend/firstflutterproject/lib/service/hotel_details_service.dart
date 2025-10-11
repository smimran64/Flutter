



import 'dart:convert';

import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/room_model.dart';
import 'package:http/http.dart' as http;

class HotelDetailsService{

  final String baseUrl = 'http://localhost:8082';


  Future<Hotel> getHotelById(int id) async{



    final response = await http.get(Uri.parse('$baseUrl/api/hotel/$id'));

    if(response.statusCode == 200){
      final jsonData = jsonDecode(response.body);

      return Hotel.fromJson(jsonData);
    }
    else{

      throw Exception('Failed to load Hotel details');

    }
  }

  // Get Rooms By hotel Id For Public

  Future<List<Room>> fetchRoomByHotelId(int hotelId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/room/hotell/$hotelId'));

      print("Room API status: ${response.statusCode}");
      print("Room API response body: ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Room.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load rooms. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load rooms. Error: $e');
    }
  }


}


