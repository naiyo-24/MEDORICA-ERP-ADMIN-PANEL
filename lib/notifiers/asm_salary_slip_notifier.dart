import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/asm.dart';
import '../models/asm_salary_slip.dart';
import '../providers/asm_onboarding_provider.dart';

class ASMSalarySlipState {
  const ASMSalarySlipState({
    this.salarySlips = const [],
    required this.selectedASMId,
    required this.selectedYear,
  });

  final List<ASMSalarySlip> salarySlips;
  final String selectedASMId;
  final int selectedYear;

  ASMSalarySlipState copyWith({
    List<ASMSalarySlip>? salarySlips,
    String? selectedASMId,
    int? selectedYear,
  }) {
    return ASMSalarySlipState(
      salarySlips: salarySlips ?? this.salarySlips,
      selectedASMId: selectedASMId ?? this.selectedASMId,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  List<ASMSalarySlip> get filteredSlips {
    return salarySlips
        .where(
          (slip) => slip.asmId == selectedASMId && slip.year == selectedYear,
        )
        .toList();
  }
}

class ASMSalarySlipNotifier extends Notifier<ASMSalarySlipState> {
  @override
  ASMSalarySlipState build() {
    final asmList = ref.watch(asmListProvider);
    final firstASMId = asmList.isNotEmpty ? asmList.first.asmId : 'asm_001';
    final currentYear = DateTime.now().year;

    return ASMSalarySlipState(
      salarySlips: _generateMockSlips(asmList, currentYear),
      selectedASMId: firstASMId,
      selectedYear: currentYear,
    );
  }

  List<ASMSalarySlip> _generateMockSlips(List<ASM> asmList, int year) {
    final slips = <ASMSalarySlip>[];
    for (final asm in asmList) {
      for (int month = 1; month <= 12; month++) {
        slips.add(
          ASMSalarySlip(
            id: '${asm.asmId}_${year}_$month',
            asmId: asm.asmId,
            asmName: asm.name,
            month: month,
            year: year,
          ),
        );
      }
    }
    return slips;
  }

  void setSelectedASM(String asmId) {
    state = state.copyWith(selectedASMId: asmId);
  }

  void setSelectedYear(int year) {
    final asmList = ref.read(asmListProvider);
    final existingForYear = state.salarySlips
        .where((s) => s.year == year)
        .toList();

    if (existingForYear.isEmpty) {
      final newSlips = [...state.salarySlips];
      for (final asm in asmList) {
        for (int month = 1; month <= 12; month++) {
          newSlips.add(
            ASMSalarySlip(
              id: '${asm.asmId}_${year}_$month',
              asmId: asm.asmId,
              asmName: asm.name,
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
