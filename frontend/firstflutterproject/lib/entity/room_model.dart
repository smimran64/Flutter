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
      roomType: json['roomType'] ?? '',
      image: json['image'] ?? '',
      totalRooms: json['totalRooms'] ?? 0,
      adults: json['adults'] ?? 0,
      children: json['children'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      availableRooms: json['availableRooms'] ?? 0,
      bookedRooms: json['bookedRooms'] ?? 0,
      hotel: json['hotelDTO'] != null
          ? Hotel.fromJson(json['hotelDTO'])
          : Hotel(
        id: 0,
        name: 'Unknown',
        address: 'Unknown',
        rating: '0',
        image: 'no_image.png',
        location: Location(id: 0, name: 'Unknown', image: 'no_image.png'),
      ),
    );
  }

}
