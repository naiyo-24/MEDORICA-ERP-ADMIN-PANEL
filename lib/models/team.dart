import 'dart:convert';

class TeamMemberRef {
  const TeamMemberRef({required this.mrId, required this.mrName});

  final String mrId;
  final String mrName;

  TeamMemberRef copyWith({String? mrId, String? mrName}) {
    return TeamMemberRef(
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
    );
  }

  factory TeamMemberRef.fromJson(Map<String, dynamic> json) {
    return TeamMemberRef(
      mrId: (json['mr_id'] ?? '').toString(),
      mrName: (json['full_name'] ?? '').toString(),
    );
  }
}

class Team {
  const Team({
    required this.id,
    required this.name,
    required this.description,
    required this.whatsappGroupLink,
    required this.leaderASMId,
    required this.leaderASMName,
    required this.members,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String description;
  final String whatsappGroupLink;
  final String leaderASMId;
  final String leaderASMName;
  final List<TeamMemberRef> members;
  final DateTime createdAt;

  int get totalMembers => members.length;

  int get teamIdAsInt => int.tryParse(id) ?? 0;

  Team copyWith({
    String? id,
    String? name,
    String? description,
    String? whatsappGroupLink,
    String? leaderASMId,
    String? leaderASMName,
    List<TeamMemberRef>? members,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      whatsappGroupLink: whatsappGroupLink ?? this.whatsappGroupLink,
      leaderASMId: leaderASMId ?? this.leaderASMId,
      leaderASMName: leaderASMName ?? this.leaderASMName,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    final teamMembers = _parseMembers(json['team_members']);
    final teamLeader = json['team_leader'];

    String leaderId = (json['team_leader_asm_id'] ?? '').toString();
    String leaderName = '';

    if (teamLeader is Map<String, dynamic>) {
      leaderId = (teamLeader['asm_id'] ?? leaderId).toString();
      leaderName = (teamLeader['full_name'] ?? '').toString();
    }

    final apiTeamId = _asInt(json['team_id']) ?? _asInt(json['id']) ?? 0;

    return Team(
      id: apiTeamId.toString(),
      name: (json['team_name'] ?? '').toString(),
      description: (json['team_description'] ?? '').toString(),
      whatsappGroupLink: (json['whatsapp_group_link'] ?? '').toString(),
      leaderASMId: leaderId,
      leaderASMName: leaderName,
      members: teamMembers,
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toApiMap() {
    return {
      'team_name': name,
      'team_description': description,
      'whatsapp_group_link': whatsappGroupLink,
      'team_leader_asm_id': leaderASMId,
      'team_members_mr_ids': jsonEncode(
        members.map((member) => member.mrId).toList(growable: false),
      ),
    };
  }

  static List<TeamMemberRef> _parseMembers(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(TeamMemberRef.fromJson)
          .toList(growable: false);
    }
    return const [];
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int? _asInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
