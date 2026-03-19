class Chamber {
  const Chamber({
    required this.chamberId,
    required this.chamberName,
    required this.chamberAddress,
    required this.chamberPhoneNo,
  });

  final String chamberId;
  final String chamberName;
  final String chamberAddress;
  final String chamberPhoneNo;

  factory Chamber.fromJson(Map<String, dynamic> json) {
    return Chamber(
      chamberId: json['chamber_id']?.toString() ?? '',
      chamberName: json['chamber_name'] as String? ?? '',
      chamberAddress: json['chamber_address'] as String? ?? '',
      chamberPhoneNo: json['chamber_phone_no'] as String? ?? '',
    );
  }

  Chamber copyWith({String? chamberId, String? chamberName, String? chamberAddress, String? chamberPhoneNo}) {
    return Chamber(
      chamberId: chamberId ?? this.chamberId,
      chamberName: chamberName ?? this.chamberName,
      chamberAddress: chamberAddress ?? this.chamberAddress,
      chamberPhoneNo: chamberPhoneNo ?? this.chamberPhoneNo,
    );
  }
}

class ASMDoctorNetwork {
  const ASMDoctorNetwork({
    required this.id,
    required this.asmId,
    required this.doctorId,
    required this.doctorName,
    this.doctorBirthday,
    required this.specialization,
    this.qualification,
    this.experience,
    this.description,
    this.photo,
    this.chambers,
    required this.phoneNo,
    this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String asmId;
  final String doctorId;
  final String doctorName;
  final String? doctorBirthday;
  final String specialization;
  final String? qualification;
  final String? experience;
  final String? description;
  final String? photo;
  final List<Chamber>? chambers;
  final String phoneNo;
  final String? email;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ASMDoctorNetwork.fromJson(Map<String, dynamic> json) {
    var chambersJson = json['doctor_chambers'];
    List<Chamber> chambers = [];
    if (chambersJson != null) {
      if (chambersJson is List) {
        chambers = chambersJson
            .whereType<Map<String, dynamic>>()
            .map(Chamber.fromJson)
            .toList();
      }
    }
    return ASMDoctorNetwork(
      id: json['id'] as int,
      asmId: json['asm_id'] as String? ?? '',
      doctorId: json['doctor_id'] as String? ?? '',
      doctorName: json['doctor_name'] as String? ?? '',
      doctorBirthday: json['doctor_birthday'] as String?,
      specialization: json['doctor_specialization'] as String? ?? '',
      qualification: json['doctor_qualification'] as String?,
      experience: json['doctor_experience']?.toString(),
      description: json['doctor_description'] as String?,
      photo: json['doctor_photo'] as String?,
      chambers: chambers,
      phoneNo: json['doctor_phone_no'] as String? ?? '',
      email: json['doctor_email'] as String?,
      address: json['doctor_address'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  ASMDoctorNetwork copyWith({
    int? id,
    String? asmId,
    String? doctorId,
    String? doctorName,
    String? doctorBirthday,
    String? specialization,
    String? qualification,
    String? experience,
    String? description,
    String? photo,
    List<Chamber>? chambers,
    String? phoneNo,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ASMDoctorNetwork(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorBirthday: doctorBirthday ?? this.doctorBirthday,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      chambers: chambers ?? this.chambers,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
