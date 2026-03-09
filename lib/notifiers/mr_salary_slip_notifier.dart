import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mr.dart';
import '../models/mr_salary_slip.dart';
import '../providers/mr_onboarding_provider.dart';

class MRSalarySlipState {
  const MRSalarySlipState({
    this.salarySlips = const [],
    required this.selectedMRId,
    required this.selectedYear,
  });

  final List<MRSalarySlip> salarySlips;
  final String selectedMRId;
  final int selectedYear;

  MRSalarySlipState copyWith({
    List<MRSalarySlip>? salarySlips,
    String? selectedMRId,
    int? selectedYear,
  }) {
    return MRSalarySlipState(
      salarySlips: salarySlips ?? this.salarySlips,
      selectedMRId: selectedMRId ?? this.selectedMRId,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  List<MRSalarySlip> get filteredSlips {
    return salarySlips
        .where((slip) => slip.mrId == selectedMRId && slip.year == selectedYear)
        .toList();
  }
}

class MRSalarySlipNotifier extends Notifier<MRSalarySlipState> {
  @override
  MRSalarySlipState build() {
    final mrList = ref.watch(mrListProvider);
    final firstMRId = mrList.isNotEmpty ? mrList.first.mrId : 'mr_001';
    final currentYear = DateTime.now().year;

    return MRSalarySlipState(
      salarySlips: _generateMockSlips(mrList, currentYear),
      selectedMRId: firstMRId,
      selectedYear: currentYear,
    );
  }

  List<MRSalarySlip> _generateMockSlips(List<MR> mrList, int year) {
    final slips = <MRSalarySlip>[];
    for (final mr in mrList) {
      for (int month = 1; month <= 12; month++) {
        slips.add(
          MRSalarySlip(
            id: '${mr.mrId}_${year}_$month',
            mrId: mr.mrId,
            mrName: mr.name,
            month: month,
            year: year,
          ),
        );
      }
    }
    return slips;
  }

  void setSelectedMR(String mrId) {
    state = state.copyWith(selectedMRId: mrId);
  }

  void setSelectedYear(int year) {
    final mrList = ref.read(mrListProvider);
    final existingForYear = state.salarySlips
        .where((s) => s.year == year)
        .toList();

    if (existingForYear.isEmpty) {
      final newSlips = [...state.salarySlips];
      for (final mr in mrList) {
        for (int month = 1; month <= 12; month++) {
          newSlips.add(
            MRSalarySlip(
              id: '${mr.mrId}_${year}_$month',
              mrId: mr.mrId,
              mrName: mr.name,
              month: month,
              year: year,
            ),
          );
        }
      }
      state = state.copyWith(salarySlips: newSlips, selectedYear: year);
    } else {
      state = state.copyWith(selectedYear: year);
    }
  }

  Future<void> uploadFile({
    required String slipId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final updatedSlips = state.salarySlips.map((slip) {
      if (slip.id == slipId) {
        return slip.copyWith(fileBytes: fileBytes, fileName: fileName);
      }
      return slip;
    }).toList();

    state = state.copyWith(salarySlips: updatedSlips);
  }
}
