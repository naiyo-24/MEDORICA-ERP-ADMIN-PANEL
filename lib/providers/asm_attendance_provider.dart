import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm_attendance.dart';
import '../notifiers/asm_attendance_notifier.dart';

final asmAttendanceNotifierProvider =
    NotifierProvider<ASMAttendanceNotifier, ASMAttendanceState>(
  () => ASMAttendanceNotifier(),
);

final asmAttendanceListProvider = Provider<List<ASMAttendance>>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.filteredAttendanceList;
});

final selectedASMIdProvider = Provider<String>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.selectedASMId;
});

final selectedASMMonthProvider = Provider<int>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.selectedMonth;
});

final selectedASMYearProvider = Provider<int>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.selectedYear;
});
