enum NotificationAudience { all, mr, asm }

extension NotificationAudienceX on NotificationAudience {
  String get apiValue {
    switch (this) {
      case NotificationAudience.mr:
        return 'mr';
      case NotificationAudience.asm:
        return 'asm';
      case NotificationAudience.all:
        return 'all';
    }
  }

  static NotificationAudience fromApiValue(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'mr':
        return NotificationAudience.mr;
      case 'asm':
        return NotificationAudience.asm;
      default:
        return NotificationAudience.all;
    }
  }
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.audience,
    required this.createdAt,
    this.updatedAt,
    this.isUnread = true,
  });

  final String id;
  final String title;
  final String message;
  final NotificationAudience audience;
  final DateTime createdAt;
  final DateTime? updatedAt;
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
    DateTime? updatedAt,
    bool? isUnread,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isUnread: isUnread ?? this.isUnread,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['sub_title'] ?? '').toString(),
      audience: NotificationAudienceX.fromApiValue(
        json['audience']?.toString(),
      ),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']),
      isUnread: false,
    );
  }

  Map<String, dynamic> toCreateApiMap() {
    return {
      'title': title,
      'sub_title': message,
      'audience': audience.apiValue,
    };
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
