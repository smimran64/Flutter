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
      image: json['image'] ?? '',
    );
  }
}
