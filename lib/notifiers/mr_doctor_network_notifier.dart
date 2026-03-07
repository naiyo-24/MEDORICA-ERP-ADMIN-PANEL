import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_doctor_network.dart';

class MRDoctorNetworkState {
  const MRDoctorNetworkState({
    this.doctorList = const [],
    this.searchQuery = '',
    this.selectedMR = '',
    this.selectedDepartment = '',
    this.isSaving = false,
  });

  final List<MRDoctorNetwork> doctorList;
  final String searchQuery;
  final String selectedMR;
  final String selectedDepartment;
  final bool isSaving;

  MRDoctorNetworkState copyWith({
    List<MRDoctorNetwork>? doctorList,
    String? searchQuery,
    String? selectedMR,
    String? selectedDepartment,
    bool? isSaving,
  }) {
    return MRDoctorNetworkState(
      doctorList: doctorList ?? this.doctorList,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMR: selectedMR ?? this.selectedMR,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  List<MRDoctorNetwork> get filteredDoctorList {
    var filtered = doctorList;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((doctor) =>
              doctor.doctorName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              doctor.phone.contains(searchQuery) ||
              doctor.email.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    if (selectedMR.isNotEmpty && selectedMR != 'All MRs') {
      filtered = filtered.where((doctor) => doctor.mrAddedBy == selectedMR).toList();
    }

    if (selectedDepartment.isNotEmpty && selectedDepartment != 'All Departments') {
      filtered = filtered
          .where((doctor) => doctor.specialization == selectedDepartment)
          .toList();
    }

    return filtered;
  }

  List<String> get uniqueMRs {
    final mrs = doctorList.map((d) => d.mrAddedBy).toSet().toList();
    mrs.sort();
    return ['All MRs', ...mrs];
  }

  List<String> get uniqueDepartments {
    final departments = doctorList.map((d) => d.specialization).toSet().toList();
    departments.sort();
    return ['All Departments', ...departments];
  }
}

class MRDoctorNetworkNotifier extends Notifier<MRDoctorNetworkState> {
  @override
  MRDoctorNetworkState build() {
    return MRDoctorNetworkState(
      doctorList: _mockDoctorData(),
    );
  }

  List<MRDoctorNetwork> _mockDoctorData() {
    return [
      MRDoctorNetwork(
        id: 'doc_1',
        doctorName: 'Dr. Rajesh Kumar',
        phone: '+919876543210',
        email: 'rajesh.kumar@hospital.com',
        address: '123 Medical Plaza, Delhi',
        specialization: 'Cardiology',
        experience: 15.0,
        qualification: 'MD (Medicine), DM (Cardiology)',
        description: 'Experienced cardiologist specializing in interventional cardiology and heart failure management.',
        chambers: [
          const Chamber(
            name: 'Apollo Hospital',
            address: 'Sector 10, Delhi',
            phone: '+911123456789',
          ),
          const Chamber(
            name: 'Max Healthcare',
            address: 'Saket, Delhi',
            phone: '+911123456790',
          ),
        ],
        mrAddedBy: 'Rajesh Kumar',
        mrAddedById: 'mr_1',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      MRDoctorNetwork(
        id: 'doc_2',
        doctorName: 'Dr. Priya Sharma',
        phone: '+919876543211',
        email: 'priya.sharma@hospital.com',
        address: '456 Health Center, Mumbai',
        specialization: 'Dermatology',
        experience: 10.0,
        qualification: 'MBBS, MD (Dermatology)',
        description: 'Dermatologist with expertise in cosmetic procedures and skin disorders.',
        chambers: [
          const Chamber(
            name: 'Fortis Hospital',
            address: 'Andheri, Mumbai',
            phone: '+912223456789',
          ),
        ],
        mrAddedBy: 'Priya Sharma',
        mrAddedById: 'mr_2',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      MRDoctorNetwork(
        id: 'doc_3',
        doctorName: 'Dr. Amit Patel',
        phone: '+919876543212',
        email: 'amit.patel@hospital.com',
        address: '789 Medical Complex, Ahmedabad',
        specialization: 'Orthopedics',
        experience: 12.0,
        qualification: 'MBBS, MS (Orthopedics)',
        description: 'Orthopedic surgeon specializing in joint replacement and sports injuries.',
        chambers: [
          const Chamber(
            name: 'Sterling Hospital',
            address: 'Gurukul, Ahmedabad',
            phone: '+917923456789',
          ),
          const Chamber(
            name: 'Zydus Hospital',
            address: 'Thaltej, Ahmedabad',
            phone: '+917923456790',
          ),
        ],
        mrAddedBy: 'Amit Patel',
        mrAddedById: 'mr_3',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      MRDoctorNetwork(
        id: 'doc_4',
        doctorName: 'Dr. Anita Desai',
        phone: '+919876543213',
        email: 'anita.desai@hospital.com',
        address: '321 Clinic Road, Bangalore',
        specialization: 'Pediatrics',
        experience: 8.0,
        qualification: 'MBBS, MD (Pediatrics)',
        description: 'Pediatrician with focus on child development and preventive care.',
        chambers: [
          const Chamber(
            name: 'Manipal Hospital',
            address: 'HAL Airport Road, Bangalore',
            phone: '+918023456789',
          ),
        ],
        mrAddedBy: 'Rajesh Kumar',
        mrAddedById: 'mr_1',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      MRDoctorNetwork(
        id: 'doc_5',
        doctorName: 'Dr. Suresh Reddy',
        phone: '+919876543214',
        email: 'suresh.reddy@hospital.com',
        address: '654 Medical Street, Hyderabad',
        specialization: 'Cardiology',
        experience: 18.0,
        qualification: 'MD (Medicine), DM (Cardiology), FACC',
        description: 'Senior cardiologist with extensive experience in cardiac interventions.',
        chambers: [
          const Chamber(
            name: 'CARE Hospital',
            address: 'Banjara Hills, Hyderabad',
            phone: '+914023456789',
          ),
        ],
        mrAddedBy: 'Priya Sharma',
        mrAddedById: 'mr_2',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
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

  Future<void> addDoctor({required MRDoctorNetwork doctor}) async {
    state = state.copyWith(isSaving: true);
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newDoctorList = [...state.doctorList, doctor];
    state = state.copyWith(doctorList: newDoctorList, isSaving: false);
  }

  Future<void> updateDoctor({required MRDoctorNetwork doctor}) async {
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
