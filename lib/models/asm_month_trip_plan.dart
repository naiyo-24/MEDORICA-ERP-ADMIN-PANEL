import 'package:flutter/material.dart';

class ASMMonthTripPlan {
  const ASMMonthTripPlan({
    required this.id,
    required this.asmId,
    required this.asmName,
    required this.date,
    required this.plans,
  });

  final String id;
  final String asmId;
  final String asmName;
  final DateTime date;
  final List<ASMTripPlanItem> plans;

  ASMMonthTripPlan copyWith({
    String? id,
    String? asmId,
    String? asmName,
    DateTime? date,
    List<ASMTripPlanItem>? plans,
  }) {
    return ASMMonthTripPlan(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      asmName: asmName ?? this.asmName,
      date: date ?? this.date,
      plans: plans ?? this.plans,
    );
  }
}

class ASMTripPlanItem {
  const ASMTripPlanItem({
    required this.id,
    required this.time,
    required this.description,
  });

  final String id;
  final TimeOfDay time;
  final String description;

  ASMTripPlanItem copyWith({String? id, TimeOfDay? time, String? description}) {
    return ASMTripPlanItem(
      id: id ?? this.id,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }
}
