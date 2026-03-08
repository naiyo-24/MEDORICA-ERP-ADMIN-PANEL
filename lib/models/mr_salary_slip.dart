import 'dart:typed_data';

class MRSalarySlip {
  const MRSalarySlip({
    required this.id,
    required this.mrId,
    required this.mrName,
    required this.month,
    required this.year,
    this.fileBytes,
    this.fileName,
  });

  final String id;
  final String mrId;
  final String mrName;
  final int month;
  final int year;
  final Uint8List? fileBytes;
  final String? fileName;

  MRSalarySlip copyWith({
    String? id,
    String? mrId,
    String? mrName,
    int? month,
    int? year,
    Uint8List? fileBytes,
    String? fileName,
    bool clearFile = false,
  }) {
    return MRSalarySlip(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
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
