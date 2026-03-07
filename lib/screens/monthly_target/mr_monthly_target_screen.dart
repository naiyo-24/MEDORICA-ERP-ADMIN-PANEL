import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/monthly_target/mr/mr_filter_card.dart';
import '../../cards/monthly_target/mr/mr_monthly_target_card.dart';
import '../../providers/mr_monthly_target_provider.dart';
import '../../providers/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRMonthlyTargetScreen extends ConsumerStatefulWidget {
  const MRMonthlyTargetScreen({super.key});

  @override
  ConsumerState<MRMonthlyTargetScreen> createState() =>
      _MRMonthlyTargetScreenState();
}

class _MRMonthlyTargetScreenState extends ConsumerState<MRMonthlyTargetScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrTargets;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrTargets,
    );
    if (handled) {
      return;
    }

    setState(() {
      _selectedNavKey = itemKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(mrMonthlyTargetNotifierProvider);
    final notifier = ref.read(mrMonthlyTargetNotifierProvider.notifier);
    final mrList = ref.watch(mrOnboardingNotifierProvider).mrList;
    final months = ref.watch(monthlyTargetMonthsProvider);
    final years = ref.watch(monthlyTargetYearsProvider);
    final appliedTarget = ref.watch(mrAppliedMonthlyTargetProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Monthly Targets',
        subtitle: 'Track monthly targets and performance for MRs',
        showMenuButton: true,
        showLogo: false,
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
                MRFilterCard(
                  mrList: mrList,
                  selectedMRId: state.selectedMRId,
                  selectedMonth: state.selectedMonth,
                  selectedYear: state.selectedYear,
                  months: months,
                  years: years,
                  isApplying: state.isApplying,
                  onMRChanged: (value) {
                    if (value != null) {
                      notifier.setSelectedMR(value);
                    }
                  },
                  onMonthChanged: (value) {
                    if (value != null) {
                      notifier.setSelectedMonth(value);
                    }
                  },
                  onYearChanged: (value) {
                    if (value != null) {
                      notifier.setSelectedYear(value);
                    }
                  },
                  onApply: () async {
                    await notifier.applyFilter();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (appliedTarget != null)
                  MRMonthlyTargetCard(target: appliedTarget)
                else
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.chart_21,
                          size: 52,
                          color: AppColors.quaternary.withOpacity(0.7),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Apply filters to view MR monthly target',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
