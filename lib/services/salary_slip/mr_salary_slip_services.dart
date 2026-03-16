import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/mr_salary_slip.dart';
import '../api_url.dart';

class MRSalarySlipServices {
  MRSalarySlipServices({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
      ),
    );

    return dio;
  }

  Future<MRSalarySlip> postMRSalarySlip({
    required String mrId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'salary_slip': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    final response = await _dio.post(
      ApiUrl.mrSalarySlipPostByMr(mrId),
      data: formData,
    );

    return MRSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<MRSalarySlip> updateMRSalarySlip({
    required String mrId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'salary_slip': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    final response = await _dio.put(
      ApiUrl.mrSalarySlipUpdateByMr(mrId),
      data: formData,
    );

    return MRSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<List<MRSalarySlip>> getAllMRSalarySlips() async {
    final response = await _dio.get(ApiUrl.mrSalarySlipGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(MRSalarySlip.fromJson)
        .toList(growable: false);
  }

  Future<MRSalarySlip> getMRSalarySlipByMr(String mrId) async {
    final response = await _dio.get(ApiUrl.mrSalarySlipGetByMr(mrId));
    return MRSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<Uint8List> downloadMRSalarySlipByMr(String mrId) async {
    final response = await _dio.get<List<int>>(
      ApiUrl.mrSalarySlipDownloadByMr(mrId),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  Future<MRSalarySlip> getMRSalarySlipById(int slipId) async {
    final response = await _dio.get(ApiUrl.mrSalarySlipGetById(slipId));
    return MRSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<Uint8List> downloadMRSalarySlipById(int slipId) async {
    final response = await _dio.get<List<int>>(
      ApiUrl.mrSalarySlipDownloadById(slipId),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  Future<void> deleteMRSalarySlipById(int slipId) async {
    await _dio.delete(ApiUrl.mrSalarySlipDeleteById(slipId));
  }
}
