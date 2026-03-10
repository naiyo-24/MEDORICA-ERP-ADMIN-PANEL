import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team.dart';
import '../providers/team_provider.dart';
import '../services/team/team_services.dart';

class TeamState {
  const TeamState({
    this.teams = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<Team> teams;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  TeamState copyWith({
    List<Team>? teams,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return TeamState(
      teams: teams ?? this.teams,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class TeamNotifier extends Notifier<TeamState> {
  late final TeamServices _services;

  @override
  TeamState build() {
    _services = ref.read(teamServicesProvider);
    return const TeamState();
  }

  Future<void> loadTeams() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final teams = await _services.getAllTeams();
      state = state.copyWith(teams: teams, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load teams: $e',
      );
    }
  }

  Future<void> createTeam({
    required String name,
    required String description,
    required String whatsappGroupLink,
    required String leaderASMId,
    required List<String> memberMRIds,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final created = await _services.createTeam(
        name: name,
        description: description,
        whatsappGroupLink: whatsappGroupLink,
        leaderASMId: leaderASMId,
        memberMRIds: memberMRIds,
      );
      state = state.copyWith(isSaving: false, teams: [created, ...state.teams]);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create team: $e',
      );
      rethrow;
    }
  }

  Future<void> updateTeam({
    required String teamId,
    required String name,
    required String description,
    required String whatsappGroupLink,
    required String leaderASMId,
    required List<String> memberMRIds,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedTeam = await _services.updateTeam(
        teamId: int.parse(teamId),
        name: name,
        description: description,
        whatsappGroupLink: whatsappGroupLink,
        leaderASMId: leaderASMId,
        memberMRIds: memberMRIds,
      );

      final updatedTeams = state.teams
          .map((team) => team.id == updatedTeam.id ? updatedTeam : team)
          .toList(growable: false);

      state = state.copyWith(isSaving: false, teams: updatedTeams);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update team: $e',
      );
      rethrow;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _services.deleteTeam(int.parse(teamId));
      state = state.copyWith(
        isSaving: false,
        teams: state.teams
            .where((team) => team.id != teamId)
            .toList(growable: false),
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete team: $e',
      );
      rethrow;
    }
  }

  Future<void> removeMember({
    required String teamId,
    required String mrId,
  }) async {
    Team? team;
    for (final item in state.teams) {
      if (item.id == teamId) {
        team = item;
        break;
      }
    }

    if (team == null) {
      return;
    }

    final updatedMemberIds = team.members
        .where((member) => member.mrId != mrId)
        .map((member) => member.mrId)
        .toList(growable: false);

    await updateTeam(
      teamId: teamId,
      name: team.name,
      description: team.description,
      whatsappGroupLink: team.whatsappGroupLink,
      leaderASMId: team.leaderASMId,
      memberMRIds: updatedMemberIds,
    );
  }
}
