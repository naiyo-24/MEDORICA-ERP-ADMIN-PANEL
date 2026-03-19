import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/order/mr_order.dart';
import '../../services/order/mr_order_services.dart';


class MROrderState {
  const MROrderState({
    this.orders = const [],
    this.searchQuery = '',
    this.selectedMRId = '',
    this.selectedDate,
    this.selectedStatus = '',
  });

  final List<MROrder> orders;
  final String searchQuery;
  final String selectedMRId;
  final DateTime? selectedDate;
  final String selectedStatus;

  MROrderState copyWith({
    List<MROrder>? orders,
    String? searchQuery,
    String? selectedMRId,
    DateTime? selectedDate,
    String? selectedStatus,
    bool clearSelectedDate = false,
  }) {
    return MROrderState(
      orders: orders ?? this.orders,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedDate: clearSelectedDate
          ? null
          : selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  List<MROrder> get filteredOrders {
    final query = searchQuery.trim().toLowerCase();

    return orders.where((order) {
      final matchesSearch =
          query.isEmpty || order.id.toLowerCase().contains(query);
      final matchesMR = selectedMRId.isEmpty || order.mrId == selectedMRId;
      final matchesDate = selectedDate == null
          ? true
          : _isSameDate(order.orderDate, selectedDate!);
      final matchesStatus =
          selectedStatus.isEmpty || order.status.name == selectedStatus;

      return matchesSearch && matchesMR && matchesDate && matchesStatus;
    }).toList()..sort((a, b) => b.orderDate.compareTo(a.orderDate));
  }

  static bool _isSameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}

class MROrderNotifier extends Notifier<MROrderState> {
  late final MROrderServices _services;

  @override
  MROrderState build() {
    _services = MROrderServices();
    return const MROrderState();
  }

  Future<void> loadOrders({String? mrId}) async {
    state = state.copyWith(searchQuery: '', selectedMRId: mrId ?? '', selectedStatus: '', selectedDate: null);
    List<MROrder> orders = [];
    if (mrId != null && mrId.isNotEmpty) {
      orders = await _services.getOrdersByMR(mrId);
    } else {
      orders = await _services.getAllMROrders();
    }
    state = state.copyWith(orders: orders);
  }


  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
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
