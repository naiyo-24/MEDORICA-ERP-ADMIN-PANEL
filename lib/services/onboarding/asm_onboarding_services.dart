import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/onboarding/asm.dart';
import '../api_url.dart';

// Service class to handle all ASM onboarding related API calls
class ASMOnboardingServices {
  ASMOnboardingServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  // Get all ASMs
  Future<List<ASM>> getAllASM() async {
    final response = await _dio.get(ApiUrl.asmOnboardingGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(ASM.fromJson)
        .toList(growable: false);
  }

  // Get ASM by ID
  Future<ASM> getASMById(String asmId) async {
    final response = await _dio.get(ApiUrl.asmOnboardingGetById(asmId));
    return ASM.fromJson(Map<String, dynamic>.from(response.data));
  }

  // Create new ASM
  Future<ASM> createASM({
    required ASM asm,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFileName,
  }) async {
    final formData = FormData.fromMap(asm.toApiMap());

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

    final response = await _dio.post(ApiUrl.asmOnboardingPost, data: formData);

    return ASM.fromJson(Map<String, dynamic>.from(response.data));
  }

  // Update ASM by ID
  Future<ASM> updateASM({
    required String asmId,
    required ASM asm,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFileName,
  }) async {
    final formData = FormData.fromMap(asm.toApiMap());

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
      ApiUrl.asmOnboardingUpdateById(asmId),
      data: formData,
    );

    return ASM.fromJson(Map<String, dynamic>.from(response.data));
  }

  // Delete ASM by ID
  Future<void> deleteASM(String asmId) async {
    await _dio.delete(ApiUrl.asmOnboardingDeleteById(asmId));
  }

  // Login method for ASM
  Future<Map<String, dynamic>> login({
    required String phoneNo,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiUrl.asmOnboardingLogin,
      data: {'phone_no': phoneNo, 'password': password},
    );

    return Map<String, dynamic>.from(response.data);
  }
}
