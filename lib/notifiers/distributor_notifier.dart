import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/distributor.dart';

class DistributorState {
  const DistributorState({
    this.distributors = const [],
    this.searchQuery = '',
    this.selectedState = 'All States',
    this.isSaving = false,
  });

  final List<Distributor> distributors;
  final String searchQuery;
  final String selectedState;
  final bool isSaving;

  DistributorState copyWith({
    List<Distributor>? distributors,
    String? searchQuery,
    String? selectedState,
    bool? isSaving,
  }) {
    return DistributorState(
      distributors: distributors ?? this.distributors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedState: selectedState ?? this.selectedState,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class DistributorNotifier extends Notifier<DistributorState> {
  @override
  DistributorState build() {
    return DistributorState(
      distributors: [
        Distributor(
          id: 'dist_1',
          name: 'Astra Medisupply',
          city: 'Kolkata',
          state: 'West Bengal',
          address: '2nd Floor, Park Street Trade Tower',
          email: 'contact@astramedisupply.com',
          phone: '+919830001122',
          expectedDeliveryTime: '24-36 hours',
          minimumOrderValue: 5000,
          createdAt: DateTime.now().subtract(const Duration(days: 150)),
        ),
        Distributor(
          id: 'dist_2',
          name: 'HealthBridge Distribution Co.',
          city: 'Bhubaneswar',
          state: 'Odisha',
          address: 'Unit 6, Janpath Commercial Complex',
          email: 'ops@healthbridge.in',
          phone: '+919876543210',
          expectedDeliveryTime: '48 hours',
          minimumOrderValue: 7000,
          createdAt: DateTime.now().subtract(const Duration(days: 96)),
        ),
        Distributor(
          id: 'dist_3',
          name: 'NorthStar Pharma Logistics',
          city: 'Guwahati',
          state: 'Assam',
          address: 'GS Road, Ambari Business Hub',
          email: 'info@northstarpharma.in',
          phone: '+919954441100',
          expectedDeliveryTime: '36-48 hours',
          minimumOrderValue: 6500,
          createdAt: DateTime.now().subtract(const Duration(days: 68)),
        ),
        Distributor(
          id: 'dist_4',
          name: 'Sanjeevani Medline',
          city: 'Patna',
          state: 'Bihar',
          address: 'Boring Road, Medico Trade Plaza',
          email: 'hello@sanjeevanimedline.in',
          phone: '+919888117700',
          expectedDeliveryTime: '24 hours',
          minimumOrderValue: 4500,
          createdAt: DateTime.now().subtract(const Duration(days: 31)),
        ),
      ],
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setStateFilter(String value) {
    state = state.copyWith(selectedState: value);
  }

  Future<void> createDistributor({
    required String name,
    required String city,
    required String stateName,
    required String address,
    required String email,
    required String phone,
    required String expectedDeliveryTime,
    required double minimumOrderValue,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    state = state.copyWith(isSaving: true);

    final now = DateTime.now();
    final distributor = Distributor(
      id: 'dist_${now.microsecondsSinceEpoch}',
      name: name,
      city: city,
      state: stateName,
      address: address,
      email: email,
      phone: phone,
      expectedDeliveryTime: expectedDeliveryTime,
      minimumOrderValue: minimumOrderValue,
      imageBytes: imageBytes,
      imageFileName: imageFileName,
      createdAt: now,
    );

    state = state.copyWith(
      isSaving: false,
      distributors: [distributor, ...state.distributors],
    );
  }

  Future<void> updateDistributor({
    required String id,
    required String name,
    required String city,
    required String stateName,
    required String address,
    required String email,
    required String phone,
    required String expectedDeliveryTime,
    required double minimumOrderValue,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    state = state.copyWith(isSaving: true);

    final updated = state.distributors
        .map((item) {
          if (item.id != id) {
            return item;
          }

          return item.copyWith(
            name: name,
            city: city,
            state: stateName,
            address: address,
            email: email,
            phone: phone,
            expectedDeliveryTime: expectedDeliveryTime,
            minimumOrderValue: minimumOrderValue,
            imageBytes: imageBytes,
            imageFileName: imageFileName,
          );
        })
        .toList(growable: false);

    state = state.copyWith(isSaving: false, distributors: updated);
  }

  void deleteDistributor(String id) {
    state = state.copyWith(
      distributors: state.distributors
          .where((item) => item.id != id)
          .toList(growable: false),
    );
  }
}
