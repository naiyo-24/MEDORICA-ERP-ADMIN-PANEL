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
}
