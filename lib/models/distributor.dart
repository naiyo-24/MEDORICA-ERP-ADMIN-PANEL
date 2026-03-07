import 'dart:typed_data';

class Distributor {
  const Distributor({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.address,
    required this.email,
    required this.phone,
    this.imageBytes,
    this.imageFileName,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String city;
  final String state;
  final String address;
  final String email;
  final String phone;
  final Uint8List? imageBytes;
  final String? imageFileName;
  final DateTime createdAt;

  String get locationLabel => '$city, $state';

  String get mapsQuery => '$name, $address, $city, $state';

  Distributor copyWith({
    String? id,
    String? name,
    String? city,
    String? state,
    String? address,
    String? email,
    String? phone,
    Uint8List? imageBytes,
    String? imageFileName,
    DateTime? createdAt,
    bool clearImage = false,
  }) {
    return Distributor(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      state: state ?? this.state,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageBytes: clearImage ? null : imageBytes ?? this.imageBytes,
      imageFileName: clearImage ? null : imageFileName ?? this.imageFileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
