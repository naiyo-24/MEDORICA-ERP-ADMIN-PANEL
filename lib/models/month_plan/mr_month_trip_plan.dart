import 'package:flutter/material.dart';

class MRMonthTripPlan {
  const MRMonthTripPlan({
    required this.id,
    required this.mrId,
    required this.mrName,
    required this.date,
    required this.plans,
  });

  final String id;
  final String mrId;
  final String mrName;
  final DateTime date;
  final List<MRTripPlanItem> plans;

  MRMonthTripPlan copyWith({
    String? id,
    String? mrId,
    String? mrName,
    DateTime? date,
    List<MRTripPlanItem>? plans,
  }) {
    return MRMonthTripPlan(
      id: id ?? this.id,
      mrId: mrId ?? this.mrId,
      mrName: mrName ?? this.mrName,
      date: date ?? this.date,
      plans: plans ?? this.plans,
    );
  }
}

class MRTripPlanItem {
  const MRTripPlanItem({
    required this.id,
    required this.time,
    required this.description,
  });

  final String id;
  final TimeOfDay time;
  final String description;

  MRTripPlanItem copyWith({String? id, TimeOfDay? time, String? description}) {
    return MRTripPlanItem(
      id: id ?? this.id,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }
}
