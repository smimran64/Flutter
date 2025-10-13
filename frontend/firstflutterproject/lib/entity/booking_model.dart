




// models/booking.dart
import 'dart:convert';


class Booking {
  int id;
  String contractPersonName;
  String phone;
  DateTime checkIn;
  DateTime checkOut;
  int numberOfRooms;
  double discountRate;
  double totalAmount;
  double advanceAmount;
  double dueAmount;
  CustomerDto? customerdto;
  HotelDto? hoteldto;
  RoomDto? roomdto;

  Booking({
    required this.id,
    required this.contractPersonName,
    required this.phone,
    required this.checkIn,
    required this.checkOut,
    required this.numberOfRooms,
    required this.discountRate,
    required this.totalAmount,
    required this.advanceAmount,
    required this.dueAmount,
    this.customerdto,
    this.hoteldto,
    this.roomdto,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    contractPersonName: json['contractPersonName'] ?? '',
    phone: json['phone'] ?? '',
    checkIn: DateTime.parse(json['checkIn']),
    checkOut: DateTime.parse(json['checkOut']),
    numberOfRooms: json['numberOfRooms'] ?? 0,
    discountRate: (json['discountRate'] ?? 0).toDouble(),
    totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    advanceAmount: (json['advanceAmount'] ?? 0).toDouble(),
    dueAmount: (json['dueAmount'] ?? 0).toDouble(),
    customerdto: json['customerdto'] != null ? CustomerDto.fromJson(json['customerdto']) : null,
    hoteldto: json['hoteldto'] != null ? HotelDto.fromJson(json['hoteldto']) : null,
    roomdto: json['roomdto'] != null ? RoomDto.fromJson(json['roomdto']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'contractPersonName': contractPersonName,
    'phone': phone,
    'checkIn': checkIn.toUtc().toIso8601String(),
    'checkOut': checkOut.toUtc().toIso8601String(),
    'numberOfRooms': numberOfRooms,
    'discountRate': discountRate,
    'totalAmount': totalAmount,
    'advanceAmount': advanceAmount,
    'dueAmount': dueAmount,
    'customerdto': customerdto?.toJson(),
    'hoteldto': hoteldto?.toJson(),
    'roomdto': roomdto?.toJson(),
  };
}

class CustomerDto {
  int id;
  String name;
  String email;
  String phone;
  String address;
  String gender;
  String dateOfBirth;
  String image;

  CustomerDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.image,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) => CustomerDto(
    id: json['id'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
    gender: json['gender'] ?? '',
    dateOfBirth: json['dateOfBirth'] ?? '',
    image: json['image'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'gender': gender,
    'dateOfBirth': dateOfBirth,
    'image': image,
  };
}

class HotelDto {
  int id;
  String name;
  String address;
  String rating;
  String image;

  HotelDto({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.image,
  });

  factory HotelDto.fromJson(Map<String, dynamic> json) => HotelDto(
    id: json['id'],
    name: json['name'] ?? '',
    address: json['address'] ?? '',
    rating: json['rating'] ?? '',
    image: json['image'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'rating': rating,
    'image': image,
  };
}

class RoomDto {
  int id;
  String roomType;
  String image;
  int totalRooms;
  int adults;
  int children;
  double price;
  int availableRooms;
  int bookedRooms;
  HotelDto? hotelDto; // ✅ add this

  RoomDto({
    required this.id,
    required this.roomType,
    required this.image,
    required this.totalRooms,
    required this.adults,
    required this.children,
    required this.price,
    required this.availableRooms,
    required this.bookedRooms,
    this.hotelDto,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) => RoomDto(
    id: json['id'],
    roomType: json['roomType'] ?? '',
    image: json['image'] ?? '',
    totalRooms: json['totalRooms'] ?? 0,
    adults: json['adults'] ?? 0,
    children: json['children'] ?? 0,
    price: (json['price'] ?? 0).toDouble(),
    availableRooms: json['availableRooms'] ?? 0,
    bookedRooms: json['bookedRooms'] ?? 0,
    // hotelDto: json['hotelDTO'] != null
    //     ? HotelDto.fromJson(json['hotelDTO'])
    //     : null, // ✅ handle null
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomType': roomType,
    'image': image,
    'totalRooms': totalRooms,
    'adults': adults,
    'children': children,
    'price': price,
    'availableRooms': availableRooms,
    'bookedRooms': bookedRooms,
    'hotelDTO': hotelDto?.toJson(),
  };
}


