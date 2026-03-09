import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/portfolio.dart';
import '../providers/portfolio_provider.dart';

class PortfolioState {
  const PortfolioState({
    required this.data,
    this.isSaving = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final PortfolioData data;
  final bool isSaving;
  final bool isLoading;
  final String? errorMessage;

  PortfolioState copyWith({
    PortfolioData? data,
    bool? isSaving,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PortfolioState(
      data: data ?? this.data,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class PortfolioNotifier extends Notifier<PortfolioState> {
  @override
  PortfolioState build() {
    return const PortfolioState(data: PortfolioData.empty());
  }

  Future<void> loadPortfolio() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final services = ref.read(portfolioServicesProvider);
      final items = await services.getAllAboutUs();

      if (items.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          data: const PortfolioData.empty(),
        );
        return;
      }

      final latest = items.reduce((current, next) {
        final currentDate = current.updatedAt ?? current.createdAt;
        final nextDate = next.updatedAt ?? next.createdAt;
        if (currentDate == null) {
          return next;
        }
        if (nextDate == null) {
          return current;
        }
        return nextDate.isAfter(currentDate) ? next : current;
      });

      state = state.copyWith(data: latest, isLoading: false);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load portfolio data.',
      );
    }
  }

  Future<void> _upsert(PortfolioData nextData) async {
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final services = ref.read(portfolioServicesProvider);
      final currentId = state.data.id;

      final saved = currentId == null
          ? await services.createAboutUs(nextData)
          : await services.updateAboutUs(aboutUsId: currentId, data: nextData);

      state = state.copyWith(data: saved, isSaving: false);
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save portfolio data.',
      );
      rethrow;
    }
  }

  Future<void> updateDescription(String value) async {
    final nextData = state.data.copyWith(description: value.trim());
    await _upsert(nextData);
  }

  Future<void> updateDirectorMessage(String value) async {
    final nextData = state.data.copyWith(directorMessage: value.trim());
    await _upsert(nextData);
  }

  Future<void> updateContact({
    required String phone,
    required String email,
    required String website,
    required String instagram,
    required String facebook,
    required String linkedin,
  }) async {
    final nextData = state.data.copyWith(
      phone: phone.trim(),
      email: email.trim(),
      website: website.trim(),
      instagram: instagram.trim(),
      facebook: facebook.trim(),
      linkedin: linkedin.trim(),
    );

    await _upsert(nextData);
  }

  Future<void> deletePortfolio() async {
    final id = state.data.id;
    if (id == null) {
      return;
    }

    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await ref.read(portfolioServicesProvider).deleteAboutUs(id);
      state = state.copyWith(
        isSaving: false,
        data: const PortfolioData.empty(),
      );
    } catch (error) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to delete portfolio data.',
      );
      rethrow;
    }
  }
}
