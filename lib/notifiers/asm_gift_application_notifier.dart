import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/asm.dart';
import '../models/doctor_network/asm_doctor_network.dart';
import '../models/gift/asm_gift_application.dart';
import '../models/gift/gift.dart';
import '../providers/asm_doctor_network_provider.dart';
import '../providers/onboarding/asm_onboarding_provider.dart';
import '../providers/gift_provider.dart';

class ASMGiftApplicationState {
  const ASMGiftApplicationState({
    this.applications = const [],
    this.searchQuery = '',
    this.selectedASMId = '',
    this.selectedDoctorName = 'All Doctors',
  });

  final List<ASMGiftApplication> applications;
  final String searchQuery;
  final String selectedASMId;
  final String selectedDoctorName;

  ASMGiftApplicationState copyWith({
    List<ASMGiftApplication>? applications,
    String? searchQuery,
    String? selectedASMId,
    String? selectedDoctorName,
  }) {
    return ASMGiftApplicationState(
      applications: applications ?? this.applications,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedDoctorName: selectedDoctorName ?? this.selectedDoctorName,
    );
  }

  List<ASMGiftApplication> get filteredApplications {
    final q = searchQuery.trim().toLowerCase();

    return applications.where((app) {
      final matchesASM =
          selectedASMId.isEmpty || app.asmRequestedById == selectedASMId;
      final matchesDoctor =
          selectedDoctorName == 'All Doctors' ||
          app.doctorName == selectedDoctorName;
      final matchesSearch =
          q.isEmpty ||
          app.asmRequestedBy.toLowerCase().contains(q) ||
          app.doctorName.toLowerCase().contains(q) ||
          app.giftItemRequired.toLowerCase().contains(q) ||
          app.occasion.toLowerCase().contains(q);

      return matchesASM && matchesDoctor && matchesSearch;
    }).toList();
  }
}

class ASMGiftApplicationNotifier extends Notifier<ASMGiftApplicationState> {
  @override
  ASMGiftApplicationState build() {
    final gifts = ref.watch(giftListProvider);
    final asms = ref.watch(asmOnboardingNotifierProvider).asmList;
    final doctors = ref.watch(asmDoctorNetworkNotifierProvider).doctorList;

    return ASMGiftApplicationState(
      applications: _mockApplications(
        gifts: gifts,
        asms: asms,
        doctors: doctors,
      ),
    );
  }

  List<ASMGiftApplication> _mockApplications({
    required List<Gift> gifts,
    required List<ASM> asms,
    required List<ASMDoctorNetwork> doctors,
  }) {
    if (gifts.isEmpty || asms.isEmpty || doctors.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final count = [
      gifts.length,
      asms.length,
      doctors.length,
    ].reduce((a, b) => a < b ? a : b);

    return List.generate(count, (i) {
      return ASMGiftApplication(
        id: 'ASM-GA-${i + 100}',
        doctorName: doctors[i].doctorName,
        giftId: gifts[i].id,
        giftItemRequired: gifts[i].itemName,
        asmRequestedById: asms[i].asmId,
        asmRequestedBy: asms[i].name,
        date: now.subtract(Duration(days: i * 2 + 2)),
        occasion: i.isEven ? 'Quarterly Camp' : 'Specialist Visit',
        message: 'Requested for field engagement with targeted specialist.',
        status: ASMGiftApplicationStatus
            .values[i % ASMGiftApplicationStatus.values.length],
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

  void setSelectedASMId(String value) {
    state = state.copyWith(selectedASMId: value);
  }

  void setSelectedDoctorName(String value) {
    state = state.copyWith(selectedDoctorName: value);
  }

  void updateStatus({
    required String applicationId,
    required ASMGiftApplicationStatus status,
  }) {
    final updated = state.applications
        .map(
          (app) => app.id == applicationId ? app.copyWith(status: status) : app,
        )
        .toList();
    state = state.copyWith(applications: updated);
  }
}
