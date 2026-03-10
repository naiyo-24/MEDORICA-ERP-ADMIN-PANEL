import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/distributor.dart';
import '../services/distributor/distributor_services.dart';

class DistributorState {
  const DistributorState({
    this.distributors = const [],
    this.searchQuery = '',
    this.selectedState = 'All States',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.hasLoadedOnce = false,
  });

  final List<Distributor> distributors;
  final String searchQuery;
  final String selectedState;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final bool hasLoadedOnce;

  DistributorState copyWith({
    List<Distributor>? distributors,
    String? searchQuery,
    String? selectedState,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool? hasLoadedOnce,
  }) {
    return DistributorState(
      distributors: distributors ?? this.distributors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedState: selectedState ?? this.selectedState,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
    );
  }
}

class DistributorNotifier extends Notifier<DistributorState> {
  late final DistributorService _service;

  @override
  DistributorState build() {
    _service = DistributorService();
    _loadDistributors();
    return const DistributorState();
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setStateFilter(String value) {
    state = state.copyWith(selectedState: value);
  }

  Future<void> _loadDistributors() async {
    if (state.hasLoadedOnce) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final distributors = await _service.getAllDistributors();
      state = state.copyWith(
        isLoading: false,
        distributors: distributors,
        hasLoadedOnce: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load distributors: $e',
        hasLoadedOnce: true,
      );
    }
  }

  Future<void> refreshDistributors() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final distributors = await _service.getAllDistributors();
      state = state.copyWith(
        isLoading: false,
        distributors: distributors,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to refresh distributors: $e',
      );
    }
  }

  Future<void> createDistributor({
    required String distName,
    required String distPhoneNo,
    required String distLocation,
    required String distProducts,
    required String paymentTerms,
    String? distEmail,
    String? distDescription,
    double? distMinOrderValueRupees,
    int? distExpectedDeliveryTimeDays,
    String? bankName,
    String? bankAcNo,
    String? branchName,
    String? ifscCode,
    String? deliveryTerritories,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final newDistributor = await _service.createDistributor(
        distName: distName,
        distPhoneNo: distPhoneNo,
        distLocation: distLocation,
        distProducts: distProducts,
        paymentTerms: paymentTerms,
        distEmail: distEmail,
        distDescription: distDescription,
        distMinOrderValueRupees: distMinOrderValueRupees,
        distExpectedDeliveryTimeDays: distExpectedDeliveryTimeDays,
        bankName: bankName,
        bankAcNo: bankAcNo,
        branchName: branchName,
        ifscCode: ifscCode,
        deliveryTerritories: deliveryTerritories,
        photoBytes: photoBytes,
        photoFileName: photoFileName,
      );

      state = state.copyWith(
        isSaving: false,
        distributors: [newDistributor, ...state.distributors],
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create distributor: $e',
      );
      rethrow;
    }
  }

  Future<void> updateDistributor({
    required String distId,
    required String distName,
    required String distPhoneNo,
    required String distLocation,
    String? distEmail,
    String? distDescription,
    double? distMinOrderValueRupees,
    String? distProducts,
    int? distExpectedDeliveryTimeDays,
    String? paymentTerms,
    String? bankName,
    String? bankAcNo,
    String? branchName,
    String? ifscCode,
    String? deliveryTerritories,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedDistributor = await _service.updateDistributor(
        distId: distId,
        distName: distName,
        distPhoneNo: distPhoneNo,
        distLocation: distLocation,
        distEmail: distEmail,
        distDescription: distDescription,
        distMinOrderValueRupees: distMinOrderValueRupees,
        distProducts: distProducts,
        distExpectedDeliveryTimeDays: distExpectedDeliveryTimeDays,
        paymentTerms: paymentTerms,
        bankName: bankName,
        bankAcNo: bankAcNo,
        branchName: branchName,
        ifscCode: ifscCode,
        deliveryTerritories: deliveryTerritories,
        photoBytes: photoBytes,
        photoFileName: photoFileName,
      );

      final updated = state.distributors
          .map((item) {
            if (item.distId != distId) {
              return item;
            }
            return updatedDistributor;
          })
          .toList(growable: false);

      state = state.copyWith(isSaving: false, distributors: updated);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update distributor: $e',
      );
      rethrow;
    }
  }

  Future<void> deleteDistributor(String distId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _service.deleteDistributor(distId);

      state = state.copyWith(
        isSaving: false,
        distributors: state.distributors
            .where((item) => item.distId != distId)
            .toList(growable: false),
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete distributor: $e',
      );
      rethrow;
    }
  }
}
