import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/notification.dart';
import '../../theme/app_theme.dart';

class NotificationCards extends StatelessWidget {
  const NotificationCards({
    super.key,
    required this.notifications,
    required this.onTap,
    required this.onDelete,
  });

  final List<AppNotification> notifications;
  final ValueChanged<AppNotification> onTap;
  final ValueChanged<AppNotification> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (notifications.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(
              Iconsax.notification_bing,
              size: 36,
              color: AppColors.quaternary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No notifications for selected filter.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final item in notifications) ...[
          _NotificationCard(
            notification: item,
            onTap: () => onTap(item),
            onDelete: () => onDelete(item),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audienceColor = notification.audience == NotificationAudience.mr
        ? const Color(0xFF2E7D32)
        : const Color(0xFF1565C0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: notification.isUnread
                  ? AppColors.primary
                  : AppColors.border,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Iconsax.notification,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: audienceColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      notification.audienceLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: audienceColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    tooltip: 'Delete notification',
                    onPressed: onDelete,
                    icon: const Icon(
                      Iconsax.trash,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(notification.message, style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(
                    Iconsax.clock,
                    size: 14,
                    color: AppColors.quaternary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    _formatTime(notification.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.quaternary,
                    ),
                  ),
                  const Spacer(),
                  if (notification.isUnread)
                    Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final now = DateTime.now();
    final diff = now.difference(value);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hr ago';
    }
    return '${diff.inDays} day ago';
  }
}
