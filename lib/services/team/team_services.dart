import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/team.dart';
import '../api_url.dart';

class TeamServices {
  TeamServices({Dio? dio}) : _dio = dio ?? _buildDio();

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

  Future<List<Team>> getAllTeams() async {
    final response = await _dio.get(ApiUrl.teamGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(Team.fromJson)
        .toList(growable: false);
  }

  Future<Team> getTeamById(int teamId) async {
    final response = await _dio.get(ApiUrl.teamGetById(teamId));
    return Team.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<Team> createTeam({
    required String name,
    required String description,
    required String whatsappGroupLink,
    required String leaderASMId,
    required List<String> memberMRIds,
  }) async {
    final formData = FormData.fromMap({
      'team_name': name,
      'team_description': description,
      'whatsapp_group_link': whatsappGroupLink,
      'team_leader_asm_id': leaderASMId,
      'team_members_mr_ids': jsonEncode(memberMRIds),
    });

    final response = await _dio.post(ApiUrl.teamPost, data: formData);
    final created = Team.fromJson(Map<String, dynamic>.from(response.data));

    return getTeamById(created.teamIdAsInt);
  }

  Future<Team> updateTeam({
    required int teamId,
    required String name,
    required String description,
    required String whatsappGroupLink,
    required String leaderASMId,
    required List<String> memberMRIds,
  }) async {
    final formData = FormData.fromMap({
      'team_name': name,
      'team_description': description,
      'whatsapp_group_link': whatsappGroupLink,
      'team_leader_asm_id': leaderASMId,
      'team_members_mr_ids': jsonEncode(memberMRIds),
    });

    await _dio.put(ApiUrl.teamUpdateById(teamId), data: formData);
    return getTeamById(teamId);
  }

  Future<void> deleteTeam(int teamId) async {
    await _dio.delete(ApiUrl.teamDeleteById(teamId));
  }
}
