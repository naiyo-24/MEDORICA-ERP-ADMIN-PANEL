import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/order/asm_order.dart';
import '../api_url.dart';

class ASMOrderServices {
  ASMOrderServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  Future<List<ASMOrder>> getAllASMOrders({
    Map<String, String>? asmNameById,
  }) async {
    final response = await _dio.get(ApiUrl.asmOrderGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => ASMOrder.fromJson(
            item,
            asmName: asmNameById?[item['asm_id']?.toString() ?? ''],
          ),
        )
        .toList(growable: false);
  }

  Future<List<ASMOrder>> getOrdersByASMId(
    String asmId, {
    String? asmName,
  }) async {
    final response = await _dio.get(ApiUrl.asmOrderGetByAsm(asmId));
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map((item) => ASMOrder.fromJson(item, asmName: asmName))
        .toList(growable: false);
  }

  Future<ASMOrder> getOrderByASMAndOrderId({
    required String asmId,
    required String orderId,
    String? asmName,
  }) async {
    final response = await _dio.get(
      ApiUrl.asmOrderGetByAsmAndOrderId(asmId, orderId),
    );

    return ASMOrder.fromJson(
      Map<String, dynamic>.from(response.data),
      asmName: asmName,
    );
  }

  Future<ASMOrder> updateOrderStatus({
    required String orderId,
    required ASMOrderStatus status,
    String? asmName,
  }) async {
    final formData = FormData.fromMap({'status': status.name});

    final response = await _dio.put(
      ApiUrl.asmOrderUpdateByOrderId(orderId),
      data: formData,
    );

    return ASMOrder.fromJson(
      Map<String, dynamic>.from(response.data),
      asmName: asmName,
    );
  }

  Future<void> deleteOrderByOrderId(String orderId) async {
    await _dio.delete(ApiUrl.asmOrderDeleteByOrderId(orderId));
  }
}

final asmOrderServicesProvider = Provider<ASMOrderServices>((ref) {
  return ASMOrderServices();
});
