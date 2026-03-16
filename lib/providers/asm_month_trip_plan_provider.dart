import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/month_plan/asm_month_trip_plan.dart';
import '../notifiers/asm_month_trip_plan_notifier.dart';

final asmMonthTripPlanNotifierProvider =
    NotifierProvider<ASMMonthTripPlanNotifier, ASMMonthTripPlanState>(
      ASMMonthTripPlanNotifier.new,
    );

final asmMonthTripPlanListProvider = Provider<List<ASMMonthTripPlan>>((ref) {
  return ref.watch(asmMonthTripPlanNotifierProvider).filteredPlans;
});

final asmMonthTripPlanCountProvider = Provider<int>((ref) {
  return ref.watch(asmMonthTripPlanListProvider).length;
});
