import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/salary_slip/mr_salary_slip.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';
import '../../providers/salary_slip/mr_salary_slip_provider.dart';

class MRSalarySlipState {
  const MRSalarySlipState({
    this.salarySlips = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<MRSalarySlip> salarySlips;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  MRSalarySlipState copyWith({
    List<MRSalarySlip>? salarySlips,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return MRSalarySlipState(
      salarySlips: salarySlips ?? this.salarySlips,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class MRSalarySlipNotifier extends Notifier<MRSalarySlipState> {
  @override
  MRSalarySlipState build() {
    return const MRSalarySlipState();
  }

  Future<void> loadSalarySlips() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final mrNotifier = ref.read(mrOnboardingNotifierProvider.notifier);
      if (ref.read(mrOnboardingNotifierProvider).mrList.isEmpty) {
        await mrNotifier.loadMRList();
      }
      final mrList = ref.read(mrOnboardingNotifierProvider).mrList;
      final services = ref.read(mrSalarySlipServicesProvider);
      final slipRows = await services.getAllMRSalarySlips();
      final byMrId = <String, MRSalarySlip>{};
      for (final item in slipRows) {
        byMrId[item.mrId] = item;
      }
      final merged = mrList
          .map((mr) => MRSalarySlip.fromMr(mr).copyWith(
            id: byMrId[mr.mrId]?.id,
            salarySlipUrl: byMrId[mr.mrId]?.salarySlipUrl,
            createdAt: byMrId[mr.mrId]?.createdAt,
            updatedAt: byMrId[mr.mrId]?.updatedAt,
          ))
          .toList(growable: false);
      state = state.copyWith(salarySlips: merged, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load MR salary slips: $e',
      );
    }
  }

  Future<void> uploadFile({
    required String mrId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final services = ref.read(mrSalarySlipServicesProvider);
      MRSalarySlip saved;
      try {
        saved = await services.postMRSalarySlip(
          mrId: mrId,
          fileBytes: fileBytes,
          fileName: fileName,
        );
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          saved = await services.updateMRSalarySlip(
            mrId: mrId,
            fileBytes: fileBytes,
            fileName: fileName,
          );
        } else {
          rethrow;
        }
      }
      final updated = state.salarySlips
          .map((slip) {
            if (slip.mrId == mrId) {
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
      state = state.copyWith(isSaving: false, error: 'Failed to upload salary slip: $e');
    }
  }

  Future<void> deleteSalarySlip(String mrId) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final services = ref.read(mrSalarySlipServicesProvider);
      // Find the slip for this MR to get the id
      final slip = state.salarySlips.firstWhere(
        (s) => s.mrId == mrId,
        orElse: () => MRSalarySlip(
          mrId: mrId,
          mrName: '',
          mrPhone: '',
        ),
      );
      if (slip.id != null) {
        await services.deleteMRSalarySlipById(slip.id!);
      }
      final updated = state.salarySlips
          .map((s) {
            if (s.mrId == mrId) {
              return s.copyWith(clearSlip: true);
            }
            return s;
          })
          .toList(growable: false);
      state = state.copyWith(salarySlips: updated, isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: 'Failed to delete salary slip: $e');
    }
  }
}

// ...existing code...