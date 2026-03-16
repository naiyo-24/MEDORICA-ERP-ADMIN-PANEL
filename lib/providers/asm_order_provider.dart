import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order/asm_order.dart';
import '../notifiers/asm_order_notifier.dart';

final asmOrderNotifierProvider =
    NotifierProvider<ASMOrderNotifier, ASMOrderState>(ASMOrderNotifier.new);

final asmOrderListProvider = Provider<List<ASMOrder>>((ref) {
  return ref.watch(asmOrderNotifierProvider).filteredOrders;
});

final asmOrderCountProvider = Provider<int>((ref) {
  return ref.watch(asmOrderListProvider).length;
});

final selectedASMOrderIdProvider = Provider<String>((ref) {
  return ref.watch(asmOrderNotifierProvider).selectedASMId;
});

final selectedASMOrderDateProvider = Provider<DateTime?>((ref) {
  return ref.watch(asmOrderNotifierProvider).selectedDate;
});

final selectedASMOrderStatusProvider = Provider<String>((ref) {
  return ref.watch(asmOrderNotifierProvider).selectedStatus;
});

final asmOrderSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(asmOrderNotifierProvider).searchQuery;
});

final asmOrderLoadingProvider = Provider<bool>((ref) {
  return ref.watch(asmOrderNotifierProvider).isLoading;
});

final asmOrderSavingProvider = Provider<bool>((ref) {
  return ref.watch(asmOrderNotifierProvider).isSaving;
});

final asmOrderErrorProvider = Provider<String?>((ref) {
  return ref.watch(asmOrderNotifierProvider).error;
});
