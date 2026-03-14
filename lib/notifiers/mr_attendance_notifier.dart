import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance/mr_attendance.dart';

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
  @override
  MRAttendanceState build() {
    final now = DateTime.now();
    return MRAttendanceState(
      attendanceList: _mockAttendanceData(),
      selectedMonth: now.month,
      selectedYear: now.year,
    );
  }

  List<MRAttendance> _mockAttendanceData() {
    final now = DateTime.now();
    final List<MRAttendance> attendanceList = [];

    // Generate attendance for current month for MR 1 (Rajesh Kumar)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      // Skip Sundays
      if (date.weekday == DateTime.sunday) {
        continue;
      }

      // Only generate for days that have passed
      if (date.isAfter(now)) {
        continue;
      }

      final isPresent = day % 5 != 0; // Absent every 5th day
      attendanceList.add(
        MRAttendance(
          id: 'att_mr1_$day',
          mrId: 'mr_1',
          mrName: 'Rajesh Kumar',
          date: date,
          isPresent: isPresent,
          checkInTime: isPresent
              ? DateTime(date.year, date.month, date.day, 9, 15 + (day % 30))
              : null,
          checkOutTime: isPresent
              ? DateTime(date.year, date.month, date.day, 18, 10 + (day % 30))
              : null,
          remarks: isPresent ? 'On time' : 'Not marked attendance',
        ),
      );
    }

    // Generate attendance for current month for MR 2 (Priya Sharma)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday == DateTime.sunday) {
        continue;
      }

      if (date.isAfter(now)) {
        continue;
      }

      final isPresent = day % 7 != 0;
      attendanceList.add(
        MRAttendance(
          id: 'att_mr2_$day',
          mrId: 'mr_2',
          mrName: 'Priya Sharma',
          date: date,
          isPresent: isPresent,
          checkInTime: isPresent
              ? DateTime(date.year, date.month, date.day, 9, 0 + (day % 20))
              : null,
          checkOutTime: isPresent
              ? DateTime(date.year, date.month, date.day, 18, 30 + (day % 20))
              : null,
          remarks: isPresent ? 'Regular attendance' : 'Absent',
        ),
      );
    }

    // Generate attendance for current month for MR 3 (Amit Patel)
    for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
      final date = DateTime(now.year, now.month, day);
      if (date.weekday == DateTime.sunday) {
        continue;
      }

      if (date.isAfter(now)) {
        continue;
      }

      final isPresent = day % 6 != 0;
      attendanceList.add(
        MRAttendance(
          id: 'att_mr3_$day',
          mrId: 'mr_3',
          mrName: 'Amit Patel',
          date: date,
          isPresent: isPresent,
          checkInTime: isPresent
              ? DateTime(date.year, date.month, date.day, 8, 45 + (day % 25))
              : null,
          checkOutTime: isPresent
              ? DateTime(date.year, date.month, date.day, 19, 0 + (day % 25))
              : null,
          remarks: isPresent ? 'Good attendance' : 'Leave taken',
        ),
      );
    }

    return attendanceList;
  }

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
  }

  void setSelectedMonth(int month, int year) {
    state = state.copyWith(selectedMonth: month, selectedYear: year);
  }

  Future<void> markAttendance({
    required String mrId,
    required String mrName,
    required DateTime date,
    required bool isPresent,
  }) async {
    state = state.copyWith(isSaving: true);

    await Future.delayed(const Duration(milliseconds: 500));

    final existingAttendance = state.attendanceList.firstWhere(
      (att) =>
          att.mrId == mrId &&
          att.date.year == date.year &&
          att.date.month == date.month &&
          att.date.day == date.day,
      orElse: () => MRAttendance(
        id: 'att_${mrId}_${date.day}',
        mrId: mrId,
        mrName: mrName,
        date: date,
        isPresent: false,
      ),
    );

    final updatedAttendance = existingAttendance.copyWith(
      isPresent: isPresent,
      checkInTime: isPresent ? DateTime.now() : null,
      checkOutTime: isPresent
          ? DateTime.now().add(const Duration(hours: 9))
          : null,
      remarks: isPresent ? 'Marked by admin' : 'Marked absent by admin',
    );

    final newList =
        state.attendanceList
            .where((att) => att.id != existingAttendance.id)
            .toList()
          ..add(updatedAttendance);

    state = state.copyWith(attendanceList: newList, isSaving: false);
  }
}
