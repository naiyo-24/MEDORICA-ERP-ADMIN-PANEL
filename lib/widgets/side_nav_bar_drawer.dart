import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../providers/auth_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';

class SideNavItemKeys {
  static const String dashboard = 'dashboard';
  static const String mrOnboarding = 'mr_onboarding';
  static const String asmOnboarding = 'asm_onboarding';
  static const String distributorManagement = 'distributor_management';
  static const String visualAdsManagement = 'visual_ads_management';
  static const String notifications = 'notifications';
  static const String ourPortfolio = 'our_portfolio';
  static const String helpCenter = 'help_center';
  static const String logout = 'logout';
}

class SideNavRouteIndex {
  static const int dashboard = 0;
  static const int mrOnboarding = 1;
  static const int asmOnboarding = 2;
  static const int distributor = 3;
  static const int visualAds = 4;
  static const int notifications = 5;
  static const int portfolio = 6;
  static const int helpCenter = 7;
  static const int logout = 8;
  static const int unhandled = -1;

  static int fromItemKey(String itemKey) {
    switch (itemKey) {
      case SideNavItemKeys.dashboard:
        return dashboard;
      case SideNavItemKeys.mrOnboarding:
        return mrOnboarding;
      case SideNavItemKeys.asmOnboarding:
        return asmOnboarding;
      case SideNavItemKeys.distributorManagement:
        return distributor;
      case SideNavItemKeys.visualAdsManagement:
        return visualAds;
      case SideNavItemKeys.notifications:
        return notifications;
      case SideNavItemKeys.ourPortfolio:
        return portfolio;
      case SideNavItemKeys.helpCenter:
        return helpCenter;
      case SideNavItemKeys.logout:
        return logout;
      default:
        return unhandled;
    }
  }

  static bool handleTap({
    required BuildContext context,
    required WidgetRef ref,
    required String itemKey,
    required String currentItemKey,
  }) {
    final index = fromItemKey(itemKey);

    switch (index) {
      case dashboard:
        if (currentItemKey != SideNavItemKeys.dashboard) {
          context.go(AppRoutePaths.dashboard);
        }
        return true;
      case mrOnboarding:
        if (currentItemKey != SideNavItemKeys.mrOnboarding) {
          context.go(AppRoutePaths.mrOnboarding);
        }
        return true;
      case asmOnboarding:
        if (currentItemKey != SideNavItemKeys.asmOnboarding) {
          context.go(AppRoutePaths.asmOnboarding);
        }
        return true;
      case distributor:
        if (currentItemKey != SideNavItemKeys.distributorManagement) {
          context.go(AppRoutePaths.distributor);
        }
        return true;
      case visualAds:
        if (currentItemKey != SideNavItemKeys.visualAdsManagement) {
          context.go(AppRoutePaths.visualAds);
        }
        return true;
      case notifications:
        if (currentItemKey != SideNavItemKeys.notifications) {
          context.go(AppRoutePaths.notifications);
        }
        return true;
      case portfolio:
        if (currentItemKey != SideNavItemKeys.ourPortfolio) {
          context.go(AppRoutePaths.portfolio);
        }
        return true;
      case helpCenter:
        if (currentItemKey != SideNavItemKeys.helpCenter) {
          context.go(AppRoutePaths.helpCenter);
        }
        return true;
      case logout:
        ref.read(authNotifierProvider.notifier).logout();
        context.go(AppRoutePaths.login);
        return true;
      default:
        return false;
    }
  }
}

class SideNavBarDrawer extends StatelessWidget {
  const SideNavBarDrawer({
    super.key,
    required this.selectedKey,
    required this.onItemTap,
  });

  final String selectedKey;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(right: BorderSide(color: AppColors.primaryDark)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: _NavHeader(theme: theme),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppColors.primaryDark),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                children: [
                  _NavTile(
                    icon: Iconsax.home_2,
                    title: 'Dashboard',
                    itemKey: SideNavItemKeys.dashboard,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  const SizedBox(height: 6),
                  _NavGroup(
                    icon: FontAwesomeIcons.userPlus,
                    title: 'Onboarding',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'mr_onboarding',
                        label: 'MR Onboarding',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: 'asm_onboarding',
                        label: 'ASM Onboarding',
                        icon: Iconsax.user_octagon,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.profile_2user,
                    title: 'Team Management',
                    itemKey: 'team_management',
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.calendar_1,
                    title: 'Attendance Record',
                    itemKey: 'attendance_record',
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.chart_21,
                    title: 'Monthly Target',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'asm_targets',
                        label: 'ASM Targets',
                        icon: Iconsax.user_octagon,
                      ),
                      _NavChild(
                        itemKey: 'mr_targets',
                        label: 'MR Targets',
                        icon: Iconsax.profile_2user,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: FontAwesomeIcons.userDoctor,
                    title: 'Doctor Networks',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'mr_doctor_networks',
                        label: 'MR Doctor Networks',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: 'asm_doctor_networks',
                        label: 'ASM Doctor Networks',
                        icon: Iconsax.user_octagon,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.calendar_search,
                    title: 'Appointments',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'mr_appointments',
                        label: 'MR Appointments',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: 'asm_appointments',
                        label: 'ASM Appointments',
                        icon: Iconsax.user_octagon,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: FontAwesomeIcons.store,
                    title: 'Chemist Shop Network',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'asm_shop_network',
                        label: 'ASM Shop Network',
                        icon: Iconsax.user_octagon,
                      ),
                      _NavChild(
                        itemKey: 'mr_shop_network',
                        label: 'MR Shop Network',
                        icon: Iconsax.profile_2user,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: FontAwesomeIcons.truckFast,
                    title: 'Distributor Management',
                    itemKey: SideNavItemKeys.distributorManagement,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.box,
                    title: 'Order Management',
                    itemKey: 'order_management',
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.location,
                    title: 'Month Trip Plan',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'asm_trip_plan',
                        label: 'ASM Trip Plan',
                        icon: Iconsax.user_octagon,
                      ),
                      _NavChild(
                        itemKey: 'mr_trip_plan',
                        label: 'MR Trip Plan',
                        icon: Iconsax.profile_2user,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.gallery,
                    title: 'Visual Ads Management',
                    itemKey: SideNavItemKeys.visualAdsManagement,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    itemKey: SideNavItemKeys.notifications,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help Center',
                    itemKey: SideNavItemKeys.helpCenter,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.info_circle,
                    title: 'Our Portfolio',
                    itemKey: SideNavItemKeys.ourPortfolio,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppColors.primaryDark),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
              child: _NavTile(
                icon: Iconsax.logout,
                title: 'Log Out',
                itemKey: SideNavItemKeys.logout,
                selectedKey: selectedKey,
                onTap: onItemTap,
                danger: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavHeader extends StatelessWidget {
  const _NavHeader({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 82,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.primary),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Panel',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                'Your managerial command center',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavChild {
  const _NavChild({
    required this.itemKey,
    required this.label,
    required this.icon,
  });

  final String itemKey;
  final String label;
  final IconData icon;
}

class _NavGroup extends StatelessWidget {
  const _NavGroup({
    required this.icon,
    required this.title,
    required this.children,
    required this.selectedKey,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final List<_NavChild> children;
  final String selectedKey;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelectedChild = children.any(
      (child) => child.itemKey == selectedKey,
    );

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: hasSelectedChild,
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 10, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        iconColor: AppColors.secondary,
        collapsedIconColor: AppColors.secondary,
        leading: Icon(icon, size: 18, color: AppColors.secondary),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: hasSelectedChild
            ? AppColors.primaryDark
            : Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        children: [
          for (final child in children)
            _NavSubTile(
              icon: child.icon,
              label: child.label,
              itemKey: child.itemKey,
              selectedKey: selectedKey,
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}

class _NavSubTile extends StatelessWidget {
  const _NavSubTile({
    required this.icon,
    required this.label,
    required this.itemKey,
    required this.selectedKey,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String itemKey;
  final String selectedKey;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedKey == itemKey;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(itemKey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? AppColors.primary : AppColors.quaternary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.quaternary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.title,
    required this.itemKey,
    required this.selectedKey,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String itemKey;
  final String selectedKey;
  final ValueChanged<String> onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedKey == itemKey;
    final theme = Theme.of(context);

    final baseColor = danger ? AppColors.error : AppColors.secondary;
    final textColor = danger ? AppColors.error : AppColors.secondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isSelected ? AppColors.primaryDark : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onTap(itemKey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(icon, size: 18, color: isSelected ? baseColor : textColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
