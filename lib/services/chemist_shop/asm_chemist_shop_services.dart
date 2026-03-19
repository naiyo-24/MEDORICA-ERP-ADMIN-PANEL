import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/chemist_shop/asm_chemist_shop.dart';
import '../api_url.dart';

class ASMChemistShopServices {
  final Dio _dio;

  ASMChemistShopServices()
      : _dio = Dio()
        ..interceptors.add(PrettyDioLogger());

  Future<List<ASMChemistShop>> getAllASMShops() async {
    final url = ApiUrl.baseUrl + ApiUrl.asmChemistShopGetAll;
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<List<ASMChemistShop>> getASMShopsByAsmId(String asmId) async {
    final url = ApiUrl.baseUrl + ApiUrl.asmChemistShopGetByAsm(asmId);
    final response = await _dio.get(url);
    final data = response.data as List;
    return data.map((json) => _fromJson(json)).toList();
  }

  Future<ASMChemistShop> getASMShopByAsmAndShopId(String asmId, String shopId) async {
    final url = ApiUrl.baseUrl + ApiUrl.asmChemistShopGetByAsmAndShop(asmId, shopId);
    final response = await _dio.get(url);
    return _fromJson(response.data);
  }

  Future<ASMChemistShop> getASMShopByShopId(String shopId) async {
    final url = ApiUrl.baseUrl + ApiUrl.asmChemistShopGetByShopId(shopId);
    final response = await _dio.get(url);
    return _fromJson(response.data);
  }

  ASMChemistShop _fromJson(Map<String, dynamic> json) {
    return ASMChemistShop(
      id: json['shop_id'] ?? '',
      shopPhoto: json['photo'] ?? '',
      shopName: json['shop_name'] ?? '',
      shopPhone: json['phone_no'] ?? '',
      shopEmail: json['email'] ?? '',
      location: json['address'] ?? '',
      description: json['description'] ?? '',
      doctorName: '', // Doctor info not in response
      doctorPhone: '',
      asmAddedBy: json['asm_id'] ?? '',
      asmAddedById: json['asm_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      bankPassbookPhoto: json['bank_passbook_photo'],
    );
  }
}
