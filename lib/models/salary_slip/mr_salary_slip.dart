import '../onboarding/mr.dart';

class MRSalarySlip {
  const MRSalarySlip({
    this.id,
    required this.mrId,
    required this.mrName,
    required this.mrPhone,
    this.mrProfilePhoto,
    this.salarySlipUrl,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String mrId;
  final String mrName;
  final String mrPhone;
  final String? mrProfilePhoto;
  final String? salarySlipUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasFile => (salarySlipUrl ?? '').trim().isNotEmpty;

  String? get fileName {
    final value = salarySlipUrl;
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value.split('/').last;
  }

  factory MRSalarySlip.fromMr(MR mr) {
    return MRSalarySlip(
      mrId: mr.mrId,
      mrName: mr.name,
      mrPhone: mr.phone,
      mrProfilePhoto: mr.profilePhoto,
    );
  }

  factory MRSalarySlip.fromJson(Map<String, dynamic> json) {
    return MRSalarySlip(
      id: _asInt(json['id']),
      mrId: (json['mr_id'] ?? '').toString(),
      mrName: (json['mr_name'] ?? '').toString(),
      mrPhone: (json['mr_phone'] ?? '').toString(),
      mrProfilePhoto: (json['mr_profile_photo'] ?? '').toString(),
      salarySlipUrl: (json['salary_slip_url'] ?? '').toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  MRSalarySlip copyWith({
    int? id,
    String? mrId,
    String? mrName,
    String? mrPhone,
    String? mrProfilePhoto,
    String? salarySlipUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearSlip = false,
  }) {
    return MRSalarySlip(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
      mrPhone: mrPhone ?? this.mrPhone,
      mrProfilePhoto: mrProfilePhoto ?? this.mrProfilePhoto,
      salarySlipUrl: clearSlip ? null : salarySlipUrl ?? this.salarySlipUrl,
      createdAt: clearSlip ? null : createdAt ?? this.createdAt,
      updatedAt: clearSlip ? null : updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value);
    }
    return null;
  }
}
  
