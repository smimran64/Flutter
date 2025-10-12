import 'dart:convert';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;

class BookingService {
  final String baseUrl = "http://localhost:8082/api/booking";

  // Future createBooking(Map<String, dynamic> bookingData) async {
  //   String? token = await AuthService().getToken();
  //
  //   if (token == null) {
  //     print('No token found. Please login first.');
  //     return [];
  //   }
  //
  //   final uri = Uri.parse('$baseUrl/save');
  //
  //   final response = await http.post(
  //     uri,
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-type': 'application/json',
  //     },
  //   );
  //
  //   print('Response: ${response.statusCode}');
  //   print('Body: ${response.body}');
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to create booking : ${response.body}');
  //   }
  // }



  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    String? token = await AuthService().getToken();

    if (token == null) {
      print('No token found. Please login first.');
      throw Exception('No token found');
    }

    final uri = Uri.parse('$baseUrl/save');


    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookingData),
    );

    print('Response: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }




}
