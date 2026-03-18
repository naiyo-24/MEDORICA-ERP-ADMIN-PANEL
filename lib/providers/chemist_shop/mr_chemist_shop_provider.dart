import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chemist_shop/mr_chemist_shop.dart';
import '../../notifiers/chemist_shop/mr_chemist_shop_notifier.dart';
import '../../services/chemist_shop/mr_chemist_shop_services.dart';

final mrChemistShopServicesProvider = Provider<MRChemistShopServices>((ref) {
  return MRChemistShopServices();
});

final mrChemistShopNotifierProvider =
    NotifierProvider<MRChemistShopNotifier, MRChemistShopState>(
      MRChemistShopNotifier.new,
    );

final mrChemistShopListProvider = Provider<List<MRChemistShop>>((ref) {
  return ref.watch(mrChemistShopNotifierProvider).filteredShops;
});

final mrChemistShopCountProvider = Provider<int>((ref) {
  return ref.watch(mrChemistShopListProvider).length;
});

final mrChemistLocationsProvider = Provider<List<String>>((ref) {
  return ref.watch(mrChemistShopNotifierProvider).locations;
});
