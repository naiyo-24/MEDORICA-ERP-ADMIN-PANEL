import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/order/mr_order.dart';
import '../api_url.dart';

class MROrderServices {
  final Dio _dio;

  MROrderServices()
      : _dio = Dio()
        ..interceptors.add(PrettyDioLogger());

  Future<List<MROrder>> getAllMROrders() async {
    final url = ApiUrl.baseUrl + ApiUrl.mrOrderGetAll;
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<MROrder>> getOrdersByMR(String mrId) async {
    final url = ApiUrl.baseUrl + ApiUrl.mrOrderGetByMR(mrId);
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<MROrder> getOrderByMRAndOrderId(String mrId, String orderId) async {
    final url = ApiUrl.baseUrl + ApiUrl.mrOrderGetByMRAndOrderId(mrId, orderId);
    final response = await _dio.get(url);
    return _fromJson(response.data);
  }

  Future<MROrder> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final formData = FormData.fromMap({'status': status});
    final url = ApiUrl.baseUrl + ApiUrl.mrOrderUpdateByOrderId(orderId);
    final response = await _dio.put(url, data: formData);
    return _fromJson(response.data);
  }

  MROrder _fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now();
    final updatedAt = DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? createdAt;
    return MROrder(
      id: json['order_id'] ?? '',
      orderDate: createdAt,
      deliveryDateTime: updatedAt,
      mrId: json['mr_id'] ?? '',
      mrName: json['mr_id'] ?? '',
      doctorName: json['doctor_id'] ?? '-',
      chemistShopName: json['chemist_shop_id'] ?? '-',
      distributorName: json['distributor_id'] ?? '-',
      status: _parseStatus(json['status']),
      productsWithPrice: json['products_with_price'],
      totalAmountRupees: (json['total_amount_rupees'] as num?)?.toDouble() ?? 0,
    );
  }

  MROrderStatus _parseStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'pending':
        return MROrderStatus.pending;
      case 'shipped':
        return MROrderStatus.shipped;
      case 'dispatched':
        return MROrderStatus.dispatched;
      case 'delivered':
        return MROrderStatus.delivered;
      default:
        return MROrderStatus.pending;
    }
  }
}
