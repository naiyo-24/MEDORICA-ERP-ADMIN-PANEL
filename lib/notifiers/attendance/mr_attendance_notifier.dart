import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/attendance/mr_attendance.dart';
import '../../services/attendance/mr_attendance_services.dart';

class MRAttendanceState {
  const MRAttendanceState({
    this.attendanceList = const [],
    this.selectedMRId = '',
    this.selectedMonth = 0,
    this.selectedYear = 0,
    this.isSaving = false,
  });

  final List<MRAttendance> attendanceList;
  final String selectedMRId;
  final int selectedMonth;
  final int selectedYear;
  final bool isSaving;

  MRAttendanceState copyWith({
    List<MRAttendance>? attendanceList,
    String? selectedMRId,
    int? selectedMonth,
    int? selectedYear,
    bool? isSaving,
  }) {
    return MRAttendanceState(
      attendanceList: attendanceList ?? this.attendanceList,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  List<MRAttendance> get filteredAttendanceList {
    if (selectedMRId.isEmpty) {
      return [];
    }

    return attendanceList
        .where(
          (attendance) =>
              attendance.mrId == selectedMRId &&
              attendance.date.month == selectedMonth &&
              attendance.date.year == selectedYear,
        )
        .toList();
  }

  MRAttendance? getAttendanceForDate(DateTime date) {
    try {
      return filteredAttendanceList.firstWhere(
        (attendance) =>
            attendance.date.year == date.year &&
            attendance.date.month == date.month &&
            attendance.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }
}

class MRAttendanceNotifier extends Notifier<MRAttendanceState> {
  late final MRAttendanceServices _services;

  @override
  MRAttendanceState build() {
    _services = MRAttendanceServices();
    final now = DateTime.now();
    _fetchAttendanceList();
    return MRAttendanceState(
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

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
    _fetchAttendanceListByMr(mrId);
  }

  Future<void> _fetchAttendanceListByMr(String mrId) async {
    try {
      final list = await _services.getAttendanceByMrId(mrId);
      state = state.copyWith(attendanceList: list);
    } catch (e) {
      // Optionally handle error
    }
  }

  void setSelectedMonth(int month, int year) {
    state = state.copyWith(selectedMonth: month, selectedYear: year);
  }

  Future<void> markAttendance({
    required String mrId,
    required int attendanceId,
    required bool isPresent,
  }) async {
    state = state.copyWith(isSaving: true);
    try {
      final updated = await _services.updateAttendance(
        mrId: mrId,
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
}
