import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr.dart';
import '../models/mr_monthly_target.dart';
import '../providers/mr_onboarding_provider.dart';

class MRMonthlyTargetState {
  const MRMonthlyTargetState({
    this.selectedMRId = '',
    this.selectedMonth = 1,
    this.selectedYear = 2026,
    this.appliedTarget,
    this.isApplying = false,
  });

  final String selectedMRId;
  final int selectedMonth;
  final int selectedYear;
  final MRMonthlyTarget? appliedTarget;
  final bool isApplying;

  MRMonthlyTargetState copyWith({
    String? selectedMRId,
    int? selectedMonth,
    int? selectedYear,
    MRMonthlyTarget? appliedTarget,
    bool clearAppliedTarget = false,
    bool? isApplying,
  }) {
    return MRMonthlyTargetState(
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      appliedTarget: clearAppliedTarget
          ? null
          : appliedTarget ?? this.appliedTarget,
      isApplying: isApplying ?? this.isApplying,
    );
  }

  bool get canApply => selectedMRId.isNotEmpty;
}

class MRMonthlyTargetNotifier extends Notifier<MRMonthlyTargetState> {
  @override
  MRMonthlyTargetState build() {
    final now = DateTime.now();
    final defaultYear = now.year < 2026 ? 2026 : now.year;
    return MRMonthlyTargetState(
      selectedMonth: now.month,
      selectedYear: defaultYear,
    );
  }

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
  }

  void setSelectedMonth(int month) {
    state = state.copyWith(selectedMonth: month);
  }

  void setSelectedYear(int year) {
    state = state.copyWith(selectedYear: year);
  }

  Future<void> applyFilter() async {
    if (!state.canApply) {
      state = state.copyWith(clearAppliedTarget: true);
      return;
    }

    state = state.copyWith(isApplying: true);

    // Simulate async fetch.
    await Future.delayed(const Duration(milliseconds: 350));

    final mrList = ref.read(mrListProvider);
    MR? selectedMR;
    for (final mr in mrList) {
      if (mr.id == state.selectedMRId) {
        selectedMR = mr;
        break;
      }
    }

    if (selectedMR == null) {
      state = state.copyWith(isApplying: false, clearAppliedTarget: true);
      return;
    }

    final target = _buildMonthlyTarget(
      mr: selectedMR,
      month: state.selectedMonth,
      year: state.selectedYear,
    );

    state = state.copyWith(appliedTarget: target, isApplying: false);
  }

  MRMonthlyTarget _buildMonthlyTarget({
    required MR mr,
    required int month,
    required int year,
  }) {
    final totalTarget = mr.monthlyTarget;
    final ratio = _achievementRatio(id: mr.id, month: month, year: year);

    return MRMonthlyTarget(
      id: 'mr_target_${mr.id}_${year}_$month',
      mrId: mr.id,
      mrName: mr.name,
      month: month,
      year: year,
      totalTarget: totalTarget,
      targetAchieved: totalTarget * ratio,
    );
  }

  double _achievementRatio({
    required String id,
    required int month,
    required int year,
  }) {
    final now = DateTime.now();
    final selected = DateTime(year, month);
    final current = DateTime(now.year, now.month);

    final seed =
        id.codeUnits.fold<int>(0, (acc, v) => acc + v) +
        (month * 31) +
        (year * 17);
    final normalized = (seed % 100) / 100;

    if (selected.isBefore(current)) {
      return 0.65 + (normalized * 0.30);
    }
    if (selected.year == current.year && selected.month == current.month) {
      return 0.35 + (normalized * 0.50);
    }
    return 0.10 + (normalized * 0.25);
  }
}
