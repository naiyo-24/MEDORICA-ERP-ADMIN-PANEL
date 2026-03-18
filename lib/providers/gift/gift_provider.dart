import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/gift/gift.dart';
import '../../notifiers/gift/gift_notifier.dart';

final giftNotifierProvider = NotifierProvider<GiftNotifier, GiftState>(
  GiftNotifier.new,
);

final giftListProvider = Provider<List<Gift>>((ref) {
  return ref.watch(giftNotifierProvider).gifts;
});

final giftCountProvider = Provider<int>((ref) {
  return ref.watch(giftListProvider).length;
});

final giftLoadingProvider = Provider<bool>((ref) {
  return ref.watch(giftNotifierProvider).isLoading;
});

final giftErrorProvider = Provider<String?>((ref) {
  return ref.watch(giftNotifierProvider).error;
});
