import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../models/doctor_network/asm_doctor_network.dart';
import '../../api_url.dart';

class ASMDoctorNetworkServices {
  final Dio _dio;

  ASMDoctorNetworkServices()
      : _dio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl)) {
    _dio.interceptors.add(PrettyDioLogger());
  }

  Future<List<ASMDoctorNetwork>> getAllDoctors() async {
    final response = await _dio.get(ApiUrl.asmDoctorNetworkGetAll);
    final data = response.data as List;
    return data.map((e) => _fromJson(e)).toList();
  }

  Future<List<ASMDoctorNetwork>> getDoctorsByASM(String asmId) async {
    final response = await _dio.get(ApiUrl.asmDoctorNetworkGetByAsm(asmId));
    final data = response.data as List;
    return data.map((e) => _fromJson(e)).toList();
  }

  Future<ASMDoctorNetwork> getDoctorByASMAndDoctor(String asmId, String doctorId) async {
    final response = await _dio.get(ApiUrl.asmDoctorNetworkGetByAsmAndDoctor(asmId, doctorId));
    return _fromJson(response.data);
  }

  ASMDoctorNetwork _fromJson(Map<String, dynamic> json) {
    return ASMDoctorNetwork(
      id: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      phone: json['doctor_phone_no'] ?? '',
      email: json['doctor_email'] ?? '',
      address: json['doctor_address'] ?? '',
      specialization: json['doctor_specialization'] ?? '',
      experience: double.tryParse(json['doctor_experience']?.toString() ?? '0') ?? 0,
      qualification: json['doctor_qualification'] ?? '',
      description: json['doctor_description'] ?? '',
      chambers: (json['doctor_chambers'] as List?)?.map((c) => Chamber(
        name: c['name'] ?? '',
        address: c['address'] ?? '',
        phone: c['phone'] ?? '',
      )).toList() ?? [],
      asmAddedBy: json['asm_id'] ?? '',
      asmAddedById: json['asm_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
