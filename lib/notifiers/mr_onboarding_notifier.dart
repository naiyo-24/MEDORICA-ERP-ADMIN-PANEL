import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/mr.dart';
import '../providers/mr_onboarding_provider.dart';

class MROnboardingState {
  const MROnboardingState({
    this.mrList = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<MR> mrList;
  final String searchQuery;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  MROnboardingState copyWith({
    List<MR>? mrList,
    String? searchQuery,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return MROnboardingState(
      mrList: mrList ?? this.mrList,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  List<MR> get filteredMRList {
    if (searchQuery.isEmpty) {
      return mrList;
    }
    return mrList
        .where(
          (mr) =>
              mr.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              mr.phone.contains(searchQuery) ||
              (mr.email?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                  false),
        )
        .toList();
  }
}

class MROnboardingNotifier extends Notifier<MROnboardingState> {
  @override
  MROnboardingState build() {
    return const MROnboardingState();
  }

  Future<void> loadMRList() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final services = ref.read(mrOnboardingServicesProvider);
      final mrList = await services.getAllMR();
      state = state.copyWith(mrList: mrList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load MR list: $e',
      );
    }
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  Future<void> addMR({required MR mr}) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final services = ref.read(mrOnboardingServicesProvider);
      final createdMR = await services.createMR(
        mr: mr,
        profilePhotoBytes: mr.photoBytes,
        profilePhotoFileName: mr.photoFileName,
      );

      final newMRList = [...state.mrList, createdMR];
      state = state.copyWith(mrList: newMRList, isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to add MR: $e');
      rethrow;
    }
  }

  Future<void> updateMR({required MR mr}) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final services = ref.read(mrOnboardingServicesProvider);
      final updatedMR = await services.updateMR(
        mrId: mr.mrId,
        mr: mr,
        profilePhotoBytes: mr.photoBytes,
        profilePhotoFileName: mr.photoFileName,
      );

      final newMRList = state.mrList
          .map((m) => m.mrId == updatedMR.mrId ? updatedMR : m)
          .toList();
      state = state.copyWith(mrList: newMRList, isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to update MR: $e');
      rethrow;
    }
  }

  Future<void> deleteMR({required String mrId}) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final services = ref.read(mrOnboardingServicesProvider);
      await services.deleteMR(mrId);

      final newMRList = state.mrList.where((m) => m.mrId != mrId).toList();
      state = state.copyWith(mrList: newMRList, isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to delete MR: $e');
      rethrow;
    }
  }
}
