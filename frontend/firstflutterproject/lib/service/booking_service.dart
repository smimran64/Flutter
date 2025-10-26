import 'dart:convert';
import 'package:firstflutterproject/entity/booking_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingService {
  final String baseUrl = "http://localhost:8082/api/booking";



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


  Future<List<Booking>> getBookingByCustomerId(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    print("🪪 Token from SharedPreferences: $token");

    final url = Uri.parse("$baseUrl/customer/$customerId");
    print("🔗 Fetching: $url");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token', // 🔥 critical line
      },
    );

    print("📦 Status: ${response.statusCode}");
    print("📄 Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
  }


  Future<List<Booking>> getBookingsByHotelId(int hotelId) async {
    String? token = await AuthService().getToken(); // যদি JWT token লাগে
    final response = await http.get(
      Uri.parse("$baseUrl/hotel/$hotelId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // get all bookings

  Future<List<Booking>> getAllBookings() async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load all bookings: ${response.body}');
    }
  }


}







