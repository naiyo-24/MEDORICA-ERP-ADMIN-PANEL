import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chemist_shop/mr_chemist_shop.dart';
import '../../services/chemist_shop/mr_chemist_shop_services.dart';

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
  late final MRChemistShopServices _services;

  @override
  MRChemistShopState build() {
    _services = MRChemistShopServices();
    // Load initial shop list from backend
    _init();
    return const MRChemistShopState();
  }

  Future<void> _init() async {
    final shops = await _services.getAllShops();
    state = state.copyWith(shops: shops);
  }

  Future<void> loadShopList({String? mrId}) async {
    List<MRChemistShop> shops = [];
    if (mrId != null && mrId.isNotEmpty) {
      shops = await _services.getShopsByMR(mrId);
    } else {
      shops = await _services.getAllShops();
    }
    state = state.copyWith(shops: shops);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedMRId(String value) {
    state = state.copyWith(selectedMRId: value);
    loadShopList(mrId: value);
  }

  void setSelectedLocation(String value) {
    state = state.copyWith(selectedLocation: value);
  }
}
