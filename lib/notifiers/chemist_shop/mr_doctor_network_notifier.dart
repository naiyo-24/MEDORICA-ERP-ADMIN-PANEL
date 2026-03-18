import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/doctor_network/mr_doctor_network.dart';
import '../../providers/doctor_network/mr_doctor_network_provider.dart';

class MRDoctorNetworkState {
  const MRDoctorNetworkState({
    this.doctorList = const [],
    this.searchQuery = '',
    this.selectedMR = '',
    this.selectedDepartment = '',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<MRDoctorNetwork> doctorList;
  final String searchQuery;
  final String selectedMR;
  final String selectedDepartment;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  MRDoctorNetworkState copyWith({
    List<MRDoctorNetwork>? doctorList,
    String? searchQuery,
    String? selectedMR,
    String? selectedDepartment,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return MRDoctorNetworkState(
      doctorList: doctorList ?? this.doctorList,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMR: selectedMR ?? this.selectedMR,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  List<MRDoctorNetwork> get filteredDoctorList {
    var filtered = doctorList;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (doctor) =>
                doctor.doctorName.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                doctor.phoneNo.contains(searchQuery) ||
                (doctor.email?.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }

    if (selectedMR.isNotEmpty && selectedMR != 'All MRs') {
      filtered = filtered.where((doctor) => doctor.mrId == selectedMR).toList();
    }

    if (selectedDepartment.isNotEmpty &&
        selectedDepartment != 'All Departments') {
      filtered = filtered
          .where((doctor) => doctor.specialization == selectedDepartment)
          .toList();
    }

    return filtered;
  }

  List<String> get uniqueMRs {
    final mrs = doctorList.map((d) => d.mrId).toSet().toList();
    mrs.sort();
    return ['All MRs', ...mrs];
  }

  List<String> get uniqueDepartments {
    final departments = doctorList
        .map((d) => d.specialization)
        .toSet()
        .toList();
    departments.sort();
    return ['All Departments', ...departments];
  }
}

class MRDoctorNetworkNotifier extends Notifier<MRDoctorNetworkState> {
  @override
  MRDoctorNetworkState build() {
    return const MRDoctorNetworkState();
  }

  Future<void> loadAllDoctors() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final services = ref.read(mrDoctorNetworkServicesProvider);
      final doctors = await services.getAllDoctors();
      state = state.copyWith(doctorList: doctors, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load doctors: $e',
      );
    }
  }

  Future<void> loadDoctorsByMrId(String mrId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final services = ref.read(mrDoctorNetworkServicesProvider);
      final doctors = await services.getAllDoctorsByMrId(mrId);
      state = state.copyWith(doctorList: doctors, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load doctors for MR: $e',
      );
    }
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedMR(String value) {
    state = state.copyWith(selectedMR: value);
  }

  void setSelectedDepartment(String value) {
    state = state.copyWith(selectedDepartment: value);
  }
}
