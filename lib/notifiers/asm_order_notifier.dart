import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../models/asm_chemist_shop.dart';
import '../models/asm_doctor_network.dart';
import '../models/asm_order.dart';
import '../models/distributor.dart';
import '../providers/asm_chemist_shop_provider.dart';
import '../providers/asm_doctor_network_provider.dart';
import '../providers/asm_onboarding_provider.dart';
import '../providers/distributor_provider.dart';

class ASMOrderState {
  const ASMOrderState({
    this.orders = const [],
    this.searchQuery = '',
    this.selectedASMId = '',
    this.selectedDate,
    this.selectedStatus = '',
  });

  final List<ASMOrder> orders;
  final String searchQuery;
  final String selectedASMId;
  final DateTime? selectedDate;
  final String selectedStatus;

  ASMOrderState copyWith({
    List<ASMOrder>? orders,
    String? searchQuery,
    String? selectedASMId,
    DateTime? selectedDate,
    String? selectedStatus,
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
  @override
  ASMOrderState build() {
    final asmList = ref.watch(asmOnboardingNotifierProvider).asmList;
    final doctorList = ref.watch(asmDoctorNetworkNotifierProvider).doctorList;
    final shops = ref.watch(asmChemistShopNotifierProvider).shops;
    final distributors = ref.watch(distributorNotifierProvider).distributors;

    return ASMOrderState(
      orders: _buildMockOrders(
        asmList: asmList,
        doctorList: doctorList,
        shops: shops,
        distributors: distributors,
      ),
    );
  }

  List<ASMOrder> _buildMockOrders({
    required List<ASM> asmList,
    required List<ASMDoctorNetwork> doctorList,
    required List<ASMChemistShop> shops,
    required List<Distributor> distributors,
  }) {
    if (asmList.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final fallbackDoctor = doctorList.isNotEmpty
        ? doctorList.first.doctorName
        : 'Dr. Shalini Das';
    final fallbackShop = shops.isNotEmpty
        ? shops.first.shopName
        : 'MediLink Drug House Central';
    final fallbackDistributor = distributors.isNotEmpty
        ? distributors.first.name
        : 'Astra Medisupply';

    return [
      for (var i = 0; i < asmList.length; i++)
        ASMOrder(
          id: 'ASM-ORD-${1001 + i}',
          orderDate: now.subtract(Duration(days: i * 2 + 1)),
          deliveryDateTime: now
              .subtract(Duration(days: i))
              .add(Duration(hours: 13 + (i % 5))),
          asmId: asmList[i].asmId,
          asmName: asmList[i].name,
          doctorName: doctorList.length > i
              ? doctorList[i].doctorName
              : fallbackDoctor,
          chemistShopName: shops.length > i ? shops[i].shopName : fallbackShop,
          distributorName: distributors.isNotEmpty
              ? distributors[i % distributors.length].name
              : fallbackDistributor,
          status: ASMOrderStatus.values[i % ASMOrderStatus.values.length],
        ),
    ];
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
