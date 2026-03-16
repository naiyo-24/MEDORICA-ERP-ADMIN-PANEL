import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/salary_slip/asm_salary_slip.dart';
import '../api_url.dart';

class ASMSalarySlipServices {
  ASMSalarySlipServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  Future<ASMSalarySlip> postASMSalarySlip({
    required String asmId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'salary_slip': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    final response = await _dio.post(
      ApiUrl.asmSalarySlipPostByAsm(asmId),
      data: formData,
    );

    return ASMSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<ASMSalarySlip> updateASMSalarySlip({
    required String asmId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      'salary_slip': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    final response = await _dio.put(
      ApiUrl.asmSalarySlipUpdateByAsm(asmId),
      data: formData,
    );

    return ASMSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<List<ASMSalarySlip>> getAllASMSalarySlips() async {
    final response = await _dio.get(ApiUrl.asmSalarySlipGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(ASMSalarySlip.fromJson)
        .toList(growable: false);
  }

  Future<ASMSalarySlip> getASMSalarySlipByAsmId(String asmId) async {
    final response = await _dio.get(ApiUrl.asmSalarySlipGetByAsm(asmId));
    return ASMSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<Uint8List> downloadASMSalarySlipByAsmId(String asmId) async {
    final response = await _dio.get<List<int>>(
      ApiUrl.asmSalarySlipDownloadByAsm(asmId),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  Future<ASMSalarySlip> getASMSalarySlipById(int slipId) async {
    final response = await _dio.get(ApiUrl.asmSalarySlipGetById(slipId));
    return ASMSalarySlip.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<Uint8List> downloadASMSalarySlipById(int slipId) async {
    final response = await _dio.get<List<int>>(
      ApiUrl.asmSalarySlipDownloadById(slipId),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  Future<void> deleteASMSalarySlipById(int slipId) async {
    await _dio.delete(ApiUrl.asmSalarySlipDeleteById(slipId));
  }
}
