import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_order.dart';
import '../notifiers/mr_order_notifier.dart';

final mrOrderNotifierProvider = NotifierProvider<MROrderNotifier, MROrderState>(
  MROrderNotifier.new,
);

final mrOrderListProvider = Provider<List<MROrder>>((ref) {
  return ref.watch(mrOrderNotifierProvider).filteredOrders;
});

final mrOrderCountProvider = Provider<int>((ref) {
  return ref.watch(mrOrderListProvider).length;
});

final selectedMROrderIdProvider = Provider<String>((ref) {
  return ref.watch(mrOrderNotifierProvider).selectedMRId;
});

final selectedMROrderDateProvider = Provider<DateTime?>((ref) {
  return ref.watch(mrOrderNotifierProvider).selectedDate;
});

final selectedMROrderStatusProvider = Provider<String>((ref) {
  return ref.watch(mrOrderNotifierProvider).selectedStatus;
});

final mrOrderSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(mrOrderNotifierProvider).searchQuery;
});
