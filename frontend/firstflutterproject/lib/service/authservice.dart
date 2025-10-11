


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
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







  Future<bool> customerRegistration({
    required Map<String, dynamic> user,
    required Map<String, dynamic> customer,

    File? photoFile,
    Uint8List? photoBytes,
})async{

    // create multipart http request

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/customer/reg'),
    );

    // convert User map into JSon string and add to request fields

    request.fields['user'] = jsonEncode(user);

    // convert Customer into JSON string and add to request fields

    request.fields['customer'] = jsonEncode(customer);


    // -++++++++++++++++ Image Handling-++++++++++++++++++

    if(photoBytes != null){
      request.files.add(await http.MultipartFile.fromBytes(
          'image',
          photoBytes,
          filename: 'profile.png'));
    }

    // If photoFile is provided (mobile/ desktop), attach it

    else if(photoFile !=null){

      request.files.add(await http.MultipartFile.fromPath(
          'image',
          photoFile.path,
      ));
    }


    // send request


    var response = await request.send();

    // Return True if response code is 200(Success)

    return response.statusCode == 200;

  }


  Future<String?> getUserRole()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userRole'));

    return prefs.getString('userRole');

  }


  Future<String?> getToken() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('authToken');

  }


  Future<bool>isTokenExpired() async{

    String? token = await getToken();

    if(token != null){
      DateTime expiryDate = Jwt.getExpiryDate(token)!;

      return DateTime.now().isAfter(expiryDate);
    }
    return true;
  }

  Future<bool> isLoggedIn() async{

    String? token = await getToken();
    if(token != null && !(await isTokenExpired())){
      return true;
    }
    else {
      await logout();

      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userRole');
  }

  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role != null && roles.contains(role);
  }


  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  Future<bool> isHotelAdmin() async {
    return await hasRole(['HOTEL_ADMIN']);
  }


  Future<bool> isCustomer() async {
    return await hasRole(['CUSTOMER']);
  }

}