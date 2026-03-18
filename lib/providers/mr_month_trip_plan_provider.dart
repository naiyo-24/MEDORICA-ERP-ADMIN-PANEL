import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/month_plan/mr_month_plan_services.dart';
import '../models/mr_monthly_plan.dart';

final mrMonthPlanServiceProvider = Provider<MRMonthPlanService>((ref) {
  return MRMonthPlanService();
});

final mrMonthPlansProvider = FutureProvider.family<List<MRDayPlanResponse>, String>((ref, mrId) async {
  final service = ref.read(mrMonthPlanServiceProvider);
  return await service.getPlansByMr(mrId);
});

final mrMonthPlanByDateProvider = FutureProvider.family.autoDispose<MRDayPlanResponse, Map<String, String>>((ref, params) async {
  final service = ref.read(mrMonthPlanServiceProvider);
  if (kDebugMode) {
    print('Fetching plan for MR: ${params['mrId']} on date: ${params['planDate']}');
  }
  return await service.getPlanByMrAndDate(params['mrId']!, params['planDate']!);
});
