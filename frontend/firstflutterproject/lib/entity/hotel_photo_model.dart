class HotelPhoto {
  final int? id;
  final String photoUrl;
  final int hotelId;
  final String? hotelName;

  HotelPhoto({
    this.id,
    required this.photoUrl,
    required this.hotelId,
    this.hotelName,
  });

  factory HotelPhoto.fromJson(Map<String, dynamic> json) {
    return HotelPhoto(
      id: json['id'],
      photoUrl: json['photoUrl'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photoUrl': photoUrl,
      'hotelId': hotelId,
    };
  }
}
