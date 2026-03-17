

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/attendance/asm_attendance.dart';
import '../../services/attendance/asm_attendance_services.dart';

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
    // Fetch attendance for selected ASM
    Future<void> fetchAttendanceForAsm(String asmId) async {
      try {
        final list = await _services.getAttendanceByAsmId(asmId);
        state = state.copyWith(attendanceList: list, selectedASMId: asmId);
      } catch (e) {
        // Optionally handle error
      }
    }

    void setSelectedASM(String asmId) {
      state = state.copyWith(selectedASMId: asmId);
      fetchAttendanceForAsm(asmId);
    }

    void setSelectedMonth(int month, int year) {
      state = state.copyWith(selectedMonth: month, selectedYear: year);
    }

    Future<void> markAttendance({
      required String asmId,
      required int attendanceId,
      required bool isPresent,
    }) async {
      state = state.copyWith(isSaving: true);
      try {
        final updated = await _services.updateAttendance(
          asmId: asmId,
          attendanceId: attendanceId,
          status: isPresent ? 'present' : 'absent',
        );
        final newList = state.attendanceList.map((a) => a.id == updated.id ? updated : a).toList();
        state = state.copyWith(attendanceList: newList, isSaving: false);
      } catch (e) {
        state = state.copyWith(isSaving: false);
        // Optionally handle error
      }
    }
  late final ASMAttendanceServices _services;

  @override
  ASMAttendanceState build() {
    _services = ASMAttendanceServices();
    final now = DateTime.now();
    _fetchAttendanceList();
    return ASMAttendanceState(
      attendanceList: [],
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  Future<void> _fetchAttendanceList() async {
    try {
      final list = await _services.getAllAttendance();
      state = state.copyWith(attendanceList: list);
    } catch (e) {
      // Optionally handle error
    }
  }

}
 