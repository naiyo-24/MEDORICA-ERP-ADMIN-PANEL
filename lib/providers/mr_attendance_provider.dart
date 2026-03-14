import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance/mr_attendance.dart';
import '../notifiers/mr_attendance_notifier.dart';

final mrAttendanceNotifierProvider =
    NotifierProvider<MRAttendanceNotifier, MRAttendanceState>(
      () => MRAttendanceNotifier(),
    );

final mrAttendanceListProvider = Provider<List<MRAttendance>>((ref) {
  final state = ref.watch(mrAttendanceNotifierProvider);
  return state.filteredAttendanceList;
});

final selectedMRIdProvider = Provider<String>((ref) {
  final state = ref.watch(mrAttendanceNotifierProvider);
  return state.selectedMRId;
});

final selectedMonthProvider = Provider<int>((ref) {
  final state = ref.watch(mrAttendanceNotifierProvider);
  return state.selectedMonth;
});

final selectedYearProvider = Provider<int>((ref) {
  final state = ref.watch(mrAttendanceNotifierProvider);
  return state.selectedYear;
});
