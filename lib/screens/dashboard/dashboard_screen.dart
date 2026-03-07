import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/dashboard/asm_graph_card.dart';
import '../../cards/dashboard/count_card.dart';
import '../../cards/dashboard/dsitributor_graph_card.dart';
import '../../cards/dashboard/home_footer.dart';
import '../../cards/dashboard/mr_graph_card.dart';
import '../../cards/dashboard/order_graph_card.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.dashboard;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.dashboard,
    );
    if (handled) {
      return;
    }

    setState(() {
      _selectedNavKey = itemKey;
    });

    if (itemKey != SideNavItemKeys.dashboard) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemKey module will be available soon.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final data = state.data;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Dashboard',
        subtitle: 'Operational analytics and field performance overview',
        showLogo: false,
        showSubtitle: true,
        showBackButton: false,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CountCardSection(data: data),
                const SizedBox(height: AppSpacing.lg),
                MrGraphCard(regionData: data.mrRegionCounts),
                const SizedBox(height: AppSpacing.lg),
                AsmGraphCard(regionData: data.asmRegionCounts),
                const SizedBox(height: AppSpacing.lg),
                OrderGraphCard(
                  selectedYear: state.selectedYear,
                  availableYears: data.availableYears,
                  points: state.selectedYearOrders,
                  onYearChanged: (year) => ref
                      .read(dashboardNotifierProvider.notifier)
                      .setOrderYear(year),
                ),
                const SizedBox(height: AppSpacing.lg),
                DistributorGraphCard(regionData: data.distributorRegionCounts),
                const SizedBox(height: AppSpacing.xl),
                const HomeFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
