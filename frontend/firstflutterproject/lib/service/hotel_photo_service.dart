

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firstflutterproject/entity/hotel_photo_model.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:image_picker/image_picker.dart';

class HotelPhotoService {
  final String baseUrl = 'http://localhost:8082';

  Future<List<HotelPhoto>> getPhotosByHotelId(int hotelId) async {

    final url = Uri.parse('$baseUrl/api/hotelPhoto/hotel/$hotelId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => HotelPhoto.fromJson(e)).toList();
    } else {
      print("Failed to load photos: ${response.statusCode}");
      return [];
    }
  }

  //hotel photo save

  Future<List<HotelPhoto>> uploadHotelPhotos(int hotelId, List<XFile> files) async {
    var uri = Uri.parse("$baseUrl/api/hotelPhoto/upload/$hotelId");
    var request = http.MultipartRequest('POST', uri);

    for (var file in files) {
      var bytes = await file.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          bytes,
          filename: file.name,
        ),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((e) => HotelPhoto.fromJson(e)).toList();
    } else {
      throw Exception("Upload failed with status ${response.statusCode}");
    }
  }

}
