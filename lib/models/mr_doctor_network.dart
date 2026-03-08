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

class MRDoctorNetwork {
  const MRDoctorNetwork({
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
    required this.mrAddedBy,
    required this.mrAddedById,
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
  final String mrAddedBy;
  final String mrAddedById;
  final DateTime createdAt;

  MRDoctorNetwork copyWith({
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
    String? mrAddedBy,
    String? mrAddedById,
    DateTime? createdAt,
  }) {
    return MRDoctorNetwork(
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
      mrAddedBy: mrAddedBy ?? this.mrAddedBy,
      mrAddedById: mrAddedById ?? this.mrAddedById,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
