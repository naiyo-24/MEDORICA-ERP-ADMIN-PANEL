
class Activity {
	final String slot;
	final String type;
	final String? location;
	final String? notes;

	Activity({
		required this.slot,
		required this.type,
		this.location,
		this.notes,
	});

	factory Activity.fromJson(Map<String, dynamic> json) => Activity(
				slot: json['slot'] ?? '',
				type: json['type'] ?? '',
				location: json['location'],
				notes: json['notes'],
			);

	Map<String, dynamic> toJson() => {
				'slot': slot,
				'type': type,
				'location': location,
				'notes': notes,
			};
}

class MemberDayPlan {
	final String mrId;
	final String? mrName;
	final List<Activity> activities;

	MemberDayPlan({
		required this.mrId,
		this.mrName,
		required this.activities,
	});

	factory MemberDayPlan.fromJson(Map<String, dynamic> json) => MemberDayPlan(
				mrId: json['mr_id'] ?? '',
				mrName: json['mr_name'],
				activities: (json['activities'] as List?)?.map((e) => Activity.fromJson(e)).toList() ?? [],
			);

	Map<String, dynamic> toJson() => {
				'mr_id': mrId,
				'mr_name': mrName,
				'activities': activities.map((e) => e.toJson()).toList(),
			};
}

class MonthlyPlan {
	final int id;
	final String asmId;
	final int teamId;
	final DateTime planDate;
	final String status;
	final List<MemberDayPlan> memberDayPlans;
	final DateTime createdAt;
	final DateTime updatedAt;

	MonthlyPlan({
		required this.id,
		required this.asmId,
		required this.teamId,
		required this.planDate,
		required this.status,
		required this.memberDayPlans,
		required this.createdAt,
		required this.updatedAt,
	});

	factory MonthlyPlan.fromJson(Map<String, dynamic> json) => MonthlyPlan(
				id: json['id'],
				asmId: json['asm_id'],
				teamId: json['team_id'],
				planDate: DateTime.parse(json['plan_date']),
				status: json['status'],
				memberDayPlans: (json['member_day_plans'] as List?)?.map((e) => MemberDayPlan.fromJson(e)).toList() ?? [],
				createdAt: DateTime.parse(json['created_at']),
				updatedAt: DateTime.parse(json['updated_at']),
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'asm_id': asmId,
				'team_id': teamId,
				'plan_date': planDate.toIso8601String(),
				'status': status,
				'member_day_plans': memberDayPlans.map((e) => e.toJson()).toList(),
				'created_at': createdAt.toIso8601String(),
				'updated_at': updatedAt.toIso8601String(),
			};
}

class MRDayPlanResponse {
	final int id;
	final String asmId;
	final int teamId;
	final DateTime planDate;
	final String status;
	final MemberDayPlan mrPlan;
	final DateTime createdAt;
	final DateTime updatedAt;

	MRDayPlanResponse({
		required this.id,
		required this.asmId,
		required this.teamId,
		required this.planDate,
		required this.status,
		required this.mrPlan,
		required this.createdAt,
		required this.updatedAt,
	});

	factory MRDayPlanResponse.fromJson(Map<String, dynamic> json) => MRDayPlanResponse(
				id: json['id'],
				asmId: json['asm_id'],
				teamId: json['team_id'],
				planDate: DateTime.parse(json['plan_date']),
				status: json['status'],
				mrPlan: MemberDayPlan.fromJson(json['mr_plan']),
				createdAt: DateTime.parse(json['created_at']),
				updatedAt: DateTime.parse(json['updated_at']),
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'asm_id': asmId,
				'team_id': teamId,
				'plan_date': planDate.toIso8601String(),
				'status': status,
				'mr_plan': mrPlan.toJson(),
				'created_at': createdAt.toIso8601String(),
				'updated_at': updatedAt.toIso8601String(),
			};
}
