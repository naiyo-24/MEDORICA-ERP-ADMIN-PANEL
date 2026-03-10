import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gift.dart';
import '../services/gift/gift_inventory_services.dart';

class GiftState {
  const GiftState({
    this.gifts = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<Gift> gifts;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  GiftState copyWith({
    List<Gift>? gifts,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return GiftState(
      gifts: gifts ?? this.gifts,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class GiftNotifier extends Notifier<GiftState> {
  late final GiftInventoryService _service;

  @override
  GiftState build() {
    _service = GiftInventoryService();
    Future.microtask(fetchGifts);
    return const GiftState();
  }

  Future<void> fetchGifts() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final gifts = await _service.getAllGifts();
      state = state.copyWith(isLoading: false, gifts: gifts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addGift({
    required String itemName,
    required String description,
    required int quantityInInventory,
    required double price,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final created = await _service.createGift(
        itemName: itemName,
        description: description,
        quantityInInventory: quantityInInventory,
        price: price,
      );

      state = state.copyWith(
        isSaving: false,
        gifts: [created, ...state.gifts],
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> updateGift({
    required int giftId,
    required String itemName,
    required String description,
    required int quantityInInventory,
    required double price,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      final updatedGift = await _service.updateGift(
        giftId: giftId,
        itemName: itemName,
        description: description,
        quantityInInventory: quantityInInventory,
        price: price,
      );

      final updated = state.gifts
          .map((g) => g.giftId == giftId ? updatedGift : g)
          .toList(growable: false);
      state = state.copyWith(gifts: updated, isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteGift({required int giftId}) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _service.deleteGift(giftId);
      state = state.copyWith(
        gifts: state.gifts.where((g) => g.giftId != giftId).toList(),
        isSaving: false,
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      rethrow;
    }
  }
}
