import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/appointment/mr_appointments.dart';
import '../api_url.dart';

class MRAppointmentServices {
  final Dio _dio;

  MRAppointmentServices()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiUrl.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )..interceptors.add(PrettyDioLogger());

  Future<List<MRAppointment>> getAllAppointments() async {
    final response = await _dio.get(ApiUrl.mrAppointmentGetAll);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<MRAppointment>> getAppointmentsByMR(String mrId) async {
    final response = await _dio.get(ApiUrl.mrAppointmentGetByMR(mrId));
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<MRAppointment>> getAppointmentsByDoctor(String doctorId) async {
    final response = await _dio.get(ApiUrl.mrAppointmentGetByDoctor(doctorId));
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<MRAppointment>> getAppointmentsByMRDoctor(String mrId, String doctorId) async {
    final response = await _dio.get(ApiUrl.mrAppointmentGetByMRDoctor(mrId, doctorId));
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<MRAppointment> getAppointmentById(String appointmentId) async {
    final response = await _dio.get(ApiUrl.mrAppointmentGetById(appointmentId));
    return _fromJson(response.data);
  }

  MRAppointment _fromJson(Map<String, dynamic> json) {
    final mrId = json['mr_id'] as String? ?? '';
    final doctorId = json['doctor_id'] as String? ?? '';
    final appointmentProofImage = json['completion_photo_proof'] as String?;
    final _ = json['visual_ads'] as List?;
    final place = json['place'] as String?;

    String? proofImageUrl;
    if (appointmentProofImage != null && appointmentProofImage.isNotEmpty) {
      proofImageUrl = '${ApiUrl.baseUrl}/$appointmentProofImage';
    }

    return MRAppointment(
      id: json['appointment_id'] as String? ?? '',
      dateTime: _parseDateTime(json['appointment_date'], json['appointment_time']),
      mrId: mrId,
      doctorId: doctorId,
      status: _parseStatus(json['status']),
      place: place,
      appointmentProofImage: proofImageUrl,
      visualAdsRaw: json['visual_ads'] as List?,
    );
  }

  DateTime _parseDateTime(String? date, String? time) {
    if (date == null || time == null) return DateTime.now();
    final dateStr = date.trim();
    final timeStr = time.trim();
    try {
      final dateParts = dateStr.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      final timeParts = timeStr.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return DateTime.now();
    }
  }

  AppointmentStatus _parseStatus(String? status) {
    switch (status) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'rescheduled':
        return AppointmentStatus.rescheduled;
      case 'pending':
        return AppointmentStatus.scheduled;
      case 'ongoing':
        return AppointmentStatus.rescheduled;
      default:
        return AppointmentStatus.scheduled;
    }
  }
}
