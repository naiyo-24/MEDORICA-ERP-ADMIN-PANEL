import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/order/asm/asm_order_card.dart';
import '../../cards/order/asm/asm_order_filter_card.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../providers/asm_order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMOrderScreen extends ConsumerStatefulWidget {
  const ASMOrderScreen({super.key});

  @override
  ConsumerState<ASMOrderScreen> createState() => _ASMOrderScreenState();
}

class _ASMOrderScreenState extends ConsumerState<ASMOrderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.asmOrders;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.asmOrders,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orders = ref.watch(asmOrderListProvider);
    final count = ref.watch(asmOrderCountProvider);
    final asmList = ref.watch(asmListProvider);
    final searchQuery = ref.watch(asmOrderSearchQueryProvider);
    final selectedASMId = ref.watch(selectedASMOrderIdProvider);
    final selectedDate = ref.watch(selectedASMOrderDateProvider);
    final selectedStatus = ref.watch(selectedASMOrderStatusProvider);
    final notifier = ref.read(asmOrderNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Orders',
        subtitle: 'Track ASM orders by doctor interest and delivery status',
        showLogo: false,
        showMenuButton: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: _selectedNavKey,
          onItemTap: _onNavTap,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppLayout.screenPadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ASMOrderFilterCard(
                  asmList: asmList,
                  searchQuery: searchQuery,
                  selectedASMId: selectedASMId,
                  selectedDate: selectedDate,
                  selectedStatus: selectedStatus,
                  onSearchChanged: notifier.setSearchQuery,
                  onASMChanged: notifier.setSelectedASM,
                  onDateChanged: notifier.setSelectedDate,
                  onClearDate: notifier.clearDateFilter,
                  onStatusChanged: notifier.setSelectedStatus,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$count ${count == 1 ? 'Order' : 'Orders'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (orders.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Center(
                      child: Text(
                        'No orders found for current filters',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return ASMOrderCard(order: orders[index]);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
