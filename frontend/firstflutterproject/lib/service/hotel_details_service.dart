



import 'dart:convert';
import 'package:firstflutterproject/entity/hotel_Aminities_model.dart';
import 'package:firstflutterproject/entity/hotel_information_model.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/hotel_photo_model.dart';
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


  // for hotel information section

Future<HotelInformation>fetchHotelInfo(int hotelId) async{

  final url = Uri.parse("$baseUrl/api/hotel/information/hotel/$hotelId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return HotelInformation.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load hotel information');
  }
}


// hotel Amenities for home page

Future<Amenities?> getAmenitiesByHotelId(int hotelId)async{
    
    final url = Uri.parse("$baseUrl/api/amenities/hotel/$hotelId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Amenities.fromJson(jsonData);
    } else if (response.statusCode == 404) {

      return null;

    } else {

      throw Exception("Failed to load amenities: ${response.statusCode}");

    }
    
}

// 🆕 New method for fetching hotel photos

  Future<List<HotelPhoto>> fetchHotelPhotos(int hotelId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/hotelPhoto/hotel/$hotelId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => HotelPhoto.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load hotel photos");
    }
  }


}


