import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../services/api_url.dart';
import '../../models/mr_monthly_plan.dart';

class MRMonthPlanService {
  final Dio _dio;

  MRMonthPlanService()
      : _dio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl))
        ..interceptors.add(PrettyDioLogger());

  Future<List<MonthlyPlan>> getAllPlans() async {
    final response = await _dio.get(ApiUrl.mrMonthlyPlanGetAll);
    return (response.data as List)
        .map((e) => MonthlyPlan.fromJson(e))
        .toList();
  }

  Future<List<MRDayPlanResponse>> getPlansByMr(String mrId) async {
    final response = await _dio.get(ApiUrl.mrMonthlyPlanGetByMr(mrId));
    return (response.data as List)
        .map((e) => MRDayPlanResponse.fromJson(e))
        .toList();
  }

  Future<MRDayPlanResponse> getPlanByMrAndDate(String mrId, String planDate) async {
    final response = await _dio.get(ApiUrl.mrMonthlyPlanGetByMrAndDate(mrId, planDate));
    return MRDayPlanResponse.fromJson(response.data);
  }

  Future<void> deletePlan(int planId) async {
    await _dio.delete(ApiUrl.mrMonthlyPlanDeleteById(planId));
  }
}
