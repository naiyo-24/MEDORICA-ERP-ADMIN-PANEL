import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../models/mr_doctor_network.dart';
import '../../api_url.dart';

// Service class to handle all MR Doctor Network related API calls
class MRDoctorNetworkServices {
  MRDoctorNetworkServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  // Get all doctors across all MR networks
  Future<List<MRDoctorNetwork>> getAllDoctors() async {
    try {
      final response = await _dio.get(ApiUrl.mrDoctorNetworkGetAll);
      final payload = response.data;

      if (payload is! List) {
        return const [];
      }

      return payload
          .whereType<Map<String, dynamic>>()
          .map(MRDoctorNetwork.fromJson)
          .toList(growable: false);
    } catch (e) {
      rethrow;
    }
  }

  // Get doctor details by doctor_id
  Future<MRDoctorNetwork> getDoctorByDoctorId(String doctorId) async {
    try {
      final response = await _dio.get(
        ApiUrl.mrDoctorNetworkGetByDoctor(doctorId),
      );
      return MRDoctorNetwork.fromJson(Map<String, dynamic>.from(response.data));
    } catch (e) {
      rethrow;
    }
  }

  // Get all doctors associated with a specific MR by mr_id
  Future<List<MRDoctorNetwork>> getAllDoctorsByMrId(String mrId) async {
    try {
      final response = await _dio.get(ApiUrl.mrDoctorNetworkGetAllByMr(mrId));
      final payload = response.data;

      if (payload is! List) {
        return const [];
      }

      return payload
          .whereType<Map<String, dynamic>>()
          .map(MRDoctorNetwork.fromJson)
          .toList(growable: false);
    } catch (e) {
      rethrow;
    }
  }

  // Get doctor details by both mr_id and doctor_id
  Future<MRDoctorNetwork> getDoctorByMrIdAndDoctorId(
    String mrId,
    String doctorId,
  ) async {
    try {
      final response = await _dio.get(
        ApiUrl.mrDoctorNetworkGetByMrAndDoctor(mrId, doctorId),
      );
      return MRDoctorNetwork.fromJson(Map<String, dynamic>.from(response.data));
    } catch (e) {
      rethrow;
    }
  }
}
