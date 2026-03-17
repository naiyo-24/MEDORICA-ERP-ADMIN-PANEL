import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../api_url.dart';
import '../../models/attendance/mr_attendance.dart';

class MRAttendanceServices {
  final Dio _dio;

  MRAttendanceServices({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiUrl.baseUrl)) {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  Future<List<MRAttendance>> getAllAttendance() async {
    final response = await _dio.get(ApiUrl.mrAttendanceGetAll);
    return (response.data as List)
        .map((json) => MRAttendance.fromJson(json))
        .toList();
  }

  Future<List<MRAttendance>> getAttendanceByMrId(String mrId) async {
    final response = await _dio.get(ApiUrl.mrAttendanceGetByMrId(mrId));
    return (response.data as List)
        .map((json) => MRAttendance.fromJson(json))
        .toList();
  }

  Future<MRAttendance> getAttendanceByMrIdAndAttendanceId(String mrId, int attendanceId) async {
    final response = await _dio.get(ApiUrl.mrAttendanceGetByMrIdAndAttendanceId(mrId, attendanceId));
    return MRAttendance.fromJson(response.data);
  }

  Future<MRAttendance> updateAttendance({
    required String mrId,
    required int attendanceId,
    String? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    Uint8List? checkInSelfie,
    String? checkInSelfieFileName,
    Uint8List? checkOutSelfie,
    String? checkOutSelfieFileName,
  }) async {
    final formData = FormData();
    if (status != null) formData.fields.add(MapEntry('attendance_status', status));
    if (checkInTime != null) formData.fields.add(MapEntry('check_in_time', checkInTime.toIso8601String()));
    if (checkOutTime != null) formData.fields.add(MapEntry('check_out_time', checkOutTime.toIso8601String()));
    if (checkInSelfie != null && checkInSelfieFileName != null) {
      formData.files.add(MapEntry(
        'check_in_selfie',
        MultipartFile.fromBytes(checkInSelfie, filename: checkInSelfieFileName),
      ));
    }
    if (checkOutSelfie != null && checkOutSelfieFileName != null) {
      formData.files.add(MapEntry(
        'check_out_selfie',
        MultipartFile.fromBytes(checkOutSelfie, filename: checkOutSelfieFileName),
      ));
    }
    final response = await _dio.put(
      ApiUrl.mrAttendanceUpdateByMrIdAndAttendanceId(mrId, attendanceId),
      data: formData,
    );
    return MRAttendance.fromJson(response.data);
  }

  Future<void> deleteAttendance(int attendanceId) async {
    await _dio.delete(ApiUrl.mrAttendanceDeleteByAttendanceId(attendanceId));
  }

  // Helper to fetch selfie image bytes from a URL
  Future<Uint8List> fetchSelfie(String selfieUrl) async {
    final response = await _dio.get(selfieUrl, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  }
}
