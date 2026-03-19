import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chemist_shop/asm_chemist_shop.dart';
import '../../services/chemist_shop/asm_chemist_shop_services.dart'; // Fixed import line


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
  late final ASMChemistShopServices _services;

  @override
  ASMChemistShopState build() {
    _services = ASMChemistShopServices();
    return const ASMChemistShopState();
  }

  Future<void> loadShopList({String? asmId}) async {
    List<ASMChemistShop> shops = [];
    if (asmId != null && asmId.isNotEmpty) {
      shops = await _services.getASMShopsByAsmId(asmId);
    } else {
      shops = await _services.getAllASMShops();
    }
    state = state.copyWith(shops: shops);
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
