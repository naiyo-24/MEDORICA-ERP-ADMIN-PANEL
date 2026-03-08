import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm_salary_slip.dart';
import '../notifiers/asm_salary_slip_notifier.dart';

final asmSalarySlipNotifierProvider =
    NotifierProvider<ASMSalarySlipNotifier, ASMSalarySlipState>(
      ASMSalarySlipNotifier.new,
    );

final asmSalarySlipListProvider = Provider<List<ASMSalarySlip>>((ref) {
  return ref.watch(asmSalarySlipNotifierProvider).filteredSlips;
});

final asmSalarySlipCountProvider = Provider<int>((ref) {
  return ref.watch(asmSalarySlipListProvider).length;
});
