import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/chemist_shop/mr_chemist_shop.dart';
import '../api_url.dart';

class MRChemistShopServices {
  final Dio _dio;

  MRChemistShopServices()
      : _dio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl)) {
    _dio.interceptors.add(PrettyDioLogger());
  }

  Future<List<MRChemistShop>> getAllShops() async {
    final response = await _dio.get(ApiUrl.mrChemistShopGetAll);
    final data = response.data as List;
    return data.map((e) => _fromJson(e)).toList();
  }

  Future<List<MRChemistShop>> getShopsByMR(String mrId) async {
    final response = await _dio.get(ApiUrl.mrChemistShopGetByMR(mrId));
    final data = response.data as List;
    return data.map((e) => _fromJson(e)).toList();
  }

  Future<MRChemistShop> getShopByMRAndShop(String mrId, String shopId) async {
    final response = await _dio.get(ApiUrl.mrChemistShopGetByMRAndShop(mrId, shopId));
    return _fromJson(response.data);
  }

  Future<MRChemistShop> getShopByShopId(String shopId) async {
    final response = await _dio.get(ApiUrl.mrChemistShopGetByShopId(shopId));
    return _fromJson(response.data);
  }

  MRChemistShop _fromJson(Map<String, dynamic> json) {
    final baseUrl = ApiUrl.baseUrl;
    final photoPath = json['photo'] ?? '';
    final shopPhoto = photoPath.isNotEmpty && !photoPath.startsWith('http')
        ? '$baseUrl/$photoPath'
        : photoPath;
    final bankPassbookPath = json['bank_passbook_photo'] ?? '';
    final bankPassbookPhoto = bankPassbookPath.isNotEmpty && !bankPassbookPath.startsWith('http')
        ? '$baseUrl/$bankPassbookPath'
        : bankPassbookPath;
    return MRChemistShop(
      id: json['shop_id'] ?? '',
      shopPhoto: shopPhoto,
      shopName: json['shop_name'] ?? '',
      shopPhone: json['phone_no'] ?? '',
      shopEmail: json['email'] ?? '',
      location: json['address'] ?? '',
      description: json['description'] ?? '',
      doctorName: '', // Not present in backend response
      doctorPhone: '', // Not present in backend response
      mrAddedBy: json['mr_id'] ?? '',
      mrAddedById: json['mr_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      bankPassbookPhoto: bankPassbookPhoto,
    );
  }
}
