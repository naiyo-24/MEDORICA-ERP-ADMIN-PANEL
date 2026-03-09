import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/portfolio.dart';
import '../api_url.dart';

class PortfolioServices {
  PortfolioServices({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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

  Future<List<PortfolioData>> getAllAboutUs() async {
    final response = await _dio.get(ApiUrl.aboutUsGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(PortfolioData.fromJson)
        .toList(growable: false);
  }

  Future<PortfolioData> createAboutUs(PortfolioData data) async {
    final response = await _dio.post(ApiUrl.aboutUsPost, data: data.toApiMap());

    return PortfolioData.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<PortfolioData> updateAboutUs({
    required int aboutUsId,
    required PortfolioData data,
  }) async {
    final response = await _dio.put(
      ApiUrl.aboutUsUpdateById(aboutUsId),
      data: data.toApiMap(),
    );

    return PortfolioData.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<void> deleteAboutUs(int aboutUsId) async {
    await _dio.delete(ApiUrl.aboutUsDeleteById(aboutUsId));
  }
}
