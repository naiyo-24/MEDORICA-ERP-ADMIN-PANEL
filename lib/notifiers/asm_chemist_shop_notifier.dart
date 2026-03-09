import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../models/asm_chemist_shop.dart';
import '../models/asm_doctor_network.dart';
import '../providers/asm_doctor_network_provider.dart';
import '../providers/asm_onboarding_provider.dart';

class ASMChemistShopState {
  const ASMChemistShopState({
    this.shops = const [],
    this.searchQuery = '',
    this.selectedASMId = '',
    this.selectedLocation = 'All Locations',
  });

  final List<ASMChemistShop> shops;
  final String searchQuery;
  final String selectedASMId;
  final String selectedLocation;

  ASMChemistShopState copyWith({
    List<ASMChemistShop>? shops,
    String? searchQuery,
    String? selectedASMId,
    String? selectedLocation,
  }) {
    return ASMChemistShopState(
      shops: shops ?? this.shops,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }

  List<ASMChemistShop> get filteredShops {
    final query = searchQuery.trim().toLowerCase();

    return shops.where((shop) {
      final matchesASM =
          selectedASMId.isEmpty || shop.asmAddedById == selectedASMId;
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

      return matchesASM && matchesLocation && matchesSearch;
    }).toList();
  }

  List<String> get locations {
    final values = shops.map((e) => e.location).toSet().toList()..sort();
    return ['All Locations', ...values];
  }
}

class ASMChemistShopNotifier extends Notifier<ASMChemistShopState> {
  @override
  ASMChemistShopState build() {
    final asmList = ref.watch(asmOnboardingNotifierProvider).asmList;
    final doctorList = ref.watch(asmDoctorNetworkNotifierProvider).doctorList;

    return ASMChemistShopState(
      shops: _mockShops(asmList: asmList, doctorList: doctorList),
    );
  }

  List<ASMChemistShop> _mockShops({
    required List<ASM> asmList,
    required List<ASMDoctorNetwork> doctorList,
  }) {
    if (asmList.isEmpty) {
      return const [];
    }

    final fallbackDoctor = doctorList.isNotEmpty ? doctorList.first : null;
    final fallbackDoctorName = fallbackDoctor?.doctorName ?? 'Dr. A. Banerjee';
    final fallbackDoctorPhone = fallbackDoctor?.phone ?? '+919700000101';

    final created = DateTime.now();

    return [
      for (var i = 0; i < asmList.length; i++)
        ASMChemistShop(
          id: 'ASM-SHOP-${i + 101}',
          shopPhoto:
              'https://via.placeholder.com/640x420.png?text=ASM+Chemist+Shop+${i + 1}',
          shopName: 'MediLink Drug House ${i + 1}',
          shopPhone: '+91981000000${i + 1}',
          shopEmail: 'medilink${i + 1}@medorica.com',
          location: i % 2 == 0 ? 'Delhi' : 'Hyderabad',
          description:
              'Regional chemist outlet partnered for prescription fulfillment and stock visibility.',
          doctorName: doctorList.length > i
              ? doctorList[i].doctorName
              : fallbackDoctorName,
          doctorPhone: doctorList.length > i
              ? doctorList[i].phone
              : fallbackDoctorPhone,
          asmAddedBy: asmList[i].name,
          asmAddedById: asmList[i].asmId,
          createdAt: created.subtract(Duration(days: 16 - i * 2)),
        ),
    ];
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedASMId(String value) {
    state = state.copyWith(selectedASMId: value);
  }

  void setSelectedLocation(String value) {
    state = state.copyWith(selectedLocation: value);
  }
}
