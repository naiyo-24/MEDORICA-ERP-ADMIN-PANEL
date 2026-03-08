import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gift.dart';

class GiftState {
  const GiftState({this.gifts = const [], this.isSaving = false});

  final List<Gift> gifts;
  final bool isSaving;

  GiftState copyWith({List<Gift>? gifts, bool? isSaving}) {
    return GiftState(
      gifts: gifts ?? this.gifts,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class GiftNotifier extends Notifier<GiftState> {
  @override
  GiftState build() {
    return GiftState(gifts: _mockGifts());
  }

  List<Gift> _mockGifts() {
    final now = DateTime.now();
    return [
      Gift(
        id: 'gift_1',
        itemName: 'Premium Pen Set',
        description:
            'Executive metal pen set for doctor engagement activities.',
        quantityInInventory: 120,
        price: 499,
        createdAt: now.subtract(const Duration(days: 18)),
      ),
      Gift(
        id: 'gift_2',
        itemName: 'Desk Calendar',
        description: 'Branded yearly desk calendar with product highlights.',
        quantityInInventory: 280,
        price: 149,
        createdAt: now.subtract(const Duration(days: 12)),
      ),
      Gift(
        id: 'gift_3',
        itemName: 'Conference Bag',
        description: 'Utility conference bag for events and CME participation.',
        quantityInInventory: 64,
        price: 999,
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  Future<void> addGift({required Gift gift}) async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(gifts: [gift, ...state.gifts], isSaving: false);
  }

  Future<void> updateGift({required Gift gift}) async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 300));
    final updated = state.gifts.map((g) => g.id == gift.id ? gift : g).toList();
    state = state.copyWith(gifts: updated, isSaving: false);
  }

  Future<void> deleteGift({required String giftId}) async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 250));
    state = state.copyWith(
      gifts: state.gifts.where((g) => g.id != giftId).toList(),
      isSaving: false,
    );
  }
}
