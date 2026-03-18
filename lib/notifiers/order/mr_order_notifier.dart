import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/distributor.dart';
import '../../models/onboarding/mr.dart';
import '../../models/chemist_shop/mr_chemist_shop.dart';
import '../../models/doctor_network/mr_doctor_network.dart';
import '../../models/order/mr_order.dart';
import '../../providers/distributor_provider.dart';
import '../../providers/chemist_shop/mr_chemist_shop_provider.dart';
import '../../providers/doctor_network/mr_doctor_network_provider.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';

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
  @override
  MROrderState build() {
    final mrList = ref.watch(mrOnboardingNotifierProvider).mrList;
    final doctorList = ref.watch(mrDoctorNetworkNotifierProvider).doctorList;
    final shops = ref.watch(mrChemistShopNotifierProvider).shops;
    final distributors = ref.watch(distributorNotifierProvider).distributors;

    return MROrderState(
      orders: _buildMockOrders(
        mrList: mrList,
        doctorList: doctorList,
        shops: shops,
        distributors: distributors,
      ),
    );
  }

  List<MROrder> _buildMockOrders({
    required List<MR> mrList,
    required List<MRDoctorNetwork> doctorList,
    required List<MRChemistShop> shops,
    required List<Distributor> distributors,
  }) {
    if (mrList.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final fallbackDoctor = doctorList.isNotEmpty
        ? doctorList.first.doctorName
        : 'Dr. Anirban Sen';
    final fallbackShop = shops.isNotEmpty
        ? shops.first.shopName
        : 'WellCare Pharmacy Central';
    final fallbackDistributor = distributors.isNotEmpty
        ? distributors.first.distName
        : 'Astra Medisupply';

    return [
      for (var i = 0; i < mrList.length; i++)
        MROrder(
          id: 'MR-ORD-${1001 + i}',
          orderDate: now.subtract(Duration(days: i * 2 + 1)),
          deliveryDateTime: now
              .subtract(Duration(days: i))
              .add(Duration(hours: 14 + (i % 4))),
          mrId: mrList[i].mrId,
          mrName: mrList[i].name,
          doctorName: doctorList.length > i
              ? doctorList[i].doctorName
              : fallbackDoctor,
          chemistShopName: shops.length > i ? shops[i].shopName : fallbackShop,
          distributorName: distributors.isNotEmpty
              ? distributors[i % distributors.length].distName
              : fallbackDistributor,
          status: MROrderStatus.values[i % MROrderStatus.values.length],
        ),
    ];
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
