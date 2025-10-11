

class Hotel {
  final int id;
  final String name;
  final String address;
  final String rating;
  final String image;
  final Location location;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.image,
    required this.location,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      rating: json['rating'],
      image: json['image'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : Location(id: 0, name: 'Unknown', image: 'no_image.png'),
    );
  }

}

class Location {
  final int id;
  final String name;
  final String image;

  Location({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Hotel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;


}
