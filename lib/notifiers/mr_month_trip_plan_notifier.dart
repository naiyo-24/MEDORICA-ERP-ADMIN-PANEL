import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mr_monthly_plan.dart';
import '../providers/mr_month_trip_plan_provider.dart';

class MRMonthTripPlanNotifier extends Notifier<List<MRDayPlanResponse>> {
  @override
  List<MRDayPlanResponse> build() {
    return [];
  }

  Future<void> fetchPlans(String mrId) async {
    final service = ref.read(mrMonthPlanServiceProvider);
    final plans = await service.getPlansByMr(mrId);
    state = plans;
  }

  void clear() {
    state = [];
  }
}

final mrMonthTripPlanNotifierProvider = NotifierProvider<MRMonthTripPlanNotifier, List<MRDayPlanResponse>>(
  MRMonthTripPlanNotifier.new,
);
