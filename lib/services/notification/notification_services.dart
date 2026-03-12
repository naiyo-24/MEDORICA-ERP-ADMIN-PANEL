import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../models/notification.dart';
import '../api_url.dart';

class NotificationServices {
  NotificationServices({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
        compact: true,
      ),
    );

    return dio;
  }

  Future<List<AppNotification>> getAllNotifications() async {
    final response = await _dio.get(ApiUrl.notificationGetAll);
    final payload = response.data;

    if (payload is! List) {
      return const [];
    }

    final notifications = payload
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList(growable: false);

    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  Future<AppNotification> getNotificationById(int notificationId) async {
    final response = await _dio.get(ApiUrl.notificationGetById(notificationId));
    return AppNotification.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<AppNotification> createNotification({
    required String title,
    required String subTitle,
    required NotificationAudience audience,
  }) async {
    if (audience == NotificationAudience.all) {
      throw ArgumentError('Audience must be MR or ASM for create endpoint.');
    }

    final formMap = <String, dynamic>{
      'title': title.trim(),
      'audience': audience.apiValue,
    };

    final trimmedSubTitle = subTitle.trim();
    if (trimmedSubTitle.isNotEmpty) {
      formMap['sub_title'] = trimmedSubTitle;
    }

    final response = await _dio.post(
      ApiUrl.notificationPost,
      data: FormData.fromMap(formMap),
    );

    return AppNotification.fromJson(
      Map<String, dynamic>.from(response.data),
    ).copyWith(isUnread: true);
  }
}
