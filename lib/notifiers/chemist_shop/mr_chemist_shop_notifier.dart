import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/onboarding/mr.dart';
import '../../models/chemist_shop/mr_chemist_shop.dart';
import '../../models/doctor_network/mr_doctor_network.dart';
import '../../providers/doctor_network/mr_doctor_network_provider.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';

class MRChemistShopState {
  const MRChemistShopState({
    this.shops = const [],
    this.searchQuery = '',
    this.selectedMRId = '',
    this.selectedLocation = 'All Locations',
  });

  final List<MRChemistShop> shops;
  final String searchQuery;
  final String selectedMRId;
  final String selectedLocation;

  MRChemistShopState copyWith({
    List<MRChemistShop>? shops,
    String? searchQuery,
    String? selectedMRId,
    String? selectedLocation,
  }) {
    return MRChemistShopState(
      shops: shops ?? this.shops,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }

  List<MRChemistShop> get filteredShops {
    final query = searchQuery.trim().toLowerCase();

    return shops.where((shop) {
      final matchesMR =
          selectedMRId.isEmpty || shop.mrAddedById == selectedMRId;
      final matchesLocation =
          selectedLocation == 'All Locations' ||
          shop.location == selectedLocation;
      final matchesSearch =
          query.isEmpty ||
          shop.shopName.toLowerCase().contains(query) ||
          shop.shopPhone.contains(query) ||
          shop.shopEmail.toLowerCase().contains(query) ||
          shop.description.toLowerCase().contains(query) ||
          shop.doctorName.toLowerCase().contains(query);

      return matchesMR && matchesLocation && matchesSearch;
    }).toList();
  }

  List<String> get locations {
    final values = shops.map((e) => e.location).toSet().toList()..sort();
    return ['All Locations', ...values];
  }
}

class MRChemistShopNotifier extends Notifier<MRChemistShopState> {
  @override
  MRChemistShopState build() {
    final mrList = ref.watch(mrOnboardingNotifierProvider).mrList;
    final doctorList = ref.watch(mrDoctorNetworkNotifierProvider).doctorList;

    return MRChemistShopState(
      shops: _mockShops(mrList: mrList, doctorList: doctorList),
    );
  }

  List<MRChemistShop> _mockShops({
    required List<MR> mrList,
    required List<MRDoctorNetwork> doctorList,
  }) {
    if (mrList.isEmpty) {
      return const [];
    }

    final fallbackDoctor = doctorList.isNotEmpty ? doctorList.first : null;
    final fallbackDoctorName = fallbackDoctor?.doctorName ?? 'Dr. Sunil Roy';
    final fallbackDoctorPhone = fallbackDoctor?.phoneNo ?? '+919800000001';

    final created = DateTime.now();

    return [
      for (var i = 0; i < mrList.length; i++)
        MRChemistShop(
          id: 'MR-SHOP-${i + 101}',
          shopPhoto:
              'https://via.placeholder.com/640x420.png?text=MR+Chemist+Shop+${i + 1}',
          shopName: 'WellCare Pharmacy ${i + 1}',
          shopPhone: '+91970000000${i + 1}',
          shopEmail: 'wellcare${i + 1}@medorica.com',
          location: i % 2 == 0 ? 'Kolkata' : 'Mumbai',
          description:
              'Established retail chemist partner serving nearby clinics and walk-in patients.',
          doctorName: doctorList.length > i
              ? doctorList[i].doctorName
              : fallbackDoctorName,
          doctorPhone: doctorList.length > i
              ? doctorList[i].phoneNo
              : fallbackDoctorPhone,
          mrAddedBy: mrList[i].name,
          mrAddedById: mrList[i].mrId,
          createdAt: created.subtract(Duration(days: 20 - i * 2)),
        ),
    ];
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedMRId(String value) {
    state = state.copyWith(selectedMRId: value);
  }

  void setSelectedLocation(String value) {
    state = state.copyWith(selectedLocation: value);
  }
}
