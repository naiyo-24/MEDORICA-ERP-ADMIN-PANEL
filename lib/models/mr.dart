import 'dart:convert';
import 'dart:typed_data';

class MR {
  const MR({
    this.id,
    required this.mrId,
    required this.name,
    required this.phone,
    this.altPhone,
    this.email,
    this.address,
    this.joiningDate,
    required this.password,
    this.profilePhoto,
    this.bankName,
    this.bankAccountNumber,
    this.ifscCode,
    this.bankBranchName,
    this.headquarterAssigned,
    this.territoriesOfWork,
    this.monthlyTarget,
    this.basicSalary,
    this.dailyAllowances,
    this.hra,
    this.phoneAllowances,
    this.childrenAllowances,
    this.esic,
    this.totalMonthlyCompensation,
    this.active = true,
    this.photoBytes,
    this.photoFileName,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String mrId;
  final String name;
  final String phone;
  final String? altPhone;
  final String? email;
  final String? address;
  final DateTime? joiningDate;
  final String password;
  final String? profilePhoto;
  final String? bankName;
  final String? bankAccountNumber;
  final String? ifscCode;
  final String? bankBranchName;
  final String? headquarterAssigned;
  final dynamic territoriesOfWork;
  final double? monthlyTarget;
  final double? basicSalary;
  final double? dailyAllowances;
  final double? hra;
  final double? phoneAllowances;
  final double? childrenAllowances;
  final double? esic;
  final double? totalMonthlyCompensation;
  final bool active;
  final Uint8List? photoBytes;
  final String? photoFileName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MR.fromJson(Map<String, dynamic> json) {
    return MR(
      id: json['id'] as int?,
      mrId: json['mr_id'] as String? ?? '',
      name: json['full_name'] as String? ?? '',
      phone: json['phone_no'] as String? ?? '',
      altPhone: json['alt_phone_no'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      joiningDate: json['joining_date'] != null
          ? DateTime.parse(json['joining_date'] as String)
          : null,
      password: json['password'] as String? ?? '',
      profilePhoto: json['profile_photo'] as String?,
      bankName: json['bank_name'] as String?,
      bankAccountNumber: json['bank_account_no'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      bankBranchName: json['branch_name'] as String?,
      headquarterAssigned: json['headquarter_assigned'] as String?,
      territoriesOfWork: json['territories_of_work'],
      monthlyTarget: (json['monthly_target_rupees'] as num?)?.toDouble(),
      basicSalary: (json['basic_salary_rupees'] as num?)?.toDouble(),
      dailyAllowances: (json['daily_allowances_rupees'] as num?)?.toDouble(),
      hra: (json['hra_rupees'] as num?)?.toDouble(),
      phoneAllowances: (json['phone_allowances_rupees'] as num?)?.toDouble(),
      childrenAllowances: (json['children_allowances_rupees'] as num?)
          ?.toDouble(),
      esic: (json['esic_rupees'] as num?)?.toDouble(),
      totalMonthlyCompensation:
          (json['total_monthly_compensation_rupees'] as num?)?.toDouble(),
      active: json['active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{
      'full_name': name,
      'phone_no': phone,
      'password': password,
      'active': active,
    };

    if (altPhone != null) map['alt_phone_no'] = altPhone;
    if (email != null) map['email'] = email;
    if (address != null) map['address'] = address;
    if (joiningDate != null) {
      map['joining_date'] = joiningDate!.toIso8601String().split('T')[0];
    }
    if (bankName != null) map['bank_name'] = bankName;
    if (bankAccountNumber != null) map['bank_account_no'] = bankAccountNumber;
    if (ifscCode != null) map['ifsc_code'] = ifscCode;
    if (bankBranchName != null) map['branch_name'] = bankBranchName;
    if (headquarterAssigned != null) {
      map['headquarter_assigned'] = headquarterAssigned;
    }
    if (territoriesOfWork != null) {
      map['territories_of_work'] = territoriesOfWork is String
          ? territoriesOfWork
          : json.encode(territoriesOfWork);
    }
    if (monthlyTarget != null) map['monthly_target_rupees'] = monthlyTarget;
    if (basicSalary != null) map['basic_salary_rupees'] = basicSalary;
    if (dailyAllowances != null) {
      map['daily_allowances_rupees'] = dailyAllowances;
    }
    if (hra != null) map['hra_rupees'] = hra;
    if (phoneAllowances != null) {
      map['phone_allowances_rupees'] = phoneAllowances;
    }
    if (childrenAllowances != null) {
      map['children_allowances_rupees'] = childrenAllowances;
    }
    if (esic != null) map['esic_rupees'] = esic;
    if (totalMonthlyCompensation != null) {
      map['total_monthly_compensation_rupees'] = totalMonthlyCompensation;
    }

    return map;
  }

  MR copyWith({
    int? id,
    String? mrId,
    String? name,
    String? phone,
    String? altPhone,
    String? email,
    String? address,
    DateTime? joiningDate,
    String? password,
    String? profilePhoto,
    String? bankName,
    String? bankAccountNumber,
    String? ifscCode,
    String? bankBranchName,
    String? headquarterAssigned,
    dynamic territoriesOfWork,
    double? monthlyTarget,
    double? basicSalary,
    double? dailyAllowances,
    double? hra,
    double? phoneAllowances,
    double? childrenAllowances,
    double? esic,
    double? totalMonthlyCompensation,
    bool? active,
    Uint8List? photoBytes,
    String? photoFileName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearPhoto = false,
  }) {
    return MR(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      address: address ?? this.address,
      joiningDate: joiningDate ?? this.joiningDate,
      password: password ?? this.password,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      bankBranchName: bankBranchName ?? this.bankBranchName,
      headquarterAssigned: headquarterAssigned ?? this.headquarterAssigned,
      territoriesOfWork: territoriesOfWork ?? this.territoriesOfWork,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      basicSalary: basicSalary ?? this.basicSalary,
      dailyAllowances: dailyAllowances ?? this.dailyAllowances,
      hra: hra ?? this.hra,
      phoneAllowances: phoneAllowances ?? this.phoneAllowances,
      childrenAllowances: childrenAllowances ?? this.childrenAllowances,
      esic: esic ?? this.esic,
      totalMonthlyCompensation:
          totalMonthlyCompensation ?? this.totalMonthlyCompensation,
      active: active ?? this.active,
      photoBytes: clearPhoto ? null : photoBytes ?? this.photoBytes,
      photoFileName: clearPhoto ? null : photoFileName ?? this.photoFileName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
