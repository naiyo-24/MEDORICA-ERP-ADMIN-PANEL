import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/gift/gift.dart';
import '../api_url.dart';

class GiftInventoryService {
	GiftInventoryService()
			: _dio = Dio(
					BaseOptions(
						baseUrl: ApiUrl.baseUrl,
						connectTimeout: const Duration(seconds: 10),
						receiveTimeout: const Duration(seconds: 10),
					),
				) {
		_dio.interceptors.add(
			PrettyDioLogger(
				requestHeader: true,
				requestBody: true,
				responseBody: true,
				responseHeader: false,
				error: true,
				compact: true,
				maxWidth: 120,
			),
		);
	}

	final Dio _dio;

	Future<Gift> createGift({
		required String itemName,
		required String description,
		required int quantityInInventory,
		required double price,
	}) async {
		try {
			final response = await _dio.post(
				ApiUrl.giftInventoryPost,
				data: FormData.fromMap({
					'product_name': itemName,
					'description': description,
					'quantity_in_stock': quantityInInventory,
					'price_in_rupees': price,
				}),
			);

			return Gift.fromJson(response.data as Map<String, dynamic>);
		} on DioException catch (e) {
			throw Exception(_mapDioError(e));
		}
	}

	Future<List<Gift>> getAllGifts() async {
		try {
			final response = await _dio.get(ApiUrl.giftInventoryGetAll);
			final data = response.data as List<dynamic>;
			return data
					.map((e) => Gift.fromJson(e as Map<String, dynamic>))
					.toList(growable: false);
		} on DioException catch (e) {
			throw Exception(_mapDioError(e));
		}
	}

	Future<Gift> getGiftById(int giftId) async {
		try {
			final response = await _dio.get(ApiUrl.giftInventoryGetById(giftId));
			return Gift.fromJson(response.data as Map<String, dynamic>);
		} on DioException catch (e) {
			throw Exception(_mapDioError(e));
		}
	}

	Future<Gift> updateGift({
		required int giftId,
		required String itemName,
		required String description,
		required int quantityInInventory,
		required double price,
	}) async {
		try {
			final response = await _dio.put(
				ApiUrl.giftInventoryUpdateById(giftId),
				data: FormData.fromMap({
					'product_name': itemName,
					'description': description,
					'quantity_in_stock': quantityInInventory,
					'price_in_rupees': price,
				}),
			);

			return Gift.fromJson(response.data as Map<String, dynamic>);
		} on DioException catch (e) {
			throw Exception(_mapDioError(e));
		}
	}

	Future<void> deleteGift(int giftId) async {
		try {
			await _dio.delete(ApiUrl.giftInventoryDeleteById(giftId));
		} on DioException catch (e) {
			throw Exception(_mapDioError(e));
		}
	}

	String _mapDioError(DioException e) {
		if (e.type == DioExceptionType.connectionTimeout ||
				e.type == DioExceptionType.receiveTimeout ||
				e.type == DioExceptionType.sendTimeout) {
			return 'Connection timeout. Please try again.';
		}

		if (e.response?.statusCode == 404) {
			return 'Gift inventory item not found.';
		}

		if (e.response?.statusCode == 400) {
			return 'Invalid gift inventory request.';
		}

		if (e.response?.statusCode == 500) {
			return 'Server error. Please try again later.';
		}

		return e.message ?? 'Unexpected network error.';
	}
}
