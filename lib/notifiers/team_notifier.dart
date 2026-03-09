import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../models/mr.dart';
import '../models/team.dart';
import '../providers/asm_onboarding_provider.dart';
import '../providers/mr_onboarding_provider.dart';

class TeamState {
  const TeamState({this.teams = const [], this.isSaving = false});

  final List<Team> teams;
  final bool isSaving;

  TeamState copyWith({List<Team>? teams, bool? isSaving}) {
    return TeamState(
      teams: teams ?? this.teams,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class TeamNotifier extends Notifier<TeamState> {
  @override
  TeamState build() {
    final mrList = ref.watch(mrOnboardingNotifierProvider).mrList;
    final asmList = ref.watch(asmOnboardingNotifierProvider).asmList;

    return TeamState(
      teams: _mockTeams(mrList: mrList, asmList: asmList),
    );
  }

  List<Team> _mockTeams({
    required List<MR> mrList,
    required List<ASM> asmList,
  }) {
    if (mrList.isEmpty || asmList.isEmpty) {
      return const [];
    }

    final firstASM = asmList.first;
    final secondASM = asmList.length > 1 ? asmList[1] : asmList.first;

    return [
      Team(
        id: 'team_1',
        name: 'North Growth Squad',
        description:
            'Focused on expanding prescription reach and conversion in priority northern cities with weekly call planning and KPI tracking.',
        whatsappGroupLink: 'https://chat.whatsapp.com/NorthGrowthSquad',
        leaderASMId: firstASM.asmId,
        leaderASMName: firstASM.name,
        members: [
          for (final member in mrList.take(2))
            TeamMemberRef(mrId: member.mrId, mrName: member.name),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Team(
        id: 'team_2',
        name: 'Metro Outreach Unit',
        description:
            'A high-velocity city team designed for doctor engagement, chemist follow-up and fast order movement with same-week closures.',
        whatsappGroupLink: 'https://chat.whatsapp.com/MetroOutreachUnit',
        leaderASMId: secondASM.asmId,
        leaderASMName: secondASM.name,
        members: [
          for (final member in mrList.skip(1).take(2))
            TeamMemberRef(mrId: member.mrId, mrName: member.name),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
    ];
  }

  Future<void> createTeam({
    required String name,
    required String description,
    required String whatsappGroupLink,
    required String leaderASMId,
    required String leaderASMName,
    required List<TeamMemberRef> members,
  }) async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 350));

    final team = Team(
      id: 'team_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      whatsappGroupLink: whatsappGroupLink,
      leaderASMId: leaderASMId,
      leaderASMName: leaderASMName,
      members: members,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(isSaving: false, teams: [team, ...state.teams]);
  }

  Future<void> updateTeam({
    required String id,
    required String name,
    required String description,
    required String whatsappGroupLink,
    required String leaderASMId,
    required String leaderASMName,
    required List<TeamMemberRef> members,
  }) async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 350));

    final updated = state.teams
        .map((team) {
          if (team.id != id) {
            return team;
          }
          return team.copyWith(
            name: name,
            description: description,
            whatsappGroupLink: whatsappGroupLink,
            leaderASMId: leaderASMId,
            leaderASMName: leaderASMName,
            members: members,
          );
        })
        .toList(growable: false);

    state = state.copyWith(isSaving: false, teams: updated);
  }

  void deleteTeam(String teamId) {
    state = state.copyWith(
      teams: state.teams
          .where((team) => team.id != teamId)
          .toList(growable: false),
    );
  }

  void removeMember({required String teamId, required String mrId}) {
    final updated = state.teams
        .map((team) {
          if (team.id != teamId) {
            return team;
          }
          return team.copyWith(
            members: team.members
                .where((member) => member.mrId != mrId)
                .toList(growable: false),
          );
        })
        .toList(growable: false);

    state = state.copyWith(teams: updated);
  }
}
