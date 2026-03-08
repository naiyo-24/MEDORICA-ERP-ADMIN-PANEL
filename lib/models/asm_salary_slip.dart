import 'dart:typed_data';

class ASMSalarySlip {
  const ASMSalarySlip({
    required this.id,
    required this.asmId,
    required this.asmName,
    required this.month,
    required this.year,
    this.fileBytes,
    this.fileName,
  });

  final String id;
  final String asmId;
  final String asmName;
  final int month;
  final int year;
  final Uint8List? fileBytes;
  final String? fileName;

  ASMSalarySlip copyWith({
    String? id,
    String? asmId,
    String? asmName,
    int? month,
    int? year,
    Uint8List? fileBytes,
    String? fileName,
    bool clearFile = false,
  }) {
    return ASMSalarySlip(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      month: month ?? this.month,
      year: year ?? this.year,
      fileBytes: clearFile ? null : fileBytes ?? this.fileBytes,
      fileName: clearFile ? null : fileName ?? this.fileName,
    );
  }

  bool get hasFile => fileBytes != null && fileName != null;

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
