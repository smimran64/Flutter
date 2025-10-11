

class Amenities {
  final int id;
  final bool freeWifi;
  final bool freeParking;
  final bool swimmingPool;
  final bool gym;
  final bool restaurant;
  final bool roomService;
  final bool airConditioning;
  final bool laundryService;
  final bool wheelchairAccessible;
  final bool healthServices;
  final bool playGround;
  final bool airportSuttle;
  final bool breakFast;
  final int hotelId;
  final String hotelName;

  Amenities({
    required this.id,
    required this.freeWifi,
    required this.freeParking,
    required this.swimmingPool,
    required this.gym,
    required this.restaurant,
    required this.roomService,
    required this.airConditioning,
    required this.laundryService,
    required this.wheelchairAccessible,
    required this.healthServices,
    required this.playGround,
    required this.airportSuttle,
    required this.breakFast,
    required this.hotelId,
    required this.hotelName,
  });

  factory Amenities.fromJson(Map<String, dynamic> json) {
    return Amenities(
      id: json['id'],
      freeWifi: json['freeWifi'],
      freeParking: json['freeParking'],
      swimmingPool: json['swimmingPool'],
      gym: json['gym'],
      restaurant: json['restaurant'],
      roomService: json['roomService'],
      airConditioning: json['airConditioning'],
      laundryService: json['laundryService'],
      wheelchairAccessible: json['wheelchairAccessible'],
      healthServices: json['healthServices'],
      playGround: json['playGround'],
      airportSuttle: json['airportSuttle'],
      breakFast: json['breakFast'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
    );
  }
}
