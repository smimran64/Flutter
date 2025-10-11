



import 'dart:convert';

import 'package:firstflutterproject/entity/hotel_model.dart';
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

}