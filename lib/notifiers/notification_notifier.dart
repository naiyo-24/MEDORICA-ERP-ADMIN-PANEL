import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';
import '../providers/notification_provider.dart';
import '../services/notification/notification_services.dart';

class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.selectedAudience = NotificationAudience.all,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<AppNotification> notifications;
  final NotificationAudience selectedAudience;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  NotificationState copyWith({
    List<AppNotification>? notifications,
    NotificationAudience? selectedAudience,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      selectedAudience: selectedAudience ?? this.selectedAudience,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  late final NotificationServices _services;

  @override
  NotificationState build() {
    _services = ref.read(notificationServicesProvider);
    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final notifications = await _services.getAllNotifications();
      state = state.copyWith(notifications: notifications, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notifications: $e',
      );
    }
  }

  void setAudience(NotificationAudience audience) {
    state = state.copyWith(selectedAudience: audience);
  }

  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications
          .map((item) => item.id == id ? item.copyWith(isUnread: false) : item)
          .toList(growable: false),
    );
  }

  Future<void> createNotification({
    required String title,
    required String message,
    required NotificationAudience audience,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final created = await _services.createNotification(
        title: title,
        subTitle: message,
        audience: audience,
      );

      state = state.copyWith(
        isSaving: false,
        notifications: [created, ...state.notifications],
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to create notification: $e',
      );
      rethrow;
    }
  }

  void deleteNotification(String id) {
    state = state.copyWith(
      notifications: state.notifications
          .where((item) => item.id != id)
          .toList(growable: false),
    );
  }
}
