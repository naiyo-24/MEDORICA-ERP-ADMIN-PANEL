import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/visual_ads.dart';

class VisualAdsState {
  const VisualAdsState({this.ads = const [], this.isSaving = false});

  final List<VisualAd> ads;
  final bool isSaving;

  VisualAdsState copyWith({List<VisualAd>? ads, bool? isSaving}) {
    return VisualAdsState(
      ads: ads ?? this.ads,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class VisualAdsNotifier extends Notifier<VisualAdsState> {
  @override
  VisualAdsState build() {
    return VisualAdsState(
      ads: [
        VisualAd(
          id: 'ad_1',
          name: 'Summer Wellness Campaign',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        VisualAd(
          id: 'ad_2',
          name: 'Doctor Connect Awareness',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
    );
  }

  Future<void> createAd({
    required String name,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    state = state.copyWith(isSaving: true);

    final now = DateTime.now();
    final ad = VisualAd(
      id: 'ad_${now.microsecondsSinceEpoch}',
      name: name,
      imageBytes: imageBytes,
      imageFileName: imageFileName,
      createdAt: now,
    );

    state = state.copyWith(isSaving: false, ads: [ad, ...state.ads]);
  }

  Future<void> updateAd({
    required String id,
    required String name,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    state = state.copyWith(isSaving: true);

    final updated = state.ads
        .map((ad) {
          if (ad.id != id) {
            return ad;
          }

          return ad.copyWith(
            name: name,
            imageBytes: imageBytes,
            imageFileName: imageFileName,
          );
        })
        .toList(growable: false);

    state = state.copyWith(isSaving: false, ads: updated);
  }

  void deleteAd(String id) {
    state = state.copyWith(
      ads: state.ads.where((ad) => ad.id != id).toList(growable: false),
    );
  }
}
