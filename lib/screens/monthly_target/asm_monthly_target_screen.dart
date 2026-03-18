import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/monthly_target/asm/asm_filter_card.dart';
import '../../cards/monthly_target/asm/asm_monthly_target_card.dart';
import '../../providers/monthly_target/asm_monthly_target_provider.dart';
import '../../providers/onboarding/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMMonthlyTargetScreen extends ConsumerStatefulWidget {
  const ASMMonthlyTargetScreen({super.key});

  @override
  ConsumerState<ASMMonthlyTargetScreen> createState() =>
      _ASMMonthlyTargetScreenState();
}

class _ASMMonthlyTargetScreenState
    extends ConsumerState<ASMMonthlyTargetScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.asmTargets;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.asmTargets,
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
    final state = ref.watch(asmMonthlyTargetNotifierProvider);
    final notifier = ref.read(asmMonthlyTargetNotifierProvider.notifier);
    final asmList = ref.watch(asmListProvider); // Use filtered ASM list for dropdown
    final months = ref.watch(asmMonthlyTargetMonthsProvider);
    final years = ref.watch(asmMonthlyTargetYearsProvider);
    final appliedTarget = ref.watch(asmAppliedMonthlyTargetProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Monthly Targets',
        subtitle: 'Track monthly targets and performance for ASMs',
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
                ASMFilterCard(
                  asmList: asmList,
                  selectedASMId: state.selectedASMId,
                  selectedMonth: state.selectedMonth,
                  selectedYear: state.selectedYear,
                  months: months,
                  years: years,
                  isApplying: state.isApplying,
                  onASMChanged: (value) {
                    if (value != null) {
                      notifier.setSelectedASM(value);
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
                  ASMMonthlyTargetCard(target: appliedTarget)
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
                          color: AppColors.quaternary.withAlpha(179),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Apply filters to view ASM monthly target',
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
