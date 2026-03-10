import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/distributor.dart';
import '../api_url.dart';

class DistributorService {
  late final Dio _dio;

  DistributorService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Add pretty dio logger for debugging
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 90,
      ),
    );
  }

  /// Create a new Distributor
  /// Accepts all distributor details including photo upload
  Future<Distributor> createDistributor({
    required String distName,
    required String distPhoneNo,
    required String distLocation,
    required String distProducts,
    required String paymentTerms,
    String? distEmail,
    String? distDescription,
    double? distMinOrderValueRupees,
    int? distExpectedDeliveryTimeDays,
    String? bankName,
    String? bankAcNo,
    String? branchName,
    String? ifscCode,
    String? deliveryTerritories,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    try {
      final formDataMap = <String, dynamic>{
        'dist_name': distName,
        'dist_phone_no': distPhoneNo,
        'dist_location': distLocation,
        'dist_products': distProducts,
        'payment_terms': paymentTerms,
      };

      // Add optional fields only if they're not null
      if (distEmail != null) formDataMap['dist_email'] = distEmail;
      if (distDescription != null) formDataMap['dist_description'] = distDescription;
      if (distMinOrderValueRupees != null) formDataMap['dist_min_order_value_rupees'] = distMinOrderValueRupees;
      if (distExpectedDeliveryTimeDays != null) formDataMap['dist_expected_delivery_time_days'] = distExpectedDeliveryTimeDays;
      if (bankName != null) formDataMap['bank_name'] = bankName;
      if (bankAcNo != null) formDataMap['bank_ac_no'] = bankAcNo;
      if (branchName != null) formDataMap['branch_name'] = branchName;
      if (ifscCode != null) formDataMap['ifsc_code'] = ifscCode;
      if (deliveryTerritories != null) formDataMap['delivery_territories'] = deliveryTerritories;

      // Add photo if provided
      if (photoBytes != null && photoFileName != null) {
        formDataMap['dist_photo'] = MultipartFile.fromBytes(
          photoBytes,
          filename: photoFileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiUrl.distributorPost,
        data: formData,
      );

      return Distributor.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Fetch all Distributors
  Future<List<Distributor>> getAllDistributors() async {
    try {
      final response = await _dio.get(ApiUrl.distributorGetAll);

      final distributors = (response.data as List)
          .map((item) => Distributor.fromJson(item as Map<String, dynamic>))
          .toList();

      return distributors;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Fetch a Distributor by ID
  Future<Distributor> getDistributorById(String distId) async {
    try {
      final response = await _dio.get(
        ApiUrl.distributorGetById(distId),
      );

      return Distributor.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Update an existing Distributor
  /// All fields are optional - only provided fields will be updated
  Future<Distributor> updateDistributor({
    required String distId,
    String? distName,
    String? distPhoneNo,
    String? distLocation,
    String? distEmail,
    String? distDescription,
    double? distMinOrderValueRupees,
    String? distProducts,
    int? distExpectedDeliveryTimeDays,
    String? paymentTerms,
    String? bankName,
    String? bankAcNo,
    String? branchName,
    String? ifscCode,
    String? deliveryTerritories,
    Uint8List? photoBytes,
    String? photoFileName,
  }) async {
    try {
      final formDataMap = <String, dynamic>{};

      // Add optional fields only if they're not null
      if (distName != null) formDataMap['dist_name'] = distName;
      if (distPhoneNo != null) formDataMap['dist_phone_no'] = distPhoneNo;
      if (distLocation != null) formDataMap['dist_location'] = distLocation;
      if (distEmail != null) formDataMap['dist_email'] = distEmail;
      if (distDescription != null) formDataMap['dist_description'] = distDescription;
      if (distMinOrderValueRupees != null) formDataMap['dist_min_order_value_rupees'] = distMinOrderValueRupees;
      if (distProducts != null) formDataMap['dist_products'] = distProducts;
      if (distExpectedDeliveryTimeDays != null) formDataMap['dist_expected_delivery_time_days'] = distExpectedDeliveryTimeDays;
      if (paymentTerms != null) formDataMap['payment_terms'] = paymentTerms;
      if (bankName != null) formDataMap['bank_name'] = bankName;
      if (bankAcNo != null) formDataMap['bank_ac_no'] = bankAcNo;
      if (branchName != null) formDataMap['branch_name'] = branchName;
      if (ifscCode != null) formDataMap['ifsc_code'] = ifscCode;
      if (deliveryTerritories != null) formDataMap['delivery_territories'] = deliveryTerritories;

      // Add photo if provided
      if (photoBytes != null && photoFileName != null) {
        formDataMap['dist_photo'] = MultipartFile.fromBytes(
          photoBytes,
          filename: photoFileName,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.put(
        ApiUrl.distributorUpdateById(distId),
        data: formData,
      );

      return Distributor.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Delete a Distributor by ID
  Future<Map<String, dynamic>> deleteDistributor(String distId) async {
    try {
      final response = await _dio.delete(
        ApiUrl.distributorDeleteById(distId),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handle Dio exceptions and convert them to user-friendly error messages
  String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timeout. Please check your internet connection.';

      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';

      case DioExceptionType.badResponse:
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          final message = e.response!.data?['detail'] ??
              e.response!.data?['message'] ??
              'An error occurred';
          return 'Error $statusCode: $message';
        }
        return 'An error occurred on the server.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Certificate error. Please check your connection.';

      case DioExceptionType.unknown:
        return 'An unexpected error occurred: ${e.message}';
    }
  }
}
