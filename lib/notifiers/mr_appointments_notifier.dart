import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr.dart';
import '../models/mr_appointments.dart';
import '../models/mr_doctor_network.dart';
import '../providers/mr_doctor_network_provider.dart';
import '../providers/mr_onboarding_provider.dart';

class MRAppointmentsState {
  const MRAppointmentsState({
    this.appointments = const [],
    this.selectedMRId = '',
    this.selectedDate,
  });

  final List<MRAppointment> appointments;
  final String selectedMRId;
  final DateTime? selectedDate;

  MRAppointmentsState copyWith({
    List<MRAppointment>? appointments,
    String? selectedMRId,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return MRAppointmentsState(
      appointments: appointments ?? this.appointments,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
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
    final mrList = ref.watch(mrOnboardingNotifierProvider).mrList;
    final doctorList = ref.watch(mrDoctorNetworkNotifierProvider).doctorList;

    return MRAppointmentsState(
      appointments: _buildMockAppointments(
        mrList: mrList,
        doctorList: doctorList,
      ),
    );
  }

  List<MRAppointment> _buildMockAppointments({
    required List<MR> mrList,
    required List<MRDoctorNetwork> doctorList,
  }) {
    if (mrList.isEmpty || doctorList.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final appointments = <MRAppointment>[];

    for (var i = 0; i < doctorList.length; i++) {
      final doctor = doctorList[i];
      final chamber = doctor.chambers.first;
      final date = now.add(Duration(days: (i % 4) - 1, hours: 10 + (i % 4)));

      appointments.add(
        MRAppointment(
          id: 'MR-APT-${1000 + i}',
          dateTime: date,
          mrId: doctor.mrAddedById,
          mrName: doctor.mrAddedBy,
          doctorName: doctor.doctorName,
          chamberName: chamber.name,
          chamberAddress: chamber.address,
          chamberPhone: chamber.phone,
          doctorPhone: doctor.phone,
          doctorSpecialization: doctor.specialization,
          status: AppointmentStatus.values[i % AppointmentStatus.values.length],
        ),
      );
    }

    if (appointments.length < 6) {
      appointments.add(
        MRAppointment(
          id: 'MR-APT-2001',
          dateTime: now.add(const Duration(days: 2, hours: 11)),
          mrId: doctorList.first.mrAddedById,
          mrName: doctorList.first.mrAddedBy,
          doctorName: doctorList.first.doctorName,
          chamberName: doctorList.first.chambers.first.name,
          chamberAddress: doctorList.first.chambers.first.address,
          chamberPhone: doctorList.first.chambers.first.phone,
          doctorPhone: doctorList.first.phone,
          doctorSpecialization: doctorList.first.specialization,
          status: AppointmentStatus.scheduled,
        ),
      );
    }

    return appointments;
  }

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
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
