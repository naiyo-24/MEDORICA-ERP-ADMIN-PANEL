import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr.dart';

class MROnboardingState {
  const MROnboardingState({
    this.mrList = const [],
    this.searchQuery = '',
    this.isSaving = false,
  });

  final List<MR> mrList;
  final String searchQuery;
  final bool isSaving;

  MROnboardingState copyWith({
    List<MR>? mrList,
    String? searchQuery,
    bool? isSaving,
  }) {
    return MROnboardingState(
      mrList: mrList ?? this.mrList,
      searchQuery: searchQuery ?? this.searchQuery,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  List<MR> get filteredMRList {
    if (searchQuery.isEmpty) {
      return mrList;
    }
    return mrList
        .where((mr) =>
            mr.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            mr.phone.contains(searchQuery) ||
            mr.email.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}

class MROnboardingNotifier extends Notifier<MROnboardingState> {
  @override
  MROnboardingState build() {
    return MROnboardingState(
      mrList: _mockMRData(),
    );
  }

  List<MR> _mockMRData() {
    return [
      MR(
        id: 'mr_1',
        name: 'Rajesh Kumar',
        phone: '+919876543210',
        altPhone: '+919876543211',
        email: 'rajesh.kumar@medorica.com',
        address: '123 Main Street, Kolkata, West Bengal',
        headquarterAssigned: 'Kolkata HQ',
        territoriesOfWork: 'North Kolkata, South Kolkata',
        bankName: 'State Bank of India',
        bankBranchName: 'Kolkata Main Branch',
        bankAccountNumber: '12345678901234',
        ifscCode: 'SBIN0001234',
        monthlyTarget: 50000,
        password: 'SecurePass@123',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      MR(
        id: 'mr_2',
        name: 'Priya Sharma',
        phone: '+919988776655',
        altPhone: '+919988776656',
        email: 'priya.sharma@medorica.com',
        address: '456 Park Avenue, Mumbai, Maharashtra',
        headquarterAssigned: 'Mumbai HQ',
        territoriesOfWork: 'Central Mumbai, South Mumbai',
        bankName: 'HDFC Bank',
        bankBranchName: 'Mumbai Fort Branch',
        bankAccountNumber: '98765432109876',
        ifscCode: 'HDFC0000123',
        monthlyTarget: 55000,
        password: 'SecurePass@456',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      MR(
        id: 'mr_3',
        name: 'Amit Patel',
        phone: '+919111222333',
        altPhone: '+919111222334',
        email: 'amit.patel@medorica.com',
        address: '789 Business Park, Bangalore, Karnataka',
        headquarterAssigned: 'Bangalore HQ',
        territoriesOfWork: 'Indiranagar, Whitefield',
        bankName: 'ICICI Bank',
        bankBranchName: 'Bangalore Tech Park',
        bankAccountNumber: '11223344556677',
        ifscCode: 'ICIC0000456',
        monthlyTarget: 60000,
        password: 'SecurePass@789',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ];
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  Future<void> addMR({required MR mr}) async {
    state = state.copyWith(isSaving: true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newMRList = [...state.mrList, mr];
    state = state.copyWith(mrList: newMRList, isSaving: false);
  }

  Future<void> updateMR({required MR mr}) async {
    state = state.copyWith(isSaving: true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newMRList = state.mrList.map((m) => m.id == mr.id ? mr : m).toList();
    state = state.copyWith(mrList: newMRList, isSaving: false);
  }

  Future<void> deleteMR({required String mrId}) async {
    state = state.copyWith(isSaving: true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newMRList = state.mrList.where((m) => m.id != mrId).toList();
    state = state.copyWith(mrList: newMRList, isSaving: false);
  }
}
