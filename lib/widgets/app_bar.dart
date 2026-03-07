import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_theme.dart';

class MedoricaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MedoricaAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
    this.showSubtitle = true,
    this.showBackButton = false,
    this.showMenuButton = false,
    this.showNotification = true,
    this.centerTitle = false,
    this.actions,
    this.onNotificationTap,
    this.onProfileTap,
    this.onMenuTap,
    this.leading,
    this.bottom,
    this.height = 74,
  });

  final String title;
  final String? subtitle;

  // True/false display controls for different screens.
  final bool showLogo;
  final bool showSubtitle;
  final bool showBackButton;
  final bool showMenuButton;
  final bool showNotification;
  final bool centerTitle;

  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double height;

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading:
          leading ??
          (showMenuButton
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    shadowColor: AppColors.shadowColor,
                    elevation: 1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      onTap: onMenuTap,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Iconsax.menu_1,
                          size: 19,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                )
              : showBackButton
              ? IconButton(
                  tooltip: 'Back',
                  icon: const Icon(Iconsax.arrow_left_2, size: 20),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              : null),
      titleSpacing: (showBackButton || showMenuButton) ? 0 : 16,
      title: Row(
        children: [
          if (showLogo) ...[
            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showSubtitle &&
                    subtitle != null &&
                    subtitle!.trim().isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.quaternary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions:
          actions ??
          [
            if (showNotification)
              IconButton(
                tooltip: 'Notifications',
                onPressed: onNotificationTap,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Iconsax.notification, size: 20),
                    Positioned(
                      top: -1,
                      right: -1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: onProfileTap,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Iconsax.user,
                    size: 19,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
      bottom: bottom,
    );
  }
}
