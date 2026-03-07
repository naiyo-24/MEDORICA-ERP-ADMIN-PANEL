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
  }) {
    return ASMAttendance(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      date: date ?? this.date,
      isPresent: isPresent ?? this.isPresent,
      checkInTime: checkInTime ?? this.checkInTime,
      checkInSelfie: checkInSelfie ?? this.checkInSelfie,
      checkInSelfieFileName: checkInSelfieFileName ?? this.checkInSelfieFileName,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkOutSelfie: checkOutSelfie ?? this.checkOutSelfie,
      checkOutSelfieFileName: checkOutSelfieFileName ?? this.checkOutSelfieFileName,
      remarks: remarks ?? this.remarks,
    );
  }
}
