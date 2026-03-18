import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/salary_slip/asm_salary_slip.dart';
import '../../notifiers/salary_slip/asm_salary_slip_notifier.dart';
import '../../services/salary_slip/asm_salary_slip_services.dart';

final asmSalarySlipServicesProvider = Provider<ASMSalarySlipServices>((ref) {
  return ASMSalarySlipServices();
});

final asmSalarySlipNotifierProvider =
    NotifierProvider<ASMSalarySlipNotifier, ASMSalarySlipState>(
      ASMSalarySlipNotifier.new,
    );

final asmSalarySlipListProvider = Provider<List<ASMSalarySlip>>((ref) {
  return ref.watch(asmSalarySlipNotifierProvider).salarySlips;
});

final asmSalarySlipCountProvider = Provider<int>((ref) {
  return ref.watch(asmSalarySlipListProvider).length;
});

final asmSalarySlipLoadingProvider = Provider<bool>((ref) {
  return ref.watch(asmSalarySlipNotifierProvider).isLoading;
});

final asmSalarySlipSavingProvider = Provider<bool>((ref) {
  return ref.watch(asmSalarySlipNotifierProvider).isSaving;
});

final asmSalarySlipErrorProvider = Provider<String?>((ref) {
  return ref.watch(asmSalarySlipNotifierProvider).error;
});
