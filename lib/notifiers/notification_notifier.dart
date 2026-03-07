import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';

class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.selectedAudience = NotificationAudience.all,
  });

  final List<AppNotification> notifications;
  final NotificationAudience selectedAudience;

  NotificationState copyWith({
    List<AppNotification>? notifications,
    NotificationAudience? selectedAudience,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      selectedAudience: selectedAudience ?? this.selectedAudience,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    return NotificationState(
      notifications: [
        AppNotification(
          id: 'noti_1',
          title: 'Target Reminder: Zone East',
          message: 'MRs must submit this week\'s doctor coverage before 6 PM.',
          audience: NotificationAudience.mr,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        AppNotification(
          id: 'noti_2',
          title: 'ASM Review Call',
          message:
              'Monthly review call has been scheduled for tomorrow 10:30 AM.',
          audience: NotificationAudience.asm,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        AppNotification(
          id: 'noti_3',
          title: 'Distributor Lead Follow-up',
          message:
              'MR team to follow up with 3 pending distributor onboarding leads.',
          audience: NotificationAudience.mr,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isUnread: false,
        ),
        AppNotification(
          id: 'noti_4',
          title: 'ASM Field Movement Update',
          message: 'Submit branch-wise travel status before daily close.',
          audience: NotificationAudience.asm,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          isUnread: false,
        ),
      ],
    );
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
    final now = DateTime.now();
    final item = AppNotification(
      id: 'noti_${now.microsecondsSinceEpoch}',
      title: title,
      message: message,
      audience: audience,
      createdAt: now,
      isUnread: true,
    );

    state = state.copyWith(notifications: [item, ...state.notifications]);
  }

  void deleteNotification(String id) {
    state = state.copyWith(
      notifications: state.notifications
          .where((item) => item.id != id)
          .toList(growable: false),
    );
  }
}
