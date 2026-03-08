import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gift.dart';
import '../models/mr.dart';
import '../models/mr_doctor_network.dart';
import '../models/mr_gift_application.dart';
import '../providers/gift_provider.dart';
import '../providers/mr_doctor_network_provider.dart';
import '../providers/mr_onboarding_provider.dart';

class MRGiftApplicationState {
  const MRGiftApplicationState({
    this.applications = const [],
    this.searchQuery = '',
    this.selectedMRId = '',
    this.selectedDoctorName = 'All Doctors',
  });

  final List<MRGiftApplication> applications;
  final String searchQuery;
  final String selectedMRId;
  final String selectedDoctorName;

  MRGiftApplicationState copyWith({
    List<MRGiftApplication>? applications,
    String? searchQuery,
    String? selectedMRId,
    String? selectedDoctorName,
  }) {
    return MRGiftApplicationState(
      applications: applications ?? this.applications,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedDoctorName: selectedDoctorName ?? this.selectedDoctorName,
    );
  }

  List<MRGiftApplication> get filteredApplications {
    final q = searchQuery.trim().toLowerCase();

    return applications.where((app) {
      final matchesMR =
          selectedMRId.isEmpty || app.mrRequestedById == selectedMRId;
      final matchesDoctor =
          selectedDoctorName == 'All Doctors' ||
          app.doctorName == selectedDoctorName;
      final matchesSearch =
          q.isEmpty ||
          app.mrRequestedBy.toLowerCase().contains(q) ||
          app.doctorName.toLowerCase().contains(q) ||
          app.giftItemRequired.toLowerCase().contains(q) ||
          app.occasion.toLowerCase().contains(q);

      return matchesMR && matchesDoctor && matchesSearch;
    }).toList();
  }
}

class MRGiftApplicationNotifier extends Notifier<MRGiftApplicationState> {
  @override
  MRGiftApplicationState build() {
    final gifts = ref.watch(giftListProvider);
    final mrs = ref.watch(mrOnboardingNotifierProvider).mrList;
    final doctors = ref.watch(mrDoctorNetworkNotifierProvider).doctorList;

    return MRGiftApplicationState(
      applications: _mockApplications(gifts: gifts, mrs: mrs, doctors: doctors),
    );
  }

  List<MRGiftApplication> _mockApplications({
    required List<Gift> gifts,
    required List<MR> mrs,
    required List<MRDoctorNetwork> doctors,
  }) {
    if (gifts.isEmpty || mrs.isEmpty || doctors.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final count = [
      gifts.length,
      mrs.length,
      doctors.length,
    ].reduce((a, b) => a < b ? a : b);

    return List.generate(count, (i) {
      return MRGiftApplication(
        id: 'MR-GA-${i + 100}',
        doctorName: doctors[i].doctorName,
        giftId: gifts[i].id,
        giftItemRequired: gifts[i].itemName,
        mrRequestedById: mrs[i].id,
        mrRequestedBy: mrs[i].name,
        date: now.subtract(Duration(days: i * 2 + 1)),
        occasion: i.isEven ? 'Doctor Meet' : 'Clinic Milestone',
        message: 'Requested for relationship engagement with key doctor.',
        status: GiftApplicationStatus
            .values[i % GiftApplicationStatus.values.length],
      );
    });
  }

  List<String> get doctorOptions {
    final names = state.applications.map((e) => e.doctorName).toSet().toList()
      ..sort();
    return ['All Doctors', ...names];
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedMRId(String value) {
    state = state.copyWith(selectedMRId: value);
  }

  void setSelectedDoctorName(String value) {
    state = state.copyWith(selectedDoctorName: value);
  }

  void updateStatus({
    required String applicationId,
    required GiftApplicationStatus status,
  }) {
    final updated = state.applications
        .map(
          (app) => app.id == applicationId ? app.copyWith(status: status) : app,
        )
        .toList();
    state = state.copyWith(applications: updated);
  }
}
