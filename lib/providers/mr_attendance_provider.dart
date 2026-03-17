import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance/mr_attendance.dart';
import '../notifiers/mr_attendance_notifier.dart';
import '../services/attendance/mr_attendance_services.dart';
final mrAttendanceServicesProvider = Provider<MRAttendanceServices>((ref) {
  return MRAttendanceServices();
});

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
