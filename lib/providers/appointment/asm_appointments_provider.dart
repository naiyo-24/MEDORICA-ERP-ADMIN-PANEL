import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/appointment/asm_appointments.dart';
import '../../notifiers/appointment/asm_appointments_notifier.dart';

final asmAppointmentsNotifierProvider =
    NotifierProvider<ASMAppointmentsNotifier, ASMAppointmentsState>(
      ASMAppointmentsNotifier.new,
    );

final asmAppointmentsListProvider = Provider<List<ASMAppointment>>((ref) {
  return ref.watch(asmAppointmentsNotifierProvider).filteredAppointments;
});

final asmAppointmentsCountProvider = Provider<int>((ref) {
  return ref.watch(asmAppointmentsListProvider).length;
});

final selectedASMAppointmentIdProvider = Provider<String>((ref) {
  return ref.watch(asmAppointmentsNotifierProvider).selectedASMId;
});

final selectedASMAppointmentDateProvider = Provider<DateTime?>((ref) {
  return ref.watch(asmAppointmentsNotifierProvider).selectedDate;
});
