import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/gift/mr_gift_application.dart';
import '../../services/gift/mr_gift_application_services.dart';

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
  late final MRGiftApplicationServices _services;

  @override
  MRGiftApplicationState build() {
    _services = MRGiftApplicationServices();
    Future.microtask(loadApplications);
    return const MRGiftApplicationState();
  }

  Future<void> loadApplications({String? mrId}) async {
    List<MRGiftApplication> apps = [];
    if (mrId != null && mrId.isNotEmpty) {
      apps = await _services.getApplicationsByMR(mrId);
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

  void setSelectedMRId(String value) {
    state = state.copyWith(selectedMRId: value);
  }

  void setSelectedDoctorName(String value) {
    state = state.copyWith(selectedDoctorName: value);
  }

  Future<void> updateStatus({
    required String mrId,
    required String applicationId,
    required GiftApplicationStatus status,
  }) async {
    final updatedApp = await _services.updateApplicationStatus(
      mrId: mrId,
      requestId: int.parse(applicationId),
      status: status,
    );
    final updated = state.applications
        .map((app) => app.id == applicationId ? updatedApp : app)
        .toList();
    state = state.copyWith(applications: updated);
  }
}
