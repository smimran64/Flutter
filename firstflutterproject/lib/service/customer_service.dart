

import 'dart:convert';

import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;

class CustomerService{

  final String baseUrl = 'http://localhost:8082';

  Future<Map<String, dynamic>?> getCustomerProfile() async {
    
    String? token = await AuthService().getToken();
    
    if(token == null){
      print('No token found , please login first');
      return null;
    }
    
    final url = Uri.parse('$baseUrl/api/customer/profile');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json',
      }
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      print('Failed to load profile: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
 
}