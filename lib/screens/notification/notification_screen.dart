import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/notification/add_notification_card.dart';
import '../../cards/notification/notification_cards.dart';
import '../../models/notification.dart';
import '../../providers/notification_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.notifications,
    );
    if (handled) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemKey module will be available soon.')),
    );
  }

  void _onNotificationTap(AppNotification item) {
    if (item.isUnread) {
      ref.read(notificationNotifierProvider.notifier).markAsRead(item.id);
    }
  }

  Future<void> _openCreateNotificationDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        child: AddNotificationCard(
          onSubmit: (data) async {
            await ref
                .read(notificationNotifierProvider.notifier)
                .createNotification(
                  title: data.title,
                  message: data.message,
                  audience: data.audience,
                );

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification created.')),
              );
            }
          },
        ),
      ),
    );
  }

  void _deleteNotification(AppNotification item) {
    ref.read(notificationNotifierProvider.notifier).deleteNotification(item.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Notification deleted.')));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationNotifierProvider);
    final notifications = ref.watch(filteredNotificationsProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Notifications',
        subtitle: 'Field communication updates for MR and ASM teams',
        showLogo: false,
        showSubtitle: true,
        showMenuButton: true,
        showNotification: false,
        
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: SideNavItemKeys.notifications,
          onItemTap: _onNavTap,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppLayout.screenPadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: _openCreateNotificationDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Iconsax.add,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Create Notification',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuButton<NotificationAudience>(
                        onSelected: (value) => ref
                            .read(notificationNotifierProvider.notifier)
                            .setAudience(value),
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: NotificationAudience.all,
                            child: Text('All Notifications'),
                          ),
                          PopupMenuItem(
                            value: NotificationAudience.mr,
                            child: Text('MR Notifications'),
                          ),
                          PopupMenuItem(
                            value: NotificationAudience.asm,
                            child: Text('ASM Notifications'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColorDark,
                                blurRadius: 14,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Iconsax.filter,
                                size: 16,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                state.selectedAudience ==
                                        NotificationAudience.all
                                    ? 'Filter: All'
                                    : state.selectedAudience ==
                                          NotificationAudience.mr
                                    ? 'Filter: MR'
                                    : 'Filter: ASM',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              const Icon(
                                Iconsax.arrow_down_1,
                                size: 14,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                NotificationCards(
                  notifications: notifications,
                  onTap: _onNotificationTap,
                  onDelete: _deleteNotification,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
