import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_appointments.dart';
import '../notifiers/mr_appointments_notifier.dart';

final mrAppointmentsNotifierProvider =
    NotifierProvider<MRAppointmentsNotifier, MRAppointmentsState>(
      MRAppointmentsNotifier.new,
    );

final mrAppointmentsListProvider = Provider<List<MRAppointment>>((ref) {
  return ref.watch(mrAppointmentsNotifierProvider).filteredAppointments;
});

final mrAppointmentsCountProvider = Provider<int>((ref) {
  return ref.watch(mrAppointmentsListProvider).length;
});

final selectedMRAppointmentIdProvider = Provider<String>((ref) {
  return ref.watch(mrAppointmentsNotifierProvider).selectedMRId;
});

final selectedMRAppointmentDateProvider = Provider<DateTime?>((ref) {
  return ref.watch(mrAppointmentsNotifierProvider).selectedDate;
});
