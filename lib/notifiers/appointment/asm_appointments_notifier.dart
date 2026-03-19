import '../../services/appointment/asm_appointment_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/appointment/asm_appointments.dart';

class ASMAppointmentsState {
  const ASMAppointmentsState({
    this.appointments = const [],
    this.selectedASMId = '',
    this.selectedDate,
  });

  final List<ASMAppointment> appointments;
  final String selectedASMId;
  final DateTime? selectedDate;

  ASMAppointmentsState copyWith({
    List<ASMAppointment>? appointments,
    String? selectedASMId,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return ASMAppointmentsState(
      appointments: appointments ?? this.appointments,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
    );
  }

  List<ASMAppointment> get filteredAppointments {
    return appointments.where((appointment) {
      final matchesASM =
          selectedASMId.isEmpty || appointment.asmId == selectedASMId;
      final matchesDate = selectedDate == null
          ? true
          : _isSameDate(appointment.dateTime, selectedDate!);
      return matchesASM && matchesDate;
    }).toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  static bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class ASMAppointmentsNotifier extends Notifier<ASMAppointmentsState> {

  final ASMAppointmentServices _services = ASMAppointmentServices();

  @override
  ASMAppointmentsState build() {
    _loadAppointments();
    return const ASMAppointmentsState();
  }

  Future<void> _loadAppointments() async {
    final appointments = await _services.getAllAppointments();
    state = state.copyWith(appointments: appointments);
  }


  void setSelectedASM(String asmId) {
    state = state.copyWith(selectedASMId: asmId);
  }

  void setSelectedDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearSelectedDate: true);
      return;
    }
    state = state.copyWith(selectedDate: date);
  }

  void clearDateFilter() {
    state = state.copyWith(clearSelectedDate: true);
  }
}
