import 'dart:typed_data';

class MRAttendance {
  const MRAttendance({
    required this.id,
    required this.mrId,
    required this.mrName,
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
  final String mrId;
  final String mrName;
  final DateTime date;
  final bool isPresent;
  final DateTime? checkInTime;
  final Uint8List? checkInSelfie;
  final String? checkInSelfieFileName;
  final DateTime? checkOutTime;
  final Uint8List? checkOutSelfie;
  final String? checkOutSelfieFileName;
  final String? remarks;

  MRAttendance copyWith({
    String? id,
    String? mrId,
    String? mrName,
    DateTime? date,
    bool? isPresent,
    DateTime? checkInTime,
    Uint8List? checkInSelfie,
    String? checkInSelfieFileName,
    DateTime? checkOutTime,
    Uint8List? checkOutSelfie,
    String? checkOutSelfieFileName,
    String? remarks,
  }) {
    return MRAttendance(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
      date: date ?? this.date,
      isPresent: isPresent ?? this.isPresent,
      checkInTime: checkInTime ?? this.checkInTime,
      checkInSelfie: checkInSelfie ?? this.checkInSelfie,
      checkInSelfieFileName:
          checkInSelfieFileName ?? this.checkInSelfieFileName,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkOutSelfie: checkOutSelfie ?? this.checkOutSelfie,
      checkOutSelfieFileName:
          checkOutSelfieFileName ?? this.checkOutSelfieFileName,
      remarks: remarks ?? this.remarks,
    );
  }
  static MRAttendance fromJson(Map<String, dynamic> json) {
    return MRAttendance(
      id: json['id'].toString(),
      mrId: json['mr_id'] ?? '',
      mrName: json['mr_name'] ?? '',
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
      'mr_id': mrId,
      'mr_name': mrName,
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
