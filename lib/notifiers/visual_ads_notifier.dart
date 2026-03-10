import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/visual_ads.dart';
import '../services/visual_ads/visual_ads_services.dart';

class VisualAdsState {
  const VisualAdsState({
    this.ads = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<VisualAd> ads;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  VisualAdsState copyWith({
    List<VisualAd>? ads,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return VisualAdsState(
      ads: ads ?? this.ads,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class VisualAdsNotifier extends Notifier<VisualAdsState> {
  late final VisualAdsService _visualAdsService;

  @override
  VisualAdsState build() {
    _visualAdsService = VisualAdsService();
    // Trigger async fetch without blocking
    Future.microtask(() => _fetchAllAds());
    return const VisualAdsState();
  }

  /// Fetch all visual ads from the server
  Future<void> _fetchAllAds() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ads = await _visualAdsService.getAllVisualAds();
      state = state.copyWith(isLoading: false, ads: ads);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh the list of visual ads
  Future<void> refreshAds() async {
    await _fetchAllAds();
  }

  /// Create a new visual ad
  Future<void> createAd({
    required String name,
    required Uint8List imageBytes,
    required String imageFileName,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final newAd = await _visualAdsService.createVisualAd(
        name: name,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );

      state = state.copyWith(
        isSaving: false,
        ads: [newAd, ...state.ads],
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Update an existing visual ad
  Future<void> updateAd({
    required String adId,
    required String name,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final updatedAd = await _visualAdsService.updateVisualAd(
        adId: adId,
        name: name,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );

      final updatedList = state.ads
          .map((ad) => ad.adId == adId ? updatedAd : ad)
          .toList(growable: false);

      state = state.copyWith(
        isSaving: false,
        ads: updatedList,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// Delete a visual ad
  Future<void> deleteAd(String adId) async {
    state = state.copyWith(error: null);

    try {
      await _visualAdsService.deleteVisualAd(adId);

      state = state.copyWith(
        ads: state.ads.where((ad) => ad.adId != adId).toList(growable: false),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}
