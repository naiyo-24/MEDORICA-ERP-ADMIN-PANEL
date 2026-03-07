import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_monthly_target.dart';
import '../notifiers/mr_monthly_target_notifier.dart';

final mrMonthlyTargetNotifierProvider =
    NotifierProvider<MRMonthlyTargetNotifier, MRMonthlyTargetState>(
      MRMonthlyTargetNotifier.new,
    );

final mrAppliedMonthlyTargetProvider = Provider<MRMonthlyTarget?>((ref) {
  final state = ref.watch(mrMonthlyTargetNotifierProvider);
  return state.appliedTarget;
});

final monthlyTargetMonthsProvider = Provider<List<int>>((ref) {
  return List<int>.generate(12, (index) => index + 1);
});

final monthlyTargetYearsProvider = Provider<List<int>>((ref) {
  return List<int>.generate(2100 - 2026 + 1, (index) => 2026 + index);
});
