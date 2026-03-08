import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm_chemist_shop.dart';
import '../notifiers/asm_chemist_shop_notifier.dart';

final asmChemistShopNotifierProvider =
    NotifierProvider<ASMChemistShopNotifier, ASMChemistShopState>(
      ASMChemistShopNotifier.new,
    );

final asmChemistShopListProvider = Provider<List<ASMChemistShop>>((ref) {
  return ref.watch(asmChemistShopNotifierProvider).filteredShops;
});

final asmChemistShopCountProvider = Provider<int>((ref) {
  return ref.watch(asmChemistShopListProvider).length;
});

final asmChemistLocationsProvider = Provider<List<String>>((ref) {
  return ref.watch(asmChemistShopNotifierProvider).locations;
});
