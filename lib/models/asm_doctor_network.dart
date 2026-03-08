class Chamber {
  const Chamber({
    required this.name,
    required this.address,
    required this.phone,
  });

  final String name;
  final String address;
  final String phone;

  Chamber copyWith({String? name, String? address, String? phone}) {
    return Chamber(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }
}

class ASMDoctorNetwork {
  const ASMDoctorNetwork({
    required this.id,
    required this.doctorName,
    required this.phone,
    required this.email,
    required this.address,
    required this.specialization,
    required this.experience,
    required this.qualification,
    required this.description,
    required this.chambers,
    required this.asmAddedBy,
    required this.asmAddedById,
    required this.createdAt,
  });

  final String id;
  final String doctorName;
  final String phone;
  final String email;
  final String address;
  final String specialization;
  final double experience;
  final String qualification;
  final String description;
  final List<Chamber> chambers;
  final String asmAddedBy;
  final String asmAddedById;
  final DateTime createdAt;

  ASMDoctorNetwork copyWith({
    String? id,
    String? doctorName,
    String? phone,
    String? email,
    String? address,
    String? specialization,
    double? experience,
    String? qualification,
    String? description,
    List<Chamber>? chambers,
    String? asmAddedBy,
    String? asmAddedById,
    DateTime? createdAt,
  }) {
    return ASMDoctorNetwork(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      description: description ?? this.description,
      chambers: chambers ?? this.chambers,
      asmAddedBy: asmAddedBy ?? this.asmAddedBy,
      asmAddedById: asmAddedById ?? this.asmAddedById,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
