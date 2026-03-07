import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm_attendance.dart';

class ASMAttendanceState {
  const ASMAttendanceState({
    this.attendanceList = const [],
    this.selectedASMId = '',
    this.selectedMonth = 0,
    this.selectedYear = 0,
    this.isSaving = false,
  });

  final List<ASMAttendance> attendanceList;
  final String selectedASMId;
  final int selectedMonth;
  final int selectedYear;
  final bool isSaving;

  ASMAttendanceState copyWith({
    List<ASMAttendance>? attendanceList,
    String? selectedASMId,
    int? selectedMonth,
    int? selectedYear,
    bool? isSaving,
  }) {
    return ASMAttendanceState(
      attendanceList: attendanceList ?? this.attendanceList,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  List<ASMAttendance> get filteredAttendanceList {
    if (selectedASMId.isEmpty) {
      return attendanceList;
    }

    return attendanceList
        .where(
          (attendance) =>
              attendance.asmId == selectedASMId &&
              attendance.date.month == selectedMonth &&
              attendance.date.year == selectedYear,
        )
        .toList();
  }

  ASMAttendance? getAttendanceForDate(DateTime date) {
    try {
      return attendanceList.firstWhere(
        (attendance) =>
            attendance.asmId == selectedASMId &&
            attendance.date.year == date.year &&
            attendance.date.month == date.month &&
            attendance.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  int get checkInSelfieCount => filteredAttendanceList
      .where((attendance) => attendance.hasCheckInSelfie)
      .length;

  int get checkOutSelfieCount => filteredAttendanceList
      .where((attendance) => attendance.hasCheckOutSelfie)
      .length;

  int get presentCount =>
      filteredAttendanceList.where((attendance) => attendance.isPresent).length;
}

class ASMAttendanceNotifier extends Notifier<ASMAttendanceState> {
  static final Uint8List _mockSelfieBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO7YVboAAAAASUVORK5CYII=',
  );

  @override
  ASMAttendanceState build() {
    final now = DateTime.now();
    return ASMAttendanceState(
      attendanceList: _mockAttendanceData(),
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  List<ASMAttendance> _mockAttendanceData() {
    final now = DateTime.now();
    final List<ASMAttendance> attendanceList = [];

    // Generate attendance for current month for ASM 1 (Vikram Singh)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday != DateTime.sunday &&
          date.isBefore(now.add(const Duration(days: 1)))) {
        final isPresent = day % 7 != 0; // Mock: absent every 7th day
        attendanceList.add(
          ASMAttendance(
            id: 'att_asm1_$day',
            asmId: 'asm_1',
            asmName: 'Vikram Singh',
            date: date,
            isPresent: isPresent,
            checkInTime: isPresent
                ? DateTime(now.year, now.month, day, 9, 15)
                : null,
            checkInSelfie: isPresent ? _mockSelfieBytes : null,
            checkInSelfieFileName: isPresent ? 'asm1_checkin_$day.jpg' : null,
            checkOutTime: isPresent
                ? DateTime(now.year, now.month, day, 18, 30)
                : null,
            checkOutSelfie: isPresent && day % 3 != 0 ? _mockSelfieBytes : null,
            checkOutSelfieFileName: isPresent && day % 3 != 0
                ? 'asm1_checkout_$day.jpg'
                : null,
            remarks: isPresent ? 'Completed field visits' : 'Sick leave',
          ),
        );
      }
    }

    // Generate attendance for current month for ASM 2 (Neha Gupta)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday != DateTime.sunday &&
          date.isBefore(now.add(const Duration(days: 1)))) {
        final isPresent = day % 10 != 0; // Mock: absent every 10th day
        attendanceList.add(
          ASMAttendance(
            id: 'att_asm2_$day',
            asmId: 'asm_2',
            asmName: 'Neha Gupta',
            date: date,
            isPresent: isPresent,
            checkInTime: isPresent
                ? DateTime(now.year, now.month, day, 9, 0)
                : null,
            checkInSelfie: isPresent ? _mockSelfieBytes : null,
            checkInSelfieFileName: isPresent ? 'asm2_checkin_$day.jpg' : null,
            checkOutTime: isPresent
                ? DateTime(now.year, now.month, day, 18, 45)
                : null,
            checkOutSelfie: isPresent && day % 4 != 0 ? _mockSelfieBytes : null,
            checkOutSelfieFileName: isPresent && day % 4 != 0
                ? 'asm2_checkout_$day.jpg'
                : null,
            remarks: isPresent
                ? 'Territory meetings completed'
                : 'Personal leave',
          ),
        );
      }
    }

    // Generate attendance for current month for ASM 3 (Arun Kumar)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday != DateTime.sunday &&
          date.isBefore(now.add(const Duration(days: 1)))) {
        final isPresent = day % 8 != 0; // Mock: absent every 8th day
        attendanceList.add(
          ASMAttendance(
            id: 'att_asm3_$day',
            asmId: 'asm_3',
            asmName: 'Arun Kumar',
            date: date,
            isPresent: isPresent,
            checkInTime: isPresent
                ? DateTime(now.year, now.month, day, 8, 45)
                : null,
            checkInSelfie: isPresent ? _mockSelfieBytes : null,
            checkInSelfieFileName: isPresent ? 'asm3_checkin_$day.jpg' : null,
            checkOutTime: isPresent
                ? DateTime(now.year, now.month, day, 19, 0)
                : null,
            checkOutSelfie: isPresent && day % 5 != 0 ? _mockSelfieBytes : null,
            checkOutSelfieFileName: isPresent && day % 5 != 0
                ? 'asm3_checkout_$day.jpg'
                : null,
            remarks: isPresent
                ? 'Field work and team supervision'
                : 'Casual leave',
          ),
        );
      }
    }

    return attendanceList;
  }

  void setSelectedASM(String asmId) {
    state = state.copyWith(selectedASMId: asmId);
  }

  void setSelectedMonth(int month, int year) {
    state = state.copyWith(selectedMonth: month, selectedYear: year);
  }

  Future<void> markAttendance({
    required String asmId,
    required DateTime date,
    required bool isPresent,
    String? asmName,
    DateTime? checkInTime,
    Uint8List? checkInSelfie,
    String? checkInSelfieFileName,
    DateTime? checkOutTime,
    Uint8List? checkOutSelfie,
    String? checkOutSelfieFileName,
    String? remarks,
  }) async {
    state = state.copyWith(isSaving: true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final existingAttendance = state.attendanceList.firstWhere(
      (att) =>
          att.asmId == asmId &&
          att.date.year == date.year &&
          att.date.month == date.month &&
          att.date.day == date.day,
      orElse: () => ASMAttendance(
        id: 'att_${asmId}_${date.day}',
        asmId: asmId,
        asmName: asmName ?? 'Unknown ASM',
        date: date,
        isPresent: false,
      ),
    );

    final updatedAttendance = existingAttendance.copyWith(
      asmName: asmName ?? existingAttendance.asmName,
      isPresent: isPresent,
      checkInTime: isPresent
          ? (checkInTime ?? existingAttendance.checkInTime ?? DateTime.now())
          : null,
      checkInSelfie: checkInSelfie,
      checkInSelfieFileName: checkInSelfieFileName,
      checkOutTime: isPresent
          ? (checkOutTime ?? existingAttendance.checkOutTime)
          : null,
      checkOutSelfie: checkOutSelfie,
      checkOutSelfieFileName: checkOutSelfieFileName,
      remarks: remarks ?? existingAttendance.remarks,
      clearCheckInSelfie: !isPresent,
      clearCheckOutSelfie: !isPresent,
    );

    final newList =
        state.attendanceList
            .where((att) => att.id != existingAttendance.id)
            .toList()
          ..add(updatedAttendance);

    state = state.copyWith(attendanceList: newList, isSaving: false);
  }
}
