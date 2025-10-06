import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;


class AdminService{


  final String baseUrl = 'http://localhost:8082';



  Future<bool> adminRegistration({
    required Map<String, dynamic> user,
    required Map<String, dynamic> admin,

    File? photoFile,
    Uint8List? photoBytes,
  })async{

    // create multipart http request

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/admin/reg'),
    );

    // convert User map into JSon string and add to request fields

    request.fields['user'] = jsonEncode(user);

    // convert Customer into JSON string and add to request fields

    request.fields['admin'] = jsonEncode(admin);


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
}