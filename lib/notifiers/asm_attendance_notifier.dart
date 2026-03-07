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
        .where((attendance) =>
            attendance.asmId == selectedASMId &&
            attendance.date.month == selectedMonth &&
            attendance.date.year == selectedYear)
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
}

class ASMAttendanceNotifier extends Notifier<ASMAttendanceState> {
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
      if (date.weekday != DateTime.sunday && date.isBefore(now.add(const Duration(days: 1)))) {
        final isPresent = day % 7 != 0; // Mock: absent every 7th day
        attendanceList.add(
          ASMAttendance(
            id: 'att_asm1_$day',
            asmId: 'asm_1',
            asmName: 'Vikram Singh',
            date: date,
            isPresent: isPresent,
            checkInTime: isPresent ? DateTime(now.year, now.month, day, 9, 15) : null,
            checkOutTime: isPresent ? DateTime(now.year, now.month, day, 18, 30) : null,
            remarks: isPresent ? 'Completed field visits' : 'Sick leave',
          ),
        );
      }
    }

    // Generate attendance for current month for ASM 2 (Neha Gupta)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday != DateTime.sunday && date.isBefore(now.add(const Duration(days: 1)))) {
        final isPresent = day % 10 != 0; // Mock: absent every 10th day
        attendanceList.add(
          ASMAttendance(
            id: 'att_asm2_$day',
            asmId: 'asm_2',
            asmName: 'Neha Gupta',
            date: date,
            isPresent: isPresent,
            checkInTime: isPresent ? DateTime(now.year, now.month, day, 9, 0) : null,
            checkOutTime: isPresent ? DateTime(now.year, now.month, day, 18, 45) : null,
            remarks: isPresent ? 'Territory meetings completed' : 'Personal leave',
          ),
        );
      }
    }

    // Generate attendance for current month for ASM 3 (Arun Kumar)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday != DateTime.sunday && date.isBefore(now.add(const Duration(days: 1)))) {
        final isPresent = day % 8 != 0; // Mock: absent every 8th day
        attendanceList.add(
          ASMAttendance(
            id: 'att_asm3_$day',
            asmId: 'asm_3',
            asmName: 'Arun Kumar',
            date: date,
            isPresent: isPresent,
            checkInTime: isPresent ? DateTime(now.year, now.month, day, 8, 45) : null,
            checkOutTime: isPresent ? DateTime(now.year, now.month, day, 19, 0) : null,
            remarks: isPresent ? 'Field work and team supervision' : 'Casual leave',
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
        asmName: '',
        date: date,
        isPresent: false,
      ),
    );

    final updatedAttendance = existingAttendance.copyWith(isPresent: isPresent);
    final newList = state.attendanceList.map((att) {
      if (att.id == updatedAttendance.id) {
        return updatedAttendance;
      }
      return att;
    }).toList();

    state = state.copyWith(attendanceList: newList, isSaving: false);
  }
}
