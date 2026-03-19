import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/gift/asm_gift_application.dart';
import '../../services/gift/asm_gift_application_services.dart';

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
  late final ASMGiftApplicationServices _services;

  @override
  ASMGiftApplicationState build() {
    _services = ASMGiftApplicationServices();
    Future.microtask(loadApplications);
    return const ASMGiftApplicationState();
  }

  Future<void> loadApplications({String? asmId}) async {
    List<ASMGiftApplication> apps = [];
    if (asmId != null && asmId.isNotEmpty) {
      apps = await _services.getApplicationsByASM(asmId);
    } else {
      apps = await _services.getAllApplications();
    }
    state = state.copyWith(applications: apps);
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

  Future<void> updateStatus({
    required String asmId,
    required String applicationId,
    required ASMGiftApplicationStatus status,
  }) async {
    final updatedApp = await _services.updateApplicationStatus(
      asmId: asmId,
      requestId: int.parse(applicationId),
      status: status,
    );
    final updated = state.applications
        .map((app) => app.id == applicationId ? updatedApp : app)
        .toList();
    state = state.copyWith(applications: updated);
  }
}
