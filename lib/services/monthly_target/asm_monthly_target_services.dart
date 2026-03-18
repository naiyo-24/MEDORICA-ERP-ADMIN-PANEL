


import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/monthly_target/asm_monthly_target.dart';
import '../api_url.dart';

class ASMMonthlyTargetServices {
  final Dio _dio;

  ASMMonthlyTargetServices({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = ApiUrl.baseUrl;
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  Future<List<ASMMonthlyTarget>> getAll() async {
    final response = await _dio.get(ApiUrl.asmMonthlyTargetGetAll);
    final data = response.data as List;
    return data.map((e) => ASMMonthlyTarget.fromJson(e)).toList();
  }

  Future<List<ASMMonthlyTarget>> getByAsm(String asmId) async {
    final response = await _dio.get(ApiUrl.asmMonthlyTargetGetByAsm(asmId));
    final data = response.data as List;
    return data.map((e) => ASMMonthlyTarget.fromJson(e)).toList();
  }

  Future<ASMMonthlyTarget?> getByAsmYearMonth(String asmId, int year, int month) async {
    try {
      final response = await _dio.get(ApiUrl.asmMonthlyTargetGetByAsmYearMonth(asmId, year, month));
      return ASMMonthlyTarget.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

