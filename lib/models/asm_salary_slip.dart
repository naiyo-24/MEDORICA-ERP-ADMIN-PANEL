import 'onboarding/asm.dart';

class ASMSalarySlip {
  const ASMSalarySlip({
    this.id,
    required this.asmId,
    required this.asmName,
    required this.asmPhone,
    this.asmProfilePhoto,
    this.salarySlipUrl,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String asmId;
  final String asmName;
  final String asmPhone;
  final String? asmProfilePhoto;
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

  factory ASMSalarySlip.fromAsm(ASM asm) {
    return ASMSalarySlip(
      asmId: asm.asmId,
      asmName: asm.name,
      asmPhone: asm.phone,
      asmProfilePhoto: asm.profilePhoto,
    );
  }

  factory ASMSalarySlip.fromJson(Map<String, dynamic> json) {
    return ASMSalarySlip(
      id: _asInt(json['id']),
      asmId: (json['asm_id'] ?? '').toString(),
      asmName: '',
      asmPhone: '',
      salarySlipUrl: (json['salary_slip_url'] ?? '').toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  ASMSalarySlip copyWith({
    int? id,
    String? asmId,
    String? asmName,
    String? asmPhone,
    String? asmProfilePhoto,
    String? salarySlipUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearSlip = false,
  }) {
    return ASMSalarySlip(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      asmPhone: asmPhone ?? this.asmPhone,
      asmProfilePhoto: asmProfilePhoto ?? this.asmProfilePhoto,
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
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
