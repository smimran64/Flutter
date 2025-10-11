import 'package:firstflutterproject/entity/hotel_model.dart';



class Room {
  final int id;
  final String roomType;
  final String image;
  final int totalRooms;
  final int adults;
  final int children;
  final double price;
  final int availableRooms;
  final int bookedRooms;
  final Hotel hotel;

  Room({
    required this.id,
    required this.roomType,
    required this.image,
    required this.totalRooms,
    required this.adults,
    required this.children,
    required this.price,
    required this.availableRooms,
    required this.bookedRooms,
    required this.hotel,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      roomType: json['roomType'],
      image: json['image'],
      totalRooms: json['totalRooms'],
      adults: json['adults'],
      children: json['children'],
      price: json['price'].toDouble(),
      availableRooms: json['availableRooms'],
      bookedRooms: json['bookedRooms'],
      hotel: Hotel.fromJson(json['hotelDTO']),
    );
  }
}
