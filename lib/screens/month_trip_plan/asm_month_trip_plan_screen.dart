import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/month_trip_plan/asm/asm_create_edit_month_trip_plan_card.dart';
import '../../cards/month_trip_plan/asm/asm_month_trip_plan_card.dart';
import '../../cards/month_trip_plan/asm/asm_month_trip_plan_filter_card.dart';
import '../../models/onboarding/asm.dart';
import '../../models/asm_month_trip_plan.dart';
import '../../providers/asm_month_trip_plan_provider.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMMonthTripPlanScreen extends ConsumerStatefulWidget {
  const ASMMonthTripPlanScreen({super.key});

  @override
  ConsumerState<ASMMonthTripPlanScreen> createState() =>
      _ASMMonthTripPlanScreenState();
}

class _ASMMonthTripPlanScreenState
    extends ConsumerState<ASMMonthTripPlanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.asmTripPlan;

  void _onMenuTap() => _scaffoldKey.currentState?.openDrawer();

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.asmTripPlan,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  Future<void> _openCreateDialog({
    required ASM selectedASM,
    required DateTime initialDate,
  }) async {
    final notifier = ref.read(asmMonthTripPlanNotifierProvider.notifier);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: ASMCreateEditMonthTripPlanCard(
            title: 'Create ASM Month Plan',
            initialDate: initialDate,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
            initialDescription: '',
            onCancel: () => Navigator.of(dialogContext).pop(),
            onSave: (date, time, description) {
              notifier.addTripPlanItem(
                asmId: selectedASM.asmId,
                date: date,
                time: time,
                description: description,
              );
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> _openEditDialog({
    required ASMMonthTripPlan group,
    required ASMTripPlanItem item,
  }) async {
    final notifier = ref.read(asmMonthTripPlanNotifierProvider.notifier);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: ASMCreateEditMonthTripPlanCard(
            title: 'Edit ASM Month Plan',
            initialDate: group.date,
            initialTime: item.time,
            initialDescription: item.description,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onSave: (date, time, description) {
              notifier.updateTripPlanItem(
                previousGroupId: group.id,
                itemId: item.id,
                asmId: group.asmId,
                date: date,
                time: time,
                description: description,
              );
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  ASM? _selectedASM(List<ASM> asmList, String selectedASMId) {
    for (final asm in asmList) {
      if (asm.asmId == selectedASMId) {
        return asm;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(asmMonthTripPlanNotifierProvider);
    final notifier = ref.read(asmMonthTripPlanNotifierProvider.notifier);
    final tripPlans = ref.watch(asmMonthTripPlanListProvider);
    final count = ref.watch(asmMonthTripPlanCountProvider);
    final asmList = ref.watch(asmOnboardingNotifierProvider).asmList;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Month Trip Plan',
        subtitle: 'Create and manage month-wise daily plan entries for ASMs',
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
                ASMMonthTripPlanFilterCard(
                  asmOptions: asmList,
                  selectedASMId: state.selectedASMId,
                  selectedDate: state.selectedDate,
                  onASMChanged: notifier.setSelectedASMId,
                  onDateChanged: notifier.setSelectedDate,
                  onCreatePressed: () async {
                    final selected = _selectedASM(asmList, state.selectedASMId);
                    if (selected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an ASM to create plan'),
                        ),
                      );
                      return;
                    }

                    await _openCreateDialog(
                      selectedASM: selected,
                      initialDate: state.selectedDate ?? DateTime.now(),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$count ${count == 1 ? 'Day Plan' : 'Day Plans'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (tripPlans.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        'No ASM month trip plan found',
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
                    itemCount: tripPlans.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final group = tripPlans[index];
                      return ASMMonthTripPlanCard(
                        group: group,
                        onEdit: (item) async {
                          await _openEditDialog(group: group, item: item);
                        },
                        onDelete: (item) {
                          notifier.deleteTripPlanItem(
                            groupId: group.id,
                            itemId: item.id,
                          );
                        },
                      );
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
