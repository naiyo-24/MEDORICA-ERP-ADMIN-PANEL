import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/asm.dart';
import '../services/onboarding/asm_onboarding_services.dart';

class ASMOnboardingState {
  const ASMOnboardingState({
    this.asmList = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<ASM> asmList;
  final String searchQuery;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  ASMOnboardingState copyWith({
    List<ASM>? asmList,
    String? searchQuery,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return ASMOnboardingState(
      asmList: asmList ?? this.asmList,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
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
              (asm.email?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false),
        )
        .toList();
  }
}

class ASMOnboardingNotifier extends Notifier<ASMOnboardingState> {
  late final ASMOnboardingServices _services;

  @override
  ASMOnboardingState build() {
    _services = ref.read(asmOnboardingServicesProvider);
    return const ASMOnboardingState();
  }

  Future<void> loadASMList() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final asmList = await _services.getAllASM();
      state = state.copyWith(asmList: asmList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load ASM list: $e',
      );
    }
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  Future<void> addASM({required ASM asm}) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final newASM = await _services.createASM(
        asm: asm,
        profilePhotoBytes: asm.photoBytes,
        profilePhotoFileName: asm.photoFileName,
      );

      final newASMList = [...state.asmList, newASM];
      state = state.copyWith(asmList: newASMList, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create ASM: $e',
      );
      rethrow;
    }
  }

  Future<void> updateASM({required ASM asm}) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedASM = await _services.updateASM(
        asmId: asm.asmId,
        asm: asm,
        profilePhotoBytes: asm.photoBytes,
        profilePhotoFileName: asm.photoFileName,
      );

      final newASMList = state.asmList
          .map((a) => a.asmId == updatedASM.asmId ? updatedASM : a)
          .toList();
      state = state.copyWith(asmList: newASMList, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update ASM: $e',
      );
      rethrow;
    }
  }

  Future<void> deleteASM({required String asmId}) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _services.deleteASM(asmId);

      final newASMList = state.asmList.where((a) => a.asmId != asmId).toList();
      state = state.copyWith(asmList: newASMList, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete ASM: $e',
      );
      rethrow;
    }
  }
}

// Provider for ASM onboarding services
final asmOnboardingServicesProvider = Provider<ASMOnboardingServices>((ref) {
  return ASMOnboardingServices();
});
