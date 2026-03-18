import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/onboarding/asm.dart';
import '../../models/monthly_target/asm_monthly_target.dart';
import '../../providers/monthly_target/asm_monthly_target_provider.dart';
import '../../providers/onboarding/asm_onboarding_provider.dart';
import '../../services/monthly_target/asm_monthly_target_services.dart';

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
  late final ASMMonthlyTargetServices _services;

  @override
  ASMMonthlyTargetState build() {
    _services = ref.read(asmMonthlyTargetServicesProvider);
    final now = DateTime.now();
    final defaultYear = now.year < 2026 ? 2026 : now.year;
    return ASMMonthlyTargetState(
      selectedMonth: now.month,
      selectedYear: defaultYear,
    );
  }

  void setSelectedASM(String asmId) {
    state = state.copyWith(selectedASMId: asmId, appliedTarget: null);
  }

  void setSelectedMonth(int month) {
    state = state.copyWith(selectedMonth: month, appliedTarget: null);
  }

  void setSelectedYear(int year) {
    state = state.copyWith(selectedYear: year, appliedTarget: null);
  }


  Future<void> applyFilter() async {
    if (!state.canApply) {
      state = state.copyWith(clearAppliedTarget: true);
      return;
    }

    state = state.copyWith(isApplying: true);

    final asmList = ref.read(asmListProvider);
    ASM? selectedASM;
    for (final asm in asmList) {
      if (asm.asmId == state.selectedASMId) {
        selectedASM = asm;
        break;
      }
    }

    if (selectedASM == null) {
      state = state.copyWith(isApplying: false, clearAppliedTarget: true);
      return;
    }

    try {
      final target = await _services.getByAsmYearMonth(
        selectedASM.asmId,
        state.selectedYear,
        state.selectedMonth,
      );
      if (target == null) {
        // If no data found, clear the card
        state = state.copyWith(appliedTarget: null, isApplying: false);
      } else {
        state = state.copyWith(appliedTarget: target, isApplying: false);
      }
    } catch (e) {
      state = state.copyWith(isApplying: false, clearAppliedTarget: true);
    }
  }

}
