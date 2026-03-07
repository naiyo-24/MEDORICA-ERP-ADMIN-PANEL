import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm_doctor_network.dart';

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
          .where((doctor) =>
              doctor.doctorName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doctor.phone.contains(searchQuery) ||
              doctor.email.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedASM.isNotEmpty && selectedASM != 'All ASMs') {
      filtered = filtered.where((doctor) => doctor.asmAddedBy == selectedASM).toList();
    }

    if (selectedDepartment.isNotEmpty && selectedDepartment != 'All Departments') {
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
    final departments = doctorList.map((d) => d.specialization).toSet().toList();
    departments.sort();
    return ['All Departments', ...departments];
  }
}

class ASMDoctorNetworkNotifier extends Notifier<ASMDoctorNetworkState> {
  @override
  ASMDoctorNetworkState build() {
    return ASMDoctorNetworkState(
      doctorList: _mockDoctorData(),
    );
  }

  List<ASMDoctorNetwork> _mockDoctorData() {
    return [
      ASMDoctorNetwork(
        id: 'doc_asm_1',
        doctorName: 'Dr. Sanjay Mehta',
        phone: '+919876543215',
        email: 'sanjay.mehta@hospital.com',
        address: '888 Medical Tower, Delhi',
        specialization: 'Neurology',
        experience: 20.0,
        qualification: 'MD (Medicine), DM (Neurology)',
        description: 'Senior neurologist with expertise in stroke management and neurodegenerative diseases.',
        chambers: [
          const Chamber(
            name: 'Fortis Escorts',
            address: 'Okhla, Delhi',
            phone: '+911123456791',
          ),
          const Chamber(
            name: 'Indraprastha Apollo',
            address: 'Sarita Vihar, Delhi',
            phone: '+911123456792',
          ),
        ],
        asmAddedBy: 'Vikram Singh',
        asmAddedById: 'asm_1',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      ASMDoctorNetwork(
        id: 'doc_asm_2',
        doctorName: 'Dr. Kavita Rao',
        phone: '+919876543216',
        email: 'kavita.rao@hospital.com',
        address: '999 Health Complex, Bangalore',
        specialization: 'Oncology',
        experience: 16.0,
        qualification: 'MD (Medicine), DM (Medical Oncology)',
        description: 'Oncologist specializing in breast cancer and targeted therapy.',
        chambers: [
          const Chamber(
            name: 'HCG Cancer Centre',
            address: 'Kalyan Nagar, Bangalore',
            phone: '+918023456791',
          ),
        ],
        asmAddedBy: 'Neha Gupta',
        asmAddedById: 'asm_2',
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      ASMDoctorNetwork(
        id: 'doc_asm_3',
        doctorName: 'Dr. Ramesh Kumar',
        phone: '+919876543217',
        email: 'ramesh.kumar@hospital.com',
        address: '777 Clinic Lane, Hyderabad',
        specialization: 'Nephrology',
        experience: 14.0,
        qualification: 'MD (Medicine), DM (Nephrology)',
        description: 'Nephrologist with focus on kidney transplantation and dialysis.',
        chambers: [
          const Chamber(
            name: 'Yashoda Hospital',
            address: 'Malakpet, Hyderabad',
            phone: '+914023456791',
          ),
          const Chamber(
            name: 'Apollo Health City',
            address: 'Jubilee Hills, Hyderabad',
            phone: '+914023456792',
          ),
        ],
        asmAddedBy: 'Arun Kumar',
        asmAddedById: 'asm_3',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
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
    
    final newDoctorList = state.doctorList.where((d) => d.id != doctorId).toList();
    state = state.copyWith(doctorList: newDoctorList, isSaving: false);
  }
}
