import 'dart:typed_data';

class ASMAttendance {
  const ASMAttendance({
    required this.id,
    required this.asmId,
    required this.asmName,
    required this.date,
    required this.isPresent,
    this.checkInTime,
    this.checkInSelfie,
    this.checkInSelfieFileName,
    this.checkOutTime,
    this.checkOutSelfie,
    this.checkOutSelfieFileName,
    this.remarks,
  });

  final String id;
  final String asmId;
  final String asmName;
  final DateTime date;
  final bool isPresent;
  final DateTime? checkInTime;
  final Uint8List? checkInSelfie;
  final String? checkInSelfieFileName;
  final DateTime? checkOutTime;
  final Uint8List? checkOutSelfie;
  final String? checkOutSelfieFileName;
  final String? remarks;

  bool get hasCheckInSelfie => checkInSelfie != null;
  bool get hasCheckOutSelfie => checkOutSelfie != null;

  ASMAttendance copyWith({
    String? id,
    String? asmId,
    String? asmName,
    DateTime? date,
    bool? isPresent,
    DateTime? checkInTime,
    Uint8List? checkInSelfie,
    String? checkInSelfieFileName,
    DateTime? checkOutTime,
    Uint8List? checkOutSelfie,
    String? checkOutSelfieFileName,
    String? remarks,
    bool clearCheckInSelfie = false,
    bool clearCheckOutSelfie = false,
  }) {
    return ASMAttendance(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      date: date ?? this.date,
      isPresent: isPresent ?? this.isPresent,
      checkInTime: checkInTime ?? this.checkInTime,
      checkInSelfie: clearCheckInSelfie
          ? null
          : checkInSelfie ?? this.checkInSelfie,
      checkInSelfieFileName: clearCheckInSelfie
          ? null
          : checkInSelfieFileName ?? this.checkInSelfieFileName,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkOutSelfie: clearCheckOutSelfie
          ? null
          : checkOutSelfie ?? this.checkOutSelfie,
      checkOutSelfieFileName: clearCheckOutSelfie
          ? null
          : checkOutSelfieFileName ?? this.checkOutSelfieFileName,
      remarks: remarks ?? this.remarks,
    );
  }
  static ASMAttendance fromJson(Map<String, dynamic> json) {
    return ASMAttendance(
      id: json['id'].toString(),
      asmId: json['asm_id'] ?? '',
      asmName: json['asm_name'] ?? '',
      date: DateTime.parse(json['date']),
      isPresent: (json['status'] ?? '').toLowerCase() == 'present',
      checkInTime: json['check_in_time'] != null ? DateTime.tryParse(json['check_in_time']) : null,
      checkInSelfie: null, // To be fetched separately if needed
      checkInSelfieFileName: json['check_in_selfie'],
      checkOutTime: json['check_out_time'] != null ? DateTime.tryParse(json['check_out_time']) : null,
      checkOutSelfie: null, // To be fetched separately if needed
      checkOutSelfieFileName: json['check_out_selfie'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asm_id': asmId,
      'asm_name': asmName,
      'date': date.toIso8601String(),
      'status': isPresent ? 'present' : 'absent',
      'check_in_time': checkInTime?.toIso8601String(),
      'check_in_selfie': checkInSelfieFileName,
      'check_out_time': checkOutTime?.toIso8601String(),
      'check_out_selfie': checkOutSelfieFileName,
      'remarks': remarks,
    };
  }
}
