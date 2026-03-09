import 'dart:convert';

class Chamber {
  const Chamber({
    required this.name,
    required this.address,
    required this.phone,
  });

  final String name;
  final String address;
  final String phone;

  factory Chamber.fromJson(Map<String, dynamic> json) {
    return Chamber(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'address': address, 'phone': phone};
  }

  Chamber copyWith({String? name, String? address, String? phone}) {
    return Chamber(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}

class MRDoctorNetwork {
  const MRDoctorNetwork({
    required this.id,
    required this.mrId,
    required this.doctorId,
    required this.doctorName,
    required this.phoneNo,
    this.email,
    this.description,
    this.address,
    this.qualification,
    required this.specialization,
    this.experience,
    this.chambers,
    this.profilePhoto,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String mrId;
  final String doctorId;
  final String doctorName;
  final String phoneNo;
  final String? email;
  final String? description;
  final String? address;
  final String? qualification;
  final String specialization;
  final String? experience;
  final List<Chamber>? chambers;
  final String? profilePhoto;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MRDoctorNetwork copyWith({
    int? id,
    String? mrId,
    String? doctorId,
    String? doctorName,
    String? phoneNo,
    String? email,
    String? description,
    String? address,
    String? qualification,
    String? specialization,
    String? experience,
    List<Chamber>? chambers,
    String? profilePhoto,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MRDoctorNetwork(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      description: description ?? this.description,
      address: address ?? this.address,
      qualification: qualification ?? this.qualification,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      chambers: chambers ?? this.chambers,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MRDoctorNetwork.fromJson(Map<String, dynamic> json) {
    var chambersJson = json['chambers'];
    List<Chamber> chambers = [];
    if (chambersJson != null) {
      if (chambersJson is List) {
        chambers = chambersJson
            .whereType<Map<String, dynamic>>()
            .map(Chamber.fromJson)
            .toList();
      } else if (chambersJson is String && chambersJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(chambersJson);
          if (decoded is List) {
            chambers = decoded
                .whereType<Map<String, dynamic>>()
                .map(Chamber.fromJson)
                .toList();
          }
        } catch (_) {
          chambers = [];
        }
      }
    }

    return MRDoctorNetwork(
      id: json['id'] as int,
      mrId: json['mr_id'] as String? ?? '',
      doctorId: json['doctor_id'] as String? ?? '',
      doctorName: json['doctor_name'] as String? ?? '',
      phoneNo: json['phone_no'] as String? ?? '',
      email: json['email'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      qualification: json['qualification'] as String?,
      specialization: json['specialization'] as String? ?? '',
      experience: json['experience'] as String?,
      chambers: chambers,
      profilePhoto: json['profile_photo'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
