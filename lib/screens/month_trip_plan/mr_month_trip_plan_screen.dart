import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/month_trip_plan/mr/mr_create_edit_month_trip_plan_card.dart';
import '../../cards/month_trip_plan/mr/mr_month_trip_plan_card.dart';
import '../../cards/month_trip_plan/mr/mr_month_trip_plan_filter_card.dart';
import '../../models/onboarding/mr.dart';
import '../../models/mr_month_trip_plan.dart';
import '../../providers/mr_month_trip_plan_provider.dart';
import '../../providers/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRMonthTripPlanScreen extends ConsumerStatefulWidget {
  const MRMonthTripPlanScreen({super.key});

  @override
  ConsumerState<MRMonthTripPlanScreen> createState() =>
      _MRMonthTripPlanScreenState();
}

class _MRMonthTripPlanScreenState extends ConsumerState<MRMonthTripPlanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrTripPlan;

  void _onMenuTap() => _scaffoldKey.currentState?.openDrawer();

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrTripPlan,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  Future<void> _openCreateDialog({
    required MR selectedMR,
    required DateTime initialDate,
  }) async {
    final notifier = ref.read(mrMonthTripPlanNotifierProvider.notifier);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: MRCreateEditMonthTripPlanCard(
            title: 'Create MR Month Plan',
            initialDate: initialDate,
            initialTime: const TimeOfDay(hour: 10, minute: 0),
            initialDescription: '',
            onCancel: () => Navigator.of(dialogContext).pop(),
            onSave: (date, time, description) {
              notifier.addTripPlanItem(
                mrId: selectedMR.mrId,
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
    required MRMonthTripPlan group,
    required MRTripPlanItem item,
  }) async {
    final notifier = ref.read(mrMonthTripPlanNotifierProvider.notifier);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: MRCreateEditMonthTripPlanCard(
            title: 'Edit MR Month Plan',
            initialDate: group.date,
            initialTime: item.time,
            initialDescription: item.description,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onSave: (date, time, description) {
              notifier.updateTripPlanItem(
                previousGroupId: group.id,
                itemId: item.id,
                mrId: group.mrId,
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

  MR? _selectedMR(List<MR> mrList, String selectedMRId) {
    for (final mr in mrList) {
      if (mr.id == selectedMRId) {
        return mr;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(mrMonthTripPlanNotifierProvider);
    final notifier = ref.read(mrMonthTripPlanNotifierProvider.notifier);
    final tripPlans = ref.watch(mrMonthTripPlanListProvider);
    final count = ref.watch(mrMonthTripPlanCountProvider);
    final mrList = ref.watch(mrOnboardingNotifierProvider).mrList;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Month Trip Plan',
        subtitle: 'Create and manage month-wise daily plan entries for MRs',
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
                MRMonthTripPlanFilterCard(
                  mrOptions: mrList,
                  selectedMRId: state.selectedMRId,
                  selectedDate: state.selectedDate,
                  onMRChanged: notifier.setSelectedMRId,
                  onDateChanged: notifier.setSelectedDate,
                  onCreatePressed: () async {
                    final selected = _selectedMR(mrList, state.selectedMRId);
                    if (selected == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an MR to create plan'),
                        ),
                      );
                      return;
                    }

                    await _openCreateDialog(
                      selectedMR: selected,
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
                        'No MR month trip plan found',
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
                      return MRMonthTripPlanCard(
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
