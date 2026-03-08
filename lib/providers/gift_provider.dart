import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gift.dart';
import '../notifiers/gift_notifier.dart';

final giftNotifierProvider = NotifierProvider<GiftNotifier, GiftState>(
  GiftNotifier.new,
);

final giftListProvider = Provider<List<Gift>>((ref) {
  return ref.watch(giftNotifierProvider).gifts;
});

final giftCountProvider = Provider<int>((ref) {
  return ref.watch(giftListProvider).length;
});
