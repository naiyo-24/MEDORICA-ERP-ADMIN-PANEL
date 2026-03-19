import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/appointment/asm_appointments.dart';
import '../api_url.dart';

class ASMAppointmentServices {
  final Dio _dio;

  ASMAppointmentServices()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiUrl.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )..interceptors.add(PrettyDioLogger());

  Future<List<ASMAppointment>> getAllAppointments() async {
    final response = await _dio.get(ApiUrl.asmAppointmentGetAll);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<ASMAppointment>> getAppointmentsByASM(String asmId) async {
    final response = await _dio.get(ApiUrl.asmAppointmentGetByASM(asmId));
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<ASMAppointment>> getAppointmentsByDoctor(String doctorId) async {
    final response = await _dio.get(ApiUrl.asmAppointmentGetByDoctor(doctorId));
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<ASMAppointment>> getAppointmentsByASMDoctor(String asmId, String doctorId) async {
    final response = await _dio.get(ApiUrl.asmAppointmentGetByASMDoctor(asmId, doctorId));
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<ASMAppointment> getAppointmentById(String appointmentId) async {
    final response = await _dio.get(ApiUrl.asmAppointmentGetById(appointmentId));
    return _fromJson(response.data);
  }

  ASMAppointment _fromJson(Map<String, dynamic> json) {
    // Parse date and time
    DateTime dateTime = DateTime.now();
    try {
      final dateStr = json['appointment_date']?.trim() ?? '';
      final timeStr = json['appointment_time']?.trim() ?? '';
      if (dateStr.isNotEmpty && timeStr.isNotEmpty) {
        final dateParts = dateStr.split('-');
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);
        // Support both 12h and 24h time
        int hour = 0;
        int minute = 0;
        if (timeStr.contains('AM') || timeStr.contains('PM')) {
          final timeParts = timeStr.replaceAll('AM', '').replaceAll('PM', '').trim().split(':');
          hour = int.parse(timeParts[0]);
          minute = int.parse(timeParts[1]);
          if (timeStr.contains('PM') && hour != 12) hour += 12;
          if (timeStr.contains('AM') && hour == 12) hour = 0;
        } else {
          final timeParts = timeStr.split(':');
          hour = int.parse(timeParts[0]);
          minute = int.parse(timeParts[1]);
        }
        dateTime = DateTime(year, month, day, hour, minute);
      }
    } catch (_) {}

    // Construct completion photo URL if present
    String? proofImageUrl;
    final appointmentProofImage = json['completion_photo_proof'] as String?;
    if (appointmentProofImage != null && appointmentProofImage.isNotEmpty) {
      proofImageUrl = '${ApiUrl.baseUrl}/$appointmentProofImage';
    }

    return ASMAppointment(
      id: json['appointment_id'] as String? ?? '',
      dateTime: dateTime,
      asmId: json['asm_id'] as String? ?? '',
      asmName: '', // To be filled from provider in UI
      doctorName: '', // To be filled from provider in UI
      chamberName: '', // To be filled from provider in UI
      chamberAddress: '', // To be filled from provider in UI
      chamberPhone: '', // To be filled from provider in UI
      doctorPhone: '', // To be filled from provider in UI
      doctorSpecialization: '', // To be filled from provider in UI
      status: _parseStatus(json['status']),
      appointmentProofImage: proofImageUrl,
    );
  }

  ASMAppointmentStatus _parseStatus(String? status) {
    switch (status) {
      case 'scheduled':
        return ASMAppointmentStatus.scheduled;
      case 'completed':
        return ASMAppointmentStatus.completed;
      case 'cancelled':
        return ASMAppointmentStatus.cancelled;
      case 'rescheduled':
        return ASMAppointmentStatus.rescheduled;
      case 'pending':
        return ASMAppointmentStatus.scheduled;
      case 'ongoing':
        return ASMAppointmentStatus.rescheduled;
      default:
        return ASMAppointmentStatus.scheduled;
    }
  }
}
