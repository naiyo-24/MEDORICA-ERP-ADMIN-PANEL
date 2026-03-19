import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/gift/mr_gift_application.dart';
import '../api_url.dart';

class MRGiftApplicationServices {
  final Dio _dio;

  MRGiftApplicationServices()
      : _dio = Dio()
        ..interceptors.add(PrettyDioLogger());

  Future<List<MRGiftApplication>> getAllApplications() async {
    final url = ApiUrl.baseUrl + ApiUrl.mrGiftApplicationGetAll;
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<MRGiftApplication>> getApplicationsByMR(String mrId) async {
    final url = ApiUrl.baseUrl + ApiUrl.mrGiftApplicationGetByMR(mrId);
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<MRGiftApplication> updateApplicationStatus({
    required String mrId,
    required int requestId,
    required GiftApplicationStatus status,
  }) async {
    final formData = FormData.fromMap({'status': status.name});
    final url = ApiUrl.baseUrl + ApiUrl.mrGiftApplicationUpdateByMRAndRequestId(mrId, requestId);
    final response = await _dio.put(url, data: formData);
    return _fromJson(response.data);
  }

  MRGiftApplication _fromJson(Map<String, dynamic> json) {
    return MRGiftApplication(
      id: json['request_id'].toString(),
      doctorName: json['doctor_name'] ?? '',
      giftId: json['gift_id'].toString(),
      giftItemRequired: json['gift_name'] ?? '',
      mrRequestedById: json['mr_id'] ?? '',
      mrRequestedBy: json['mr_name'] ?? '',
      date: DateTime.parse(json['gift_date'] ?? json['created_at']),
      occasion: json['occassion'] ?? '',
      message: json['message'] ?? '',
      status: _parseStatus(json['status']),
    );
  }

  GiftApplicationStatus _parseStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'pending':
        return GiftApplicationStatus.pending;
      case 'shipped':
        return GiftApplicationStatus.shipped;
      case 'delivered':
        return GiftApplicationStatus.delivered;
      default:
        return GiftApplicationStatus.pending;
    }
  }
}
