import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/asm.dart';
import '../models/appointment/asm_appointments.dart';
import '../models/doctor_network/asm_doctor_network.dart';
import '../providers/asm_doctor_network_provider.dart';
import '../providers/onboarding/asm_onboarding_provider.dart';

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
  @override
  ASMAppointmentsState build() {
    final asmList = ref.watch(asmOnboardingNotifierProvider).asmList;
    final doctorList = ref.watch(asmDoctorNetworkNotifierProvider).doctorList;

    return ASMAppointmentsState(
      appointments: _buildMockAppointments(
        asmList: asmList,
        doctorList: doctorList,
      ),
    );
  }

  List<ASMAppointment> _buildMockAppointments({
    required List<ASM> asmList,
    required List<ASMDoctorNetwork> doctorList,
  }) {
    if (asmList.isEmpty || doctorList.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final appointments = <ASMAppointment>[];

    for (var i = 0; i < doctorList.length; i++) {
      final doctor = doctorList[i];
      final chamber = doctor.chambers.first;
      final date = now.add(Duration(days: (i % 4) - 1, hours: 9 + (i % 4)));

      appointments.add(
        ASMAppointment(
          id: 'ASM-APT-${1000 + i}',
          dateTime: date,
          asmId: doctor.asmAddedById,
          asmName: doctor.asmAddedBy,
          doctorName: doctor.doctorName,
          chamberName: chamber.name,
          chamberAddress: chamber.address,
          chamberPhone: chamber.phone,
          doctorPhone: doctor.phone,
          doctorSpecialization: doctor.specialization,
          status: ASMAppointmentStatus
              .values[i % ASMAppointmentStatus.values.length],
          appointmentProofImage: i % 3 == 0
              ? 'https://via.placeholder.com/600x400.png?text=Appointment+Proof+${1000 + i}'
              : null,
        ),
      );
    }

    if (appointments.length < 6) {
      appointments.add(
        ASMAppointment(
          id: 'ASM-APT-2001',
          dateTime: now.add(const Duration(days: 2, hours: 10)),
          asmId: doctorList.first.asmAddedById,
          asmName: doctorList.first.asmAddedBy,
          doctorName: doctorList.first.doctorName,
          chamberName: doctorList.first.chambers.first.name,
          chamberAddress: doctorList.first.chambers.first.address,
          chamberPhone: doctorList.first.chambers.first.phone,
          doctorPhone: doctorList.first.phone,
          doctorSpecialization: doctorList.first.specialization,
          status: ASMAppointmentStatus.scheduled,
          appointmentProofImage:
              'https://via.placeholder.com/600x400.png?text=Appointment+Proof+2001',
        ),
      );
    }

    return appointments;
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
