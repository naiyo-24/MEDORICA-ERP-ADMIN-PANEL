import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chemist_shop/mr_chemist_shop.dart';
import '../notifiers/mr_chemist_shop_notifier.dart';

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
