import '../../services/attendance/asm_attendance_services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/attendance/asm_attendance.dart';
import '../../notifiers/attendance/asm_attendance_notifier.dart';
final asmAttendanceServicesProvider = Provider<ASMAttendanceServices>((ref) {
  return ASMAttendanceServices();
});
final asmAttendanceNotifierProvider =
    NotifierProvider<ASMAttendanceNotifier, ASMAttendanceState>(
      ASMAttendanceNotifier.new,
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

final asmAttendanceByDateProvider = Provider.family<ASMAttendance?, DateTime>((
  ref,
  date,
) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.getAttendanceForDate(date);
});

final asmCheckInSelfieCountProvider = Provider<int>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.checkInSelfieCount;
});

final asmCheckOutSelfieCountProvider = Provider<int>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.checkOutSelfieCount;
});

final asmPresentCountProvider = Provider<int>((ref) {
  final state = ref.watch(asmAttendanceNotifierProvider);
  return state.presentCount;
});
