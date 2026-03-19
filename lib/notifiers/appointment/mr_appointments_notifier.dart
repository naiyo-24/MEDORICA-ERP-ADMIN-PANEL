import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/appointment/mr_appointments.dart';
import '../../services/appointment/mr_appointment_services.dart';

class MRAppointmentsState {
  const MRAppointmentsState({
    this.appointments = const [],
    this.selectedMRId = '',
    this.selectedDate,
    this.isLoading = false,
    this.error,
  });

  final List<MRAppointment> appointments;
  final String selectedMRId;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? error;

  MRAppointmentsState copyWith({
    List<MRAppointment>? appointments,
    String? selectedMRId,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
    bool? isLoading,
    String? error,
  }) {
    final bool loading = isLoading ?? this.isLoading;
    return MRAppointmentsState(
      appointments: appointments ?? this.appointments,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
      isLoading: loading,
      error: error,
    );
  }

  List<MRAppointment> get filteredAppointments {
    return appointments.where((appointment) {
      final matchesMR =
          selectedMRId.isEmpty || appointment.mrId == selectedMRId;
      final matchesDate = selectedDate == null
          ? true
          : _isSameDate(appointment.dateTime, selectedDate!);
      return matchesMR && matchesDate;
    }).toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  static bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class MRAppointmentsNotifier extends Notifier<MRAppointmentsState> {
  @override
  MRAppointmentsState build() {
    return const MRAppointmentsState();
  }

  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final services = MRAppointmentServices();
      final appointments = await services.getAllAppointments();
      state = state.copyWith(appointments: appointments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load appointments: $e');
    }
  }

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
  }

  void setSelectedDate(DateTime? date) {
    state = state.copyWith(selectedDate: date);
  }

  void clearDateFilter() {
    state = state.copyWith(clearSelectedDate: true);
  }
  // ...existing code...
}