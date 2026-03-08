import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr_salary_slip.dart';
import '../notifiers/mr_salary_slip_notifier.dart';

final mrSalarySlipNotifierProvider =
    NotifierProvider<MRSalarySlipNotifier, MRSalarySlipState>(
      MRSalarySlipNotifier.new,
    );

final mrSalarySlipListProvider = Provider<List<MRSalarySlip>>((ref) {
  return ref.watch(mrSalarySlipNotifierProvider).filteredSlips;
});

final mrSalarySlipCountProvider = Provider<int>((ref) {
  return ref.watch(mrSalarySlipListProvider).length;
});
