import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../models/asm_monthly_target.dart';
import '../providers/asm_onboarding_provider.dart';

class ASMMonthlyTargetState {
  const ASMMonthlyTargetState({
    this.selectedASMId = '',
    this.selectedMonth = 1,
    this.selectedYear = 2026,
    this.appliedTarget,
    this.isApplying = false,
  });

  final String selectedASMId;
  final int selectedMonth;
  final int selectedYear;
  final ASMMonthlyTarget? appliedTarget;
  final bool isApplying;

  ASMMonthlyTargetState copyWith({
    String? selectedASMId,
    int? selectedMonth,
    int? selectedYear,
    ASMMonthlyTarget? appliedTarget,
    bool clearAppliedTarget = false,
    bool? isApplying,
  }) {
    return ASMMonthlyTargetState(
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      appliedTarget: clearAppliedTarget
          ? null
          : appliedTarget ?? this.appliedTarget,
      isApplying: isApplying ?? this.isApplying,
    );
  }

  bool get canApply => selectedASMId.isNotEmpty;
}

class ASMMonthlyTargetNotifier extends Notifier<ASMMonthlyTargetState> {
  @override
  ASMMonthlyTargetState build() {
    final now = DateTime.now();
    final defaultYear = now.year < 2026 ? 2026 : now.year;
    return ASMMonthlyTargetState(
      selectedMonth: now.month,
      selectedYear: defaultYear,
    );
  }

  void setSelectedASM(String asmId) {
    state = state.copyWith(selectedASMId: asmId);
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

    final asmList = ref.read(asmListProvider);
    ASM? selectedASM;
    for (final asm in asmList) {
      if (asm.id == state.selectedASMId) {
        selectedASM = asm;
        break;
      }
    }

    if (selectedASM == null) {
      state = state.copyWith(isApplying: false, clearAppliedTarget: true);
      return;
    }

    final target = _buildMonthlyTarget(
      asm: selectedASM,
      month: state.selectedMonth,
      year: state.selectedYear,
    );

    state = state.copyWith(appliedTarget: target, isApplying: false);
  }

  ASMMonthlyTarget _buildMonthlyTarget({
    required ASM asm,
    required int month,
    required int year,
  }) {
    final totalTarget = asm.monthlyTarget;
    final ratio = _achievementRatio(id: asm.id, month: month, year: year);

    return ASMMonthlyTarget(
      id: 'asm_target_${asm.id}_${year}_$month',
      asmId: asm.id,
      asmName: asm.name,
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
        (month * 29) +
        (year * 19);
    final normalized = (seed % 100) / 100;

    if (selected.isBefore(current)) {
      return 0.68 + (normalized * 0.27);
    }
    if (selected.year == current.year && selected.month == current.month) {
      return 0.38 + (normalized * 0.47);
    }
    return 0.12 + (normalized * 0.25);
  }
}
