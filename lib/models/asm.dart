import 'dart:typed_data';

class ASM {
  const ASM({
    required this.id,
    required this.name,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.address,
    required this.headquarterAssigned,
    required this.territoriesOfWork,
    required this.bankName,
    required this.bankBranchName,
    required this.bankAccountNumber,
    required this.ifscCode,
    required this.monthlyTarget,
    required this.password,
    this.photoBytes,
    this.photoFileName,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String altPhone;
  final String email;
  final String address;
  final String headquarterAssigned;
  final String territoriesOfWork;
  final String bankName;
  final String bankBranchName;
  final String bankAccountNumber;
  final String ifscCode;
  final double monthlyTarget;
  final String password;
  final Uint8List? photoBytes;
  final String? photoFileName;
  final DateTime createdAt;

  ASM copyWith({
    String? id,
    String? name,
    String? phone,
    String? altPhone,
    String? email,
    String? address,
    String? headquarterAssigned,
    String? territoriesOfWork,
    String? bankName,
    String? bankBranchName,
    String? bankAccountNumber,
    String? ifscCode,
    double? monthlyTarget,
    String? password,
    Uint8List? photoBytes,
    String? photoFileName,
    DateTime? createdAt,
    bool clearPhoto = false,
  }) {
    return ASM(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      address: address ?? this.address,
      headquarterAssigned: headquarterAssigned ?? this.headquarterAssigned,
      territoriesOfWork: territoriesOfWork ?? this.territoriesOfWork,
      bankName: bankName ?? this.bankName,
      bankBranchName: bankBranchName ?? this.bankBranchName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      password: password ?? this.password,
      photoBytes: clearPhoto ? null : photoBytes ?? this.photoBytes,
      photoFileName: clearPhoto ? null : photoFileName ?? this.photoFileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
