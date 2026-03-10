import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/visual_ads.dart';
import '../api_url.dart';

class VisualAdsService {
  late Dio _dio;

  VisualAdsService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  /// Create a new visual ad with image
  Future<VisualAd> createVisualAd({
    required String name,
    required Uint8List imageBytes,
    required String imageFileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'medicine_name': name,
        'ad_image': MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName,
        ),
      });

      final response = await _dio.post(
        ApiUrl.visualAdsPost,
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return VisualAd.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to create visual ad: ${response.statusMessage}');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Fetch all visual ads
  Future<List<VisualAd>> getAllVisualAds() async {
    try {
      final response = await _dio.get(ApiUrl.visualAdsGetAll);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((item) => VisualAd.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to fetch visual ads: ${response.statusMessage}');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Fetch a visual ad by its ID
  Future<VisualAd> getVisualAdById(String adId) async {
    try {
      final response = await _dio.get(
        ApiUrl.visualAdsGetById(adId),
      );

      if (response.statusCode == 200) {
        return VisualAd.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to fetch visual ad: ${response.statusMessage}');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Update an existing visual ad
  Future<VisualAd> updateVisualAd({
    required String adId,
    required String name,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = {
        'medicine_name': name,
      };

      if (imageBytes != null && imageFileName != null) {
        formDataMap['ad_image'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageFileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.put(
        ApiUrl.visualAdsUpdateById(adId),
        data: formData,
      );

      if (response.statusCode == 200) {
        return VisualAd.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to update visual ad: ${response.statusMessage}');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Delete a visual ad by its ID
  Future<void> deleteVisualAd(String adId) async {
    try {
      final response = await _dio.delete(
        ApiUrl.visualAdsDeleteById(adId),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete visual ad: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handle Dio exceptions and convert them to user-friendly error messages
  String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 404) {
          return 'Visual ad not found.';
        } else if (e.response?.statusCode == 400) {
          return 'Bad request. Please check your input.';
        } else if (e.response?.statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'Error: ${e.response?.statusMessage ?? 'Unknown error'}';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred.';
      case DioExceptionType.badCertificate:
        return 'Bad certificate.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
    }
  }
}
