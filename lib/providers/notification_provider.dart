import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification.dart';
import '../notifiers/notification_notifier.dart';
import '../services/notification/notification_services.dart';

final notificationServicesProvider = Provider<NotificationServices>((ref) {
  return NotificationServices();
});

final notificationNotifierProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );

final filteredNotificationsProvider = Provider<List<AppNotification>>((ref) {
  final state = ref.watch(notificationNotifierProvider);

  if (state.selectedAudience == NotificationAudience.all) {
    return state.notifications;
  }

  return state.notifications
      .where((item) => item.audience == state.selectedAudience)
      .toList(growable: false);
});
