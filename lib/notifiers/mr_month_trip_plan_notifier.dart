import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/mr.dart';
import '../models/mr_month_trip_plan.dart';
import '../providers/mr_onboarding_provider.dart';

class MRMonthTripPlanState {
  const MRMonthTripPlanState({
    this.tripPlans = const [],
    this.selectedMRId = '',
    this.selectedDate,
  });

  final List<MRMonthTripPlan> tripPlans;
  final String selectedMRId;
  final DateTime? selectedDate;

  MRMonthTripPlanState copyWith({
    List<MRMonthTripPlan>? tripPlans,
    String? selectedMRId,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
  }) {
    return MRMonthTripPlanState(
      tripPlans: tripPlans ?? this.tripPlans,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),
    );
  }

  List<MRMonthTripPlan> get filteredPlans {
    final items = tripPlans.where((plan) {
      final byMR = selectedMRId.isEmpty || plan.mrId == selectedMRId;
      final byDate =
          selectedDate == null || _isSameDate(plan.date, selectedDate!);
      return byMR && byDate;
    }).toList();

    items.sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class MRMonthTripPlanNotifier extends Notifier<MRMonthTripPlanState> {
  @override
  MRMonthTripPlanState build() {
    return MRMonthTripPlanState(tripPlans: _mockPlans());
  }

  void setSelectedMRId(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
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
    required String mrId,
    required DateTime date,
    required TimeOfDay time,
    required String description,
  }) {
    final mr = _findMR(mrId);
    if (mr == null) {
      return;
    }

    final item = MRTripPlanItem(
      id: 'mr_plan_item_${DateTime.now().microsecondsSinceEpoch}',
      time: time,
      description: description,
    );

    _upsertTripPlanItem(
      mrId: mr.mrId,
      mrName: mr.name,
      date: DateTime(date.year, date.month, date.day),
      item: item,
    );
  }

  void updateTripPlanItem({
    required String previousGroupId,
    required String itemId,
    required String mrId,
    required DateTime date,
    required TimeOfDay time,
    required String description,
  }) {
    final mr = _findMR(mrId);
    if (mr == null) {
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
      mrId: mr.mrId,
      mrName: mr.name,
      date: DateTime(date.year, date.month, date.day),
      item: MRTripPlanItem(id: itemId, time: time, description: description),
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
    required String mrId,
    required String mrName,
    required DateTime date,
    required MRTripPlanItem item,
  }) {
    final current = [...state.tripPlans];
    final index = current.indexWhere(
      (group) => group.mrId == mrId && _isSameDate(group.date, date),
    );

    if (index == -1) {
      current.add(
        MRMonthTripPlan(
          id: 'mr_plan_${mrId}_${date.year}_${date.month}_${date.day}',
          mrId: mrId,
          mrName: mrName,
          date: date,
          plans: [item],
        ),
      );
    } else {
      final group = current[index];
      final nextItems = [...group.plans.where((p) => p.id != item.id), item]
        ..sort(_compareTime);

      current[index] = group.copyWith(
        mrName: mrName,
        date: date,
        plans: nextItems,
      );
    }

    current.sort((a, b) => a.date.compareTo(b.date));
    state = state.copyWith(tripPlans: current);
  }

  List<MRMonthTripPlan> _mockPlans() {
    final mrs = ref.read(mrOnboardingNotifierProvider).mrList;
    if (mrs.isEmpty) {
      return const [];
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final secondMR = mrs.length > 1 ? mrs[1] : mrs.first;

    return [
      MRMonthTripPlan(
        id: 'mr_plan_${mrs.first.mrId}_${today.year}_${today.month}_${today.day}',
        mrId: mrs.first.mrId,
        mrName: mrs.first.name,
        date: today,
        plans: const [
          MRTripPlanItem(
            id: 'mr_item_1',
            time: TimeOfDay(hour: 10, minute: 0),
            description: 'Visit Apollo Medicos and review stock movement.',
          ),
          MRTripPlanItem(
            id: 'mr_item_2',
            time: TimeOfDay(hour: 13, minute: 30),
            description: 'Doctor follow-up meeting at CarePlus Clinic.',
          ),
        ],
      ),
      MRMonthTripPlan(
        id: 'mr_plan_${secondMR.mrId}_${today.add(const Duration(days: 1)).year}_${today.add(const Duration(days: 1)).month}_${today.add(const Duration(days: 1)).day}',
        mrId: secondMR.mrId,
        mrName: secondMR.name,
        date: today.add(const Duration(days: 1)),
        plans: const [
          MRTripPlanItem(
            id: 'mr_item_3',
            time: TimeOfDay(hour: 9, minute: 45),
            description: 'Morning chemist audit at GreenLine Pharmacy.',
          ),
        ],
      ),
    ];
  }

  MR? _findMR(String mrId) {
    final mrs = ref.read(mrOnboardingNotifierProvider).mrList;
    for (final mr in mrs) {
      if (mr.id == mrId) {
        return mr;
      }
    }
    return null;
  }

  static int _compareTime(MRTripPlanItem a, MRTripPlanItem b) {
    final aValue = a.time.hour * 60 + a.time.minute;
    final bValue = b.time.hour * 60 + b.time.minute;
    return aValue.compareTo(bValue);
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
