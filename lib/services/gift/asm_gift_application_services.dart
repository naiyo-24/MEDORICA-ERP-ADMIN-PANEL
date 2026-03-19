import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/gift/asm_gift_application.dart';
import '../api_url.dart';

class ASMGiftApplicationServices {
  final Dio _dio;

  ASMGiftApplicationServices()
      : _dio = Dio()
        ..interceptors.add(PrettyDioLogger());

  Future<List<ASMGiftApplication>> getAllApplications() async {
    final url = ApiUrl.baseUrl + ApiUrl.asmGiftApplicationGetAll;
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<ASMGiftApplication>> getApplicationsByASM(String asmId) async {
    final url = ApiUrl.baseUrl + ApiUrl.asmGiftApplicationGetByASM(asmId);
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<ASMGiftApplication> updateApplicationStatus({
    required String asmId,
    required int requestId,
    required ASMGiftApplicationStatus status,
  }) async {
    final formData = FormData.fromMap({'status': status.name});
    final url = ApiUrl.baseUrl + ApiUrl.asmGiftApplicationUpdateByASMAndRequestId(asmId, requestId);
    final response = await _dio.put(url, data: formData);
    return _fromJson(response.data);
  }

  ASMGiftApplication _fromJson(Map<String, dynamic> json) {
    return ASMGiftApplication(
      id: json['request_id'].toString(),
      doctorName: json['doctor_name'] ?? '',
      giftId: json['gift_id'].toString(),
      giftItemRequired: json['gift_name'] ?? '',
      asmRequestedById: json['asm_id'] ?? '',
      asmRequestedBy: json['asm_name'] ?? '',
      date: DateTime.parse(json['gift_date'] ?? json['created_at']),
      occasion: json['occassion'] ?? '',
      message: json['message'] ?? '',
      status: _parseStatus(json['status']),
    );
  }

  ASMGiftApplicationStatus _parseStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'pending':
        return ASMGiftApplicationStatus.pending;
      case 'shipped':
        return ASMGiftApplicationStatus.shipped;
      case 'delivered':
        return ASMGiftApplicationStatus.delivered;
      default:
        return ASMGiftApplicationStatus.pending;
    }
  }
}
