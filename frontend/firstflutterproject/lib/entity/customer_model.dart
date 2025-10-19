class CustomerModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? gender;
  DateTime? dateOfBirth;
  String? image;

  CustomerModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.gender,
    this.dateOfBirth,
    this.image,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'image': image,
    };
  }
}
