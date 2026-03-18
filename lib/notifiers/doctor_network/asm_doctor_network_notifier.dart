import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/doctor_network/asm_doctor_network.dart';
import '../../services/doctor_network/asm/asm_doctor_network_services.dart';

class ASMDoctorNetworkState {
  const ASMDoctorNetworkState({
    this.doctorList = const [],
    this.searchQuery = '',
    this.selectedASM = '',
    this.selectedDepartment = '',
    this.isSaving = false,
  });

  final List<ASMDoctorNetwork> doctorList;
  final String searchQuery;
  final String selectedASM;
  final String selectedDepartment;
  final bool isSaving;

  ASMDoctorNetworkState copyWith({
    List<ASMDoctorNetwork>? doctorList,
    String? searchQuery,
    String? selectedASM,
    String? selectedDepartment,
    bool? isSaving,
  }) {
    return ASMDoctorNetworkState(
      doctorList: doctorList ?? this.doctorList,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedASM: selectedASM ?? this.selectedASM,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  List<ASMDoctorNetwork> get filteredDoctorList {
    var filtered = doctorList;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (doctor) =>
                doctor.doctorName.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                doctor.phone.contains(searchQuery) ||
                doctor.email.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (selectedASM.isNotEmpty && selectedASM != 'All ASMs') {
      filtered = filtered
          .where((doctor) => doctor.asmAddedBy == selectedASM)
          .toList();
    }

    if (selectedDepartment.isNotEmpty &&
        selectedDepartment != 'All Departments') {
      filtered = filtered
          .where((doctor) => doctor.specialization == selectedDepartment)
          .toList();
    }

    return filtered;
  }

  List<String> get uniqueASMs {
    final asms = doctorList.map((d) => d.asmAddedBy).toSet().toList();
    asms.sort();
    return ['All ASMs', ...asms];
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

class ASMDoctorNetworkNotifier extends Notifier<ASMDoctorNetworkState> {
  late final ASMDoctorNetworkServices _services;

  @override
  ASMDoctorNetworkState build() {
    _services = ASMDoctorNetworkServices();
    return const ASMDoctorNetworkState();
  }

  Future<void> loadDoctorList({String? asmId}) async {
    List<ASMDoctorNetwork> doctors = [];
    if (asmId != null && asmId.isNotEmpty && asmId != 'All ASMs') {
      doctors = await _services.getDoctorsByASM(asmId);
    } else {
      doctors = await _services.getAllDoctors();
    }
    state = state.copyWith(doctorList: doctors);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedASM(String value) {
    state = state.copyWith(selectedASM: value);
  }

  void setSelectedDepartment(String value) {
    state = state.copyWith(selectedDepartment: value);
  }

  Future<void> addDoctor({required ASMDoctorNetwork doctor}) async {
    state = state.copyWith(isSaving: true);

    await Future.delayed(const Duration(milliseconds: 800));

    final newDoctorList = [...state.doctorList, doctor];
    state = state.copyWith(doctorList: newDoctorList, isSaving: false);
  }

  Future<void> updateDoctor({required ASMDoctorNetwork doctor}) async {
    state = state.copyWith(isSaving: true);

    await Future.delayed(const Duration(milliseconds: 800));

    final newDoctorList = state.doctorList
        .map((d) => d.id == doctor.id ? doctor : d)
        .toList();
    state = state.copyWith(doctorList: newDoctorList, isSaving: false);
  }

  Future<void> deleteDoctor({required String doctorId}) async {
    state = state.copyWith(isSaving: true);

    await Future.delayed(const Duration(milliseconds: 800));

    final newDoctorList = state.doctorList
        .where((d) => d.id != doctorId)
        .toList();
    state = state.copyWith(doctorList: newDoctorList, isSaving: false);
  }
}
