import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/mr_monthly_plan.dart';
import '../../notifiers/mr_month_trip_plan_notifier.dart';
import '../../cards/month_trip_plan/mr/mr_filter_card.dart';
import '../../cards/month_trip_plan/mr/plan_calendar_card.dart';
import '../../cards/month_trip_plan/mr/plan_details_card.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRMonthTripPlanScreen extends ConsumerStatefulWidget {
  const MRMonthTripPlanScreen({super.key});

  @override
  ConsumerState<MRMonthTripPlanScreen> createState() => _MRMonthTripPlanScreenState();
}

class _MRMonthTripPlanScreenState extends ConsumerState<MRMonthTripPlanScreen> {
  String? selectedMrId;
  DateTime? selectedDate;
  MRDayPlanResponse? selectedPlan;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(mrOnboardingNotifierProvider.notifier).loadMRList();
      // Do NOT fetch plans until MR is selected
    });
  }

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrTripPlan,
    );
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(mrMonthTripPlanNotifierProvider);
    final mrList = ref.watch(mrListProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: MedoricaAppBar(
        title: 'MR Month Trip Plan',
        subtitle: 'View and manage MR trip plans',
        showMenuButton: true,
        showLogo: false,
        showSubtitle: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: SideNavBarDrawer(
        selectedKey: SideNavItemKeys.mrTripPlan,
        onItemTap: _onNavTap,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MRFilterCard(
              mrList: mrList,
              selectedMrId: selectedMrId,
              onMrChanged: (mrId) {
                setState(() {
                  selectedMrId = mrId;
                  selectedDate = null;
                  selectedPlan = null;
                });
                if (mrId.isNotEmpty) {
                  ref.read(mrMonthTripPlanNotifierProvider.notifier).fetchPlans(mrId);
                }
              },
            ),
            if (selectedMrId != null && selectedMrId!.isNotEmpty)
              PlanCalendarCard(
                plans: plans,
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                    try {
                      selectedPlan = plans.firstWhere(
                        (plan) => plan.planDate.year == date.year && plan.planDate.month == date.month && plan.planDate.day == date.day,
                      );
                    } catch (_) {
                      selectedPlan = null;
                    }
                  });
                },
              ),
            if (selectedPlan != null)
              PlanDetailsCard(
                plan: selectedPlan!,
              ),
          ],
        ),
      ),
    );
  }
}
