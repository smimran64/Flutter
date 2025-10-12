

class HotelInformation {
  final int id;
  final String ownerSpeach;
  final String description;
  final String hotelPolicy;
  final int hotelId;
  final String hotelName;

  HotelInformation({
    required this.id,
    required this.ownerSpeach,
    required this.description,
    required this.hotelPolicy,
    required this.hotelId,
    required this.hotelName,
  });

  factory HotelInformation.fromJson(Map<String, dynamic> json) {

    return HotelInformation(
      id: json['id'],
      ownerSpeach: json['ownerSpeach'],
      description: json['description'],
      hotelPolicy: json['hotelPolicy'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
    );
  }
}
