import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/asm.dart';
import '../models/order/asm_order.dart';
import '../providers/onboarding/asm_onboarding_provider.dart';
import '../services/order/asm_order_services.dart';

class ASMOrderState {
  const ASMOrderState({
    this.orders = const [],
    this.searchQuery = '',
    this.selectedASMId = '',
    this.selectedDate,
    this.selectedStatus = '',
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<ASMOrder> orders;
  final String searchQuery;
  final String selectedASMId;
  final DateTime? selectedDate;
  final String selectedStatus;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  ASMOrderState copyWith({
    List<ASMOrder>? orders,
    String? searchQuery,
    String? selectedASMId,
    DateTime? selectedDate,
    String? selectedStatus,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearSelectedDate = false,
  }) {
    return ASMOrderState(
      orders: orders ?? this.orders,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  List<ASMOrder> get filteredOrders {
    final query = searchQuery.trim().toLowerCase();

    return orders.where((order) {
      final matchesSearch =
          query.isEmpty || order.id.toLowerCase().contains(query);
      final matchesASM = selectedASMId.isEmpty || order.asmId == selectedASMId;
      final matchesDate = selectedDate == null
          ? true
          : _isSameDate(order.orderDate, selectedDate!);
      final matchesStatus =
          selectedStatus.isEmpty || order.status.name == selectedStatus;

      return matchesSearch && matchesASM && matchesDate && matchesStatus;
    }).toList()..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  static bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class ASMOrderNotifier extends Notifier<ASMOrderState> {
  late final ASMOrderServices _services;

  @override
  ASMOrderState build() {
    _services = ref.read(asmOrderServicesProvider);
    return const ASMOrderState();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final asmNotifier = ref.read(asmOnboardingNotifierProvider.notifier);
      if (ref.read(asmOnboardingNotifierProvider).asmList.isEmpty) {
        await asmNotifier.loadASMList();
      }

      final asmList = ref.read(asmOnboardingNotifierProvider).asmList;
      final asmNameById = _asmNameByIdMap(asmList);

      final orders = await _services.getAllASMOrders(asmNameById: asmNameById);

      state = state.copyWith(orders: orders, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load ASM orders: $e',
      );
    }
  }

  Future<void> updateOrderStatus({
    required ASMOrder order,
    required ASMOrderStatus status,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedOrder = await _services.updateOrderStatus(
        orderId: order.id,
        status: status,
        asmName: order.asmName,
      );

      final updatedOrders = state.orders
          .map((item) => item.id == order.id ? updatedOrder : item)
          .toList(growable: false);

      state = state.copyWith(
        orders: updatedOrders,
        isSaving: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update order status: $e',
      );
      rethrow;
    }
  }

  Future<void> deleteOrderById(ASMOrder order) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _services.deleteOrderByOrderId(order.id);

      final updatedOrders = state.orders
          .where((item) => item.id != order.id)
          .toList(growable: false);

      state = state.copyWith(
        orders: updatedOrders,
        isSaving: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete order: $e',
      );
      rethrow;
    }
  }

  Map<String, String> _asmNameByIdMap(List<ASM> asmList) {
    final map = <String, String>{};
    for (final asm in asmList) {
      map[asm.asmId] = asm.name;
    }
    return map;
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedASM(String asmId) {
    state = state.copyWith(selectedASMId: asmId);
  }

  void setSelectedDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearSelectedDate: true);
      return;
    }
    state = state.copyWith(selectedDate: date);
  }

  void clearDateFilter() {
    state = state.copyWith(clearSelectedDate: true);
  }

  void setSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }
}
