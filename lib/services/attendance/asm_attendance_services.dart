import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../api_url.dart';
import '../../models/attendance/asm_attendance.dart';

class ASMAttendanceServices {
  final Dio _dio;

  ASMAttendanceServices({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiUrl.baseUrl)) {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }

  Future<List<ASMAttendance>> getAllAttendance() async {
    final response = await _dio.get(ApiUrl.asmAttendanceGetAll);
    return (response.data as List)
        .map((json) => ASMAttendance.fromJson(json))
        .toList();
  }

  Future<List<ASMAttendance>> getAttendanceByAsmId(String asmId) async {
    final response = await _dio.get(ApiUrl.asmAttendanceGetByAsmId(asmId));
    return (response.data as List)
        .map((json) => ASMAttendance.fromJson(json))
        .toList();
  }

  Future<ASMAttendance> getAttendanceByAsmIdAndAttendanceId(String asmId, int attendanceId) async {
    final response = await _dio.get(ApiUrl.asmAttendanceGetByAsmIdAndAttendanceId(asmId, attendanceId));
    return ASMAttendance.fromJson(response.data);
  }

  Future<ASMAttendance> updateAttendance({
    required String asmId,
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
      ApiUrl.asmAttendanceUpdateByAsmIdAndAttendanceId(asmId, attendanceId),
      data: formData,
    );
    return ASMAttendance.fromJson(response.data);
  }

  Future<void> deleteAttendance(int attendanceId) async {
    await _dio.delete(ApiUrl.asmAttendanceDeleteByAttendanceId(attendanceId));
  }

  // Helper to fetch selfie image bytes from a URL
  Future<Uint8List> fetchSelfie(String selfieUrl) async {
    final response = await _dio.get(selfieUrl, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  }
}
