import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/monthly_target/asm_monthly_target.dart';
import '../../notifiers/monthly_target/asm_monthly_target_notifier.dart';

final asmMonthlyTargetNotifierProvider =
    NotifierProvider<ASMMonthlyTargetNotifier, ASMMonthlyTargetState>(
      ASMMonthlyTargetNotifier.new,
    );

final asmAppliedMonthlyTargetProvider = Provider<ASMMonthlyTarget?>((ref) {
  final state = ref.watch(asmMonthlyTargetNotifierProvider);
  return state.appliedTarget;
});

final asmMonthlyTargetMonthsProvider = Provider<List<int>>((ref) {
  return List<int>.generate(12, (index) => index + 1);
});

final asmMonthlyTargetYearsProvider = Provider<List<int>>((ref) {
  return List<int>.generate(2100 - 2026 + 1, (index) => 2026 + index);
});
