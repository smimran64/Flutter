


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final String baseUrl = 'http://localhost:8082';


  Future<bool>login(String email, String password) async{

    final url = Uri.parse('$baseUrl/api/login');
    final headers = {'Content-Type': 'application/json'};


    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if(response.statusCode ==200 || response.statusCode == 201){

      final data = jsonDecode(response.body);

      String token = data['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);

      String role = payload ['role'];


      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('authToken', token);
      await prefs.setString('userRole', role);

      return true;
    }

    else{

      print('User login Failed:${response.body}');

      return false;

    }



  }

  Future<String?> getUserRole()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userRole'));

    return prefs.getString('userRole');


  }
}