import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding/asm.dart';
import '../models/salary_slip/asm_salary_slip.dart';
import '../providers/asm_onboarding_provider.dart';
import '../providers/asm_salary_slip_provider.dart';

class ASMSalarySlipState {
  const ASMSalarySlipState({
    this.salarySlips = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<ASMSalarySlip> salarySlips;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  ASMSalarySlipState copyWith({
    List<ASMSalarySlip>? salarySlips,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return ASMSalarySlipState(
      salarySlips: salarySlips ?? this.salarySlips,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class ASMSalarySlipNotifier extends Notifier<ASMSalarySlipState> {
  @override
  ASMSalarySlipState build() {
    return const ASMSalarySlipState();
  }

  Future<void> loadSalarySlips() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final asmNotifier = ref.read(asmOnboardingNotifierProvider.notifier);
      if (ref.read(asmOnboardingNotifierProvider).asmList.isEmpty) {
        await asmNotifier.loadASMList();
      }

      final asmList = ref.read(asmOnboardingNotifierProvider).asmList;
      final services = ref.read(asmSalarySlipServicesProvider);
      final slipRows = await services.getAllASMSalarySlips();

      final byAsmId = <String, ASMSalarySlip>{};
      for (final item in slipRows) {
        byAsmId[item.asmId] = item;
      }

      final merged = asmList
          .map((asm) => _mergeAsmWithSlip(asm, byAsmId[asm.asmId]))
          .toList(growable: false);

      state = state.copyWith(salarySlips: merged, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load ASM salary slips: $e',
      );
    }
  }

  Future<void> uploadFile({
    required String asmId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final services = ref.read(asmSalarySlipServicesProvider);
      ASMSalarySlip saved;

      try {
        saved = await services.postASMSalarySlip(
          asmId: asmId,
          fileBytes: fileBytes,
          fileName: fileName,
        );
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          saved = await services.updateASMSalarySlip(
            asmId: asmId,
            fileBytes: fileBytes,
            fileName: fileName,
          );
        } else {
          rethrow;
        }
      }

      final updated = state.salarySlips
          .map((slip) {
            if (slip.asmId == asmId) {
              return slip.copyWith(
                id: saved.id,
                salarySlipUrl: saved.salarySlipUrl,
                createdAt: saved.createdAt,
                updatedAt: saved.updatedAt,
              );
            }
            return slip;
          })
          .toList(growable: false);

      state = state.copyWith(salarySlips: updated, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to upload salary slip: $e',
      );
      rethrow;
    }
  }

  Future<Uint8List> downloadByAsmId(String asmId) async {
    try {
      final services = ref.read(asmSalarySlipServicesProvider);
      return await services.downloadASMSalarySlipByAsmId(asmId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to download salary slip: $e');
      rethrow;
    }
  }

  Future<void> deleteByAsm(ASMSalarySlip salarySlip) async {
    if (salarySlip.id == null) {
      return;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final services = ref.read(asmSalarySlipServicesProvider);
      await services.deleteASMSalarySlipById(salarySlip.id!);

      final updated = state.salarySlips
          .map((slip) {
            if (slip.asmId == salarySlip.asmId) {
              return slip.copyWith(clearSlip: true);
            }
            return slip;
          })
          .toList(growable: false);

      state = state.copyWith(salarySlips: updated, isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to delete salary slip: $e',
      );
      rethrow;
    }
  }

  ASMSalarySlip _mergeAsmWithSlip(ASM asm, ASMSalarySlip? slip) {
    final base = ASMSalarySlip.fromAsm(asm);
    if (slip == null) {
      return base;
    }

    return base.copyWith(
      id: slip.id,
      salarySlipUrl: slip.salarySlipUrl,
      createdAt: slip.createdAt,
      updatedAt: slip.updatedAt,
    );
  }
}
