import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/mr.dart';
import '../api_url.dart';

// Service class to handle all MR onboarding related API calls
class MROnboardingServices {
  MROnboardingServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  // Get all MRs
  Future<List<MR>> getAllMR() async {
    final response = await _dio.get(ApiUrl.mrOnboardingGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(MR.fromJson)
        .toList(growable: false);
  }

  // Get MR by ID
  Future<MR> getMRById(String mrId) async {
    final response = await _dio.get(ApiUrl.mrOnboardingGetById(mrId));
    return MR.fromJson(Map<String, dynamic>.from(response.data));
  }

  // Create new MR
  Future<MR> createMR({
    required MR mr,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFileName,
  }) async {
    final formData = FormData.fromMap(mr.toApiMap());

    if (profilePhotoBytes != null && profilePhotoFileName != null) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          MultipartFile.fromBytes(
            profilePhotoBytes,
            filename: profilePhotoFileName,
          ),
        ),
      );
    }

    final response = await _dio.post(ApiUrl.mrOnboardingPost, data: formData);

    return MR.fromJson(Map<String, dynamic>.from(response.data));
  }

  // Update MR by ID
  Future<MR> updateMR({
    required String mrId,
    required MR mr,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFileName,
  }) async {
    final formData = FormData.fromMap(mr.toApiMap());

    if (profilePhotoBytes != null && profilePhotoFileName != null) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          MultipartFile.fromBytes(
            profilePhotoBytes,
            filename: profilePhotoFileName,
          ),
        ),
      );
    }

    final response = await _dio.put(
      ApiUrl.mrOnboardingUpdateById(mrId),
      data: formData,
    );

    return MR.fromJson(Map<String, dynamic>.from(response.data));
  }

  // Delete MR by ID
  Future<void> deleteMR(String mrId) async {
    await _dio.delete(ApiUrl.mrOnboardingDeleteById(mrId));
  }

  // Login method for MR
  Future<Map<String, dynamic>> login({
    required String phoneNo,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiUrl.mrOnboardingLogin,
      data: {'phone_no': phoneNo, 'password': password},
    );

    return Map<String, dynamic>.from(response.data);
  }
}
