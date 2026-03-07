enum NotificationAudience { all, mr, asm }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.createdAt,
    this.isUnread = true,
  });

  final String id;
  final String title;
  final String message;
  final NotificationAudience audience;
  final DateTime createdAt;
  final bool isUnread;

  String get audienceLabel {
    switch (audience) {
      case NotificationAudience.mr:
        return 'MR';
      case NotificationAudience.asm:
        return 'ASM';
      case NotificationAudience.all:
        return 'All';
    }
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationAudience? audience,
    DateTime? createdAt,
    bool? isUnread,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      createdAt: createdAt ?? this.createdAt,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}
