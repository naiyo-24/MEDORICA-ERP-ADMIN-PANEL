import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';

class ASMOnboardingState {
  const ASMOnboardingState({
    this.asmList = const [],
    this.searchQuery = '',
    this.isSaving = false,
  });

  final List<ASM> asmList;
  final String searchQuery;
  final bool isSaving;

  ASMOnboardingState copyWith({
    List<ASM>? asmList,
    String? searchQuery,
    bool? isSaving,
  }) {
    return ASMOnboardingState(
      asmList: asmList ?? this.asmList,
      searchQuery: searchQuery ?? this.searchQuery,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  List<ASM> get filteredASMList {
    if (searchQuery.isEmpty) {
      return asmList;
    }
    return asmList
        .where(
          (asm) =>
              asm.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              asm.phone.contains(searchQuery) ||
              asm.email.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }
}

class ASMOnboardingNotifier extends Notifier<ASMOnboardingState> {
  @override
  ASMOnboardingState build() {
    return ASMOnboardingState(asmList: _mockASMData());
  }

  List<ASM> _mockASMData() {
    return [
      ASM(
        id: 'asm_1',
        name: 'Vikram Singh',
        phone: '+919123456789',
        altPhone: '+919123456788',
        email: 'vikram.singh@medorica.com',
        address: '789 Corporate Plaza, Delhi, India',
        headquarterAssigned: 'Delhi HQ',
        territoriesOfWork: 'East Delhi, North Delhi, Central Delhi',
        bankName: 'Punjab National Bank',
        bankBranchName: 'Delhi Main Branch',
        bankAccountNumber: '54321098765432',
        ifscCode: 'PNB0001234',
        monthlyTarget: 150000,
        password: 'SecurePass@ASM1',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
      ASM(
        id: 'asm_2',
        name: 'Neha Gupta',
        phone: '+919234567890',
        altPhone: '+919234567891',
        email: 'neha.gupta@medorica.com',
        address: '456 Business Center, Bangalore, Karnataka',
        headquarterAssigned: 'Bangalore HQ',
        territoriesOfWork: 'Bangalore City, Suburbs',
        bankName: 'Axis Bank',
        bankBranchName: 'Bangalore Tech Park',
        bankAccountNumber: '65432109876543',
        ifscCode: 'AXIS0000789',
        monthlyTarget: 180000,
        password: 'SecurePass@ASM2',
        createdAt: DateTime.now().subtract(const Duration(days: 70)),
      ),
      ASM(
        id: 'asm_3',
        name: 'Arun Kumar',
        phone: '+919345678901',
        altPhone: '+919345678902',
        email: 'arun.kumar@medorica.com',
        address: '321 Medical Square, Hyderabad, Telangana',
        headquarterAssigned: 'Hyderabad HQ',
        territoriesOfWork: 'Hyderabad Urban, Hyderabad Rural',
        bankName: 'IDBI Bank',
        bankBranchName: 'Hyderabad Central',
        bankAccountNumber: '76543210987654',
        ifscCode: 'IDBI0001111',
        monthlyTarget: 160000,
        password: 'SecurePass@ASM3',
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
      ),
    ];
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  Future<void> addASM({required ASM asm}) async {
    state = state.copyWith(isSaving: true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final newASMList = [...state.asmList, asm];
    state = state.copyWith(asmList: newASMList, isSaving: false);
  }

  Future<void> updateASM({required ASM asm}) async {
    state = state.copyWith(isSaving: true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final newASMList = state.asmList
        .map((a) => a.id == asm.id ? asm : a)
        .toList();
    state = state.copyWith(asmList: newASMList, isSaving: false);
  }

  Future<void> deleteASM({required String asmId}) async {
    state = state.copyWith(isSaving: true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final newASMList = state.asmList.where((a) => a.id != asmId).toList();
    state = state.copyWith(asmList: newASMList, isSaving: false);
  }
}
