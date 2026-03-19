import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/order/mr/mr_order_card.dart';
import '../../cards/order/mr/mr_order_filter_card.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';
import '../../providers/order/mr_order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MROrderScreen extends ConsumerStatefulWidget {
  const MROrderScreen({super.key});

  @override
  ConsumerState<MROrderScreen> createState() => _MROrderScreenState();
}

class _MROrderScreenState extends ConsumerState<MROrderScreen> {
    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(mrOrderNotifierProvider.notifier).loadOrders();
      });
    }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrOrders;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrOrders,
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
    final orders = ref.watch(mrOrderListProvider);
    final count = ref.watch(mrOrderCountProvider);
    final mrList = ref.watch(mrListProvider);
    final searchQuery = ref.watch(mrOrderSearchQueryProvider);
    final selectedMRId = ref.watch(selectedMROrderIdProvider);
    final selectedDate = ref.watch(selectedMROrderDateProvider);
    final selectedStatus = ref.watch(selectedMROrderStatusProvider);
    final notifier = ref.read(mrOrderNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Orders',
        subtitle: 'Track MR orders by doctor interest and delivery status',
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
                MROrderFilterCard(
                  mrList: mrList,
                  searchQuery: searchQuery,
                  selectedMRId: selectedMRId,
                  selectedDate: selectedDate,
                  selectedStatus: selectedStatus,
                  onSearchChanged: notifier.setSearchQuery,
                  onMRChanged: (mrId) async {
                    notifier.setSelectedMR(mrId);
                    await notifier.loadOrders(mrId: mrId);
                  },
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
                      return MROrderCard(order: orders[index]);
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
