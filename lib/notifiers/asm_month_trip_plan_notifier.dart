import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../models/asm_month_trip_plan.dart';
import '../providers/asm_onboarding_provider.dart';

class ASMMonthTripPlanState {
  const ASMMonthTripPlanState({
    this.tripPlans = const [],
    this.selectedASMId = '',
    this.selectedDate,
  });

  final List<ASMMonthTripPlan> tripPlans;
  final String selectedASMId;
  final DateTime? selectedDate;

  ASMMonthTripPlanState copyWith({
    List<ASMMonthTripPlan>? tripPlans,
    String? selectedASMId,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return ASMMonthTripPlanState(
      tripPlans: tripPlans ?? this.tripPlans,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),
    );
  }

  List<ASMMonthTripPlan> get filteredPlans {
    final items = tripPlans.where((plan) {
      final byASM = selectedASMId.isEmpty || plan.asmId == selectedASMId;
      final byDate =
          selectedDate == null || _isSameDate(plan.date, selectedDate!);
      return byASM && byDate;
    }).toList();

    items.sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class ASMMonthTripPlanNotifier extends Notifier<ASMMonthTripPlanState> {
  @override
  ASMMonthTripPlanState build() {
    return ASMMonthTripPlanState(tripPlans: _mockPlans());
  }

  void setSelectedASMId(String asmId) {
    state = state.copyWith(selectedASMId: asmId);
  }

  void setSelectedDate(DateTime? date) {
    if (date == null) {
      state = state.copyWith(clearSelectedDate: true);
      return;
    }
    state = state.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
  }

  void addTripPlanItem({
    required String asmId,
    required DateTime date,
    required TimeOfDay time,
    required String description,
  }) {
    final asm = _findASM(asmId);
    if (asm == null) {
      return;
    }

    final item = ASMTripPlanItem(
      id: 'asm_plan_item_${DateTime.now().microsecondsSinceEpoch}',
      time: time,
      description: description,
    );

    _upsertTripPlanItem(
      asmId: asm.id,
      asmName: asm.name,
      date: DateTime(date.year, date.month, date.day),
      item: item,
    );
  }

  void updateTripPlanItem({
    required String previousGroupId,
    required String itemId,
    required String asmId,
    required DateTime date,
    required TimeOfDay time,
    required String description,
  }) {
    final asm = _findASM(asmId);
    if (asm == null) {
      return;
    }

    final current = [...state.tripPlans];
    final previousIndex = current.indexWhere(
      (group) => group.id == previousGroupId,
    );
    if (previousIndex != -1) {
      final previousGroup = current[previousIndex];
      final nextItems = previousGroup.plans
          .where((p) => p.id != itemId)
          .toList();
      if (nextItems.isEmpty) {
        current.removeAt(previousIndex);
      } else {
        current[previousIndex] = previousGroup.copyWith(plans: nextItems);
      }
    }

    state = state.copyWith(tripPlans: current);

    _upsertTripPlanItem(
      asmId: asm.id,
      asmName: asm.name,
      date: DateTime(date.year, date.month, date.day),
      item: ASMTripPlanItem(id: itemId, time: time, description: description),
    );
  }

  void deleteTripPlanItem({required String groupId, required String itemId}) {
    final current = [...state.tripPlans];
    final groupIndex = current.indexWhere((group) => group.id == groupId);
    if (groupIndex == -1) {
      return;
    }

    final group = current[groupIndex];
    final nextItems = group.plans.where((p) => p.id != itemId).toList();

    if (nextItems.isEmpty) {
      current.removeAt(groupIndex);
    } else {
      current[groupIndex] = group.copyWith(plans: nextItems);
    }

    state = state.copyWith(tripPlans: current);
  }

  void _upsertTripPlanItem({
    required String asmId,
    required String asmName,
    required DateTime date,
    required ASMTripPlanItem item,
  }) {
    final current = [...state.tripPlans];
    final index = current.indexWhere(
      (group) => group.asmId == asmId && _isSameDate(group.date, date),
    );

    if (index == -1) {
      current.add(
        ASMMonthTripPlan(
          id: 'asm_plan_${asmId}_${date.year}_${date.month}_${date.day}',
          asmId: asmId,
          asmName: asmName,
          date: date,
          plans: [item],
        ),
      );
    } else {
      final group = current[index];
      final nextItems = [...group.plans.where((p) => p.id != item.id), item]
        ..sort(_compareTime);

      current[index] = group.copyWith(
        asmName: asmName,
        date: date,
        plans: nextItems,
      );
    }

    current.sort((a, b) => a.date.compareTo(b.date));
    state = state.copyWith(tripPlans: current);
  }

  List<ASMMonthTripPlan> _mockPlans() {
    final asms = ref.read(asmOnboardingNotifierProvider).asmList;
    if (asms.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final secondASM = asms.length > 1 ? asms[1] : asms.first;

    return [
      ASMMonthTripPlan(
        id: 'asm_plan_${asms.first.id}_${today.year}_${today.month}_${today.day}',
        asmId: asms.first.id,
        asmName: asms.first.name,
        date: today,
        plans: const [
          ASMTripPlanItem(
            id: 'asm_item_1',
            time: TimeOfDay(hour: 10, minute: 30),
            description: 'Review MR field visits and coaching checkpoints.',
          ),
          ASMTripPlanItem(
            id: 'asm_item_2',
            time: TimeOfDay(hour: 15, minute: 0),
            description: 'Meet distributor for month dispatch planning.',
          ),
        ],
      ),
      ASMMonthTripPlan(
        id: 'asm_plan_${secondASM.id}_${today.add(const Duration(days: 2)).year}_${today.add(const Duration(days: 2)).month}_${today.add(const Duration(days: 2)).day}',
        asmId: secondASM.id,
        asmName: secondASM.name,
        date: today.add(const Duration(days: 2)),
        plans: const [
          ASMTripPlanItem(
            id: 'asm_item_3',
            time: TimeOfDay(hour: 9, minute: 0),
            description: 'Cluster chemist route review and team briefing.',
          ),
        ],
      ),
    ];
  }

  ASM? _findASM(String asmId) {
    final asms = ref.read(asmOnboardingNotifierProvider).asmList;
    for (final asm in asms) {
      if (asm.id == asmId) {
        return asm;
      }
    }
    return null;
  }

  static int _compareTime(ASMTripPlanItem a, ASMTripPlanItem b) {
    final aValue = a.time.hour * 60 + a.time.minute;
    final bValue = b.time.hour * 60 + b.time.minute;
    return aValue.compareTo(bValue);
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
