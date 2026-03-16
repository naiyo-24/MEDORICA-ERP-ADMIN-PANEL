
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mr_salary_slip.dart';
import '../notifiers/mr_salary_slip_notifier.dart';
import '../services/salary_slip/mr_salary_slip_services.dart';


final mrSalarySlipServicesProvider = Provider<MRSalarySlipServices>((ref) {
  return MRSalarySlipServices();
});

final mrSalarySlipNotifierProvider =
    NotifierProvider<MRSalarySlipNotifier, MRSalarySlipState>(
      MRSalarySlipNotifier.new,
    );

final mrSalarySlipListProvider = Provider<List<MRSalarySlip>>((ref) {
  return ref.watch(mrSalarySlipNotifierProvider).salarySlips;
});

final mrSalarySlipCountProvider = Provider<int>((ref) {
  return ref.watch(mrSalarySlipListProvider).length;
});

final mrSalarySlipLoadingProvider = Provider<bool>((ref) {
  return ref.watch(mrSalarySlipNotifierProvider).isLoading;
});

final mrSalarySlipSavingProvider = Provider<bool>((ref) {
  return ref.watch(mrSalarySlipNotifierProvider).isSaving;
});

final mrSalarySlipErrorProvider = Provider<String?>((ref) {
  return ref.watch(mrSalarySlipNotifierProvider).error;
});
