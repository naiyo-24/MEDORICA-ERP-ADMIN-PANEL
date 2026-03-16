import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/month_plan/mr_month_trip_plan.dart';
import '../notifiers/mr_month_trip_plan_notifier.dart';

final mrMonthTripPlanNotifierProvider =
    NotifierProvider<MRMonthTripPlanNotifier, MRMonthTripPlanState>(
      MRMonthTripPlanNotifier.new,
    );

final mrMonthTripPlanListProvider = Provider<List<MRMonthTripPlan>>((ref) {
  return ref.watch(mrMonthTripPlanNotifierProvider).filteredPlans;
});

final mrMonthTripPlanCountProvider = Provider<int>((ref) {
  return ref.watch(mrMonthTripPlanListProvider).length;
});
