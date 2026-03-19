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
      id: json['id'] as int? ?? 0,
      asmId: json['asm_id'] as String? ?? '',
      doctorId: json['doctor_id'] as String? ?? '',
      doctorName: json['doctor_name'] as String? ?? '',
      doctorBirthday: json['doctor_birthday'] as String?,
      specialization: json['doctor_specialization'] as String? ?? '',
      qualification: json['doctor_qualification'] as String?,
      experience: json['doctor_experience']?.toString(),
      description: json['doctor_description'] as String?,
      photo: json['doctor_photo'] as String?,
      chambers: (json['doctor_chambers'] as List?)?.map((c) => Chamber.fromJson(c as Map<String, dynamic>)).toList(),
      phoneNo: json['doctor_phone_no'] as String? ?? '',
      email: json['doctor_email'] as String?,
      address: json['doctor_address'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
}
