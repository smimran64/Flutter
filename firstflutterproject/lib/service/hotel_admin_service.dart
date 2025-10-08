

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:http/http.dart' as http;

class HotelAdminService{

  final String baseUrl = 'http://localhost:8082';

  Future<bool>hotelAdminRegistration({

    required Map<String, dynamic> user,
    required Map<String, dynamic> hotelAdmin,

    File? photoFile,
    Uint8List? photoBytes,

}) async{

    // create multipart http request

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/hoteladmin/reg'),

    );

    // convert User map into JSon string and add to request fields
    request.fields['user'] = jsonEncode(user);

    // convert Customer into JSON string and add to request fields

    request.fields['customer'] = jsonEncode(hotelAdmin);

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


  Future<Map<String, dynamic>?> getHotelAdminProfile() async{

    String? token = await AuthService().getToken();


    if(token == null){
      print('No token found , please login first');
      return null;
    }

    final url = Uri.parse('$baseUrl/api/hoteladmin/profile');

    final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        }
    );

    print('Response: ${response.statusCode}');
    print('Body: ${response.body}');


    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }
    else{
      print('Failed to load profile: ${response.statusCode} - ${response.body}');
      return null;
    }

  }

}