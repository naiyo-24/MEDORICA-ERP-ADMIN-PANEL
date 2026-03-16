
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../providers/auth_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_theme.dart';

// Helper function to render Icon or FaIcon based on icon type
Widget _buildIcon(dynamic icon, double size, Color color) {
  if (icon is FaIconData) {
    return FaIcon(icon, size: size, color: color);
  }
  return Icon(icon as IconData, size: size, color: color);
}

class SideNavItemKeys {
  static const String dashboard = 'dashboard';
  static const String mrOnboarding = 'mr_onboarding';
  static const String asmOnboarding = 'asm_onboarding';
  static const String teamManagement = 'team_management';
  static const String mrDoctorNetworks = 'mr_doctor_networks';
  static const String asmDoctorNetworks = 'asm_doctor_networks';
  static const String distributorManagement = 'distributor_management';
  static const String visualAdsManagement = 'visual_ads_management';
  static const String notifications = 'notifications';
  static const String ourPortfolio = 'our_portfolio';
  static const String helpCenter = 'help_center';
  static const String mrAttendance = 'mr_attendance';
  static const String asmAttendance = 'asm_attendance';
  static const String mrAppointments = 'mr_appointments';
  static const String asmAppointments = 'asm_appointments';
  static const String asmShopNetwork = 'asm_shop_network';
  static const String mrShopNetwork = 'mr_shop_network';
  static const String manageGifts = 'manage_gifts';
  static const String mrGiftApplications = 'mr_gift_applications';
  static const String asmGiftApplications = 'asm_gift_applications';
  static const String asmTargets = 'asm_targets';
  static const String mrTargets = 'mr_targets';
  static const String asmTripPlan = 'asm_trip_plan';
  static const String mrTripPlan = 'mr_trip_plan';
  static const String mrSalarySlip = 'mr_salary_slip';
  static const String asmSalarySlip = 'asm_salary_slip';
  static const String mrOrders = 'mr_orders';
  static const String asmOrders = 'asm_orders';
  static const String logout = 'logout';
}

class SideNavRouteIndex {
  static const int dashboard = 0;
  static const int mrOnboarding = 1;
  static const int asmOnboarding = 2;
  static const int teamManagement = 3;
  static const int mrDoctorNetworks = 4;
  static const int asmDoctorNetworks = 5;
  static const int distributor = 6;
  static const int visualAds = 7;
  static const int notifications = 8;
  static const int portfolio = 9;
  static const int helpCenter = 10;
  static const int mrAttendance = 11;
  static const int asmAttendance = 12;
  static const int mrAppointments = 13;
  static const int asmAppointments = 14;
  static const int asmShopNetwork = 15;
  static const int mrShopNetwork = 16;
  static const int manageGifts = 17;
  static const int mrGiftApplications = 18;
  static const int asmGiftApplications = 19;
  static const int asmTargets = 20;
  static const int mrTargets = 21;
  static const int asmTripPlan = 22;
  static const int mrTripPlan = 23;
  static const int mrSalarySlip = 24;
  static const int asmSalarySlip = 25;
  static const int mrOrders = 26;
  static const int asmOrders = 27;
  static const int logout = 28;
  static const int unhandled = -1;

  static int fromItemKey(String itemKey) {
    switch (itemKey) {
      case SideNavItemKeys.dashboard:
        return dashboard;
      case SideNavItemKeys.mrOnboarding:
        return mrOnboarding;
      case SideNavItemKeys.asmOnboarding:
        return asmOnboarding;
      case SideNavItemKeys.teamManagement:
        return teamManagement;
      case SideNavItemKeys.mrDoctorNetworks:
        return mrDoctorNetworks;
      case SideNavItemKeys.asmDoctorNetworks:
        return asmDoctorNetworks;
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
      case SideNavItemKeys.mrAttendance:
        return mrAttendance;
      case SideNavItemKeys.asmAttendance:
        return asmAttendance;
      case SideNavItemKeys.mrAppointments:
        return mrAppointments;
      case SideNavItemKeys.asmAppointments:
        return asmAppointments;
      case SideNavItemKeys.asmShopNetwork:
        return asmShopNetwork;
      case SideNavItemKeys.mrShopNetwork:
        return mrShopNetwork;
      case SideNavItemKeys.manageGifts:
        return manageGifts;
      case SideNavItemKeys.mrGiftApplications:
        return mrGiftApplications;
      case SideNavItemKeys.asmGiftApplications:
        return asmGiftApplications;
      case SideNavItemKeys.asmTargets:
        return asmTargets;
      case SideNavItemKeys.mrTargets:
        return mrTargets;
      case SideNavItemKeys.asmTripPlan:
        return asmTripPlan;
      case SideNavItemKeys.mrTripPlan:
        return mrTripPlan;
      case SideNavItemKeys.mrSalarySlip:
        return mrSalarySlip;
      case SideNavItemKeys.asmSalarySlip:
        return asmSalarySlip;
      case SideNavItemKeys.mrOrders:
        return mrOrders;
      case SideNavItemKeys.asmOrders:
        return asmOrders;
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
      case teamManagement:
        if (currentItemKey != SideNavItemKeys.teamManagement) {
          context.go(AppRoutePaths.team);
        }
        return true;
      case mrDoctorNetworks:
        if (currentItemKey != SideNavItemKeys.mrDoctorNetworks) {
          context.go(AppRoutePaths.mrDoctorNetwork);
        }
        return true;
      case asmDoctorNetworks:
        if (currentItemKey != SideNavItemKeys.asmDoctorNetworks) {
          context.go(AppRoutePaths.asmDoctorNetwork);
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
      case mrAttendance:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrAttendance);
        }
        return true;
      case asmAttendance:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmAttendance);
        }
        return true;
      case mrAppointments:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrAppointments);
        }
        return true;
      case asmAppointments:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmAppointments);
        }
        return true;
      case asmShopNetwork:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmChemistShop);
        }
        return true;
      case mrShopNetwork:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrChemistShop);
        }
        return true;
      case manageGifts:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.giftManagement);
        }
        return true;
      case mrGiftApplications:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrGiftApplications);
        }
        return true;
      case asmGiftApplications:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmGiftApplications);
        }
        return true;
      case asmTargets:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmMonthlyTarget);
        }
        return true;
      case mrTargets:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrMonthlyTarget);
        }
        return true;
      case asmTripPlan:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmMonthTripPlan);
        }
        return true;
      case mrTripPlan:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrMonthTripPlan);
        }
        return true;
      case mrSalarySlip:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrSalarySlip);
        }
        return true;
      case asmSalarySlip:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmSalarySlip);
        }
        return true;
      case mrOrders:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.mrOrder);
        }
        return true;
      case asmOrders:
        if (currentItemKey != itemKey) {
          context.go(AppRoutePaths.asmOrder);
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
                    itemKey: SideNavItemKeys.teamManagement,
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.calendar_1,
                    title: 'Attendance Record',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: 'mr_attendance',
                        label: 'MR Attendance',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: 'asm_attendance',
                        label: 'ASM Attendance',
                        icon: Iconsax.user_octagon,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.chart_21,
                    title: 'Monthly Target',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: SideNavItemKeys.asmTargets,
                        label: 'ASM Targets',
                        icon: Iconsax.user_octagon,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.mrTargets,
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
                        itemKey: SideNavItemKeys.mrAppointments,
                        label: 'MR Appointments',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.asmAppointments,
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
                        itemKey: SideNavItemKeys.asmShopNetwork,
                        label: 'ASM Shop Network',
                        icon: Iconsax.user_octagon,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.mrShopNetwork,
                        label: 'MR Shop Network',
                        icon: Iconsax.profile_2user,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: FontAwesomeIcons.gift,
                    title: 'Gift Management',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: SideNavItemKeys.manageGifts,
                        label: 'Manage Gifts',
                        icon: Iconsax.gift,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.mrGiftApplications,
                        label: 'MR Gift Applications',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.asmGiftApplications,
                        label: 'ASM Gift Applications',
                        icon: Iconsax.user_octagon,
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
                  _NavGroup(
                    icon: Iconsax.box,
                    title: 'Order Management',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: SideNavItemKeys.mrOrders,
                        label: 'MR Orders',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.asmOrders,
                        label: 'ASM Orders',
                        icon: Iconsax.user_octagon,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.location,
                    title: 'Month Trip Plan',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: SideNavItemKeys.asmTripPlan,
                        label: 'ASM Trip Plan',
                        icon: Iconsax.user_octagon,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.mrTripPlan,
                        label: 'MR Trip Plan',
                        icon: Iconsax.profile_2user,
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavGroup(
                    icon: Iconsax.money,
                    title: 'Salary Slip Management',
                    selectedKey: selectedKey,
                    children: const [
                      _NavChild(
                        itemKey: SideNavItemKeys.mrSalarySlip,
                        label: 'MR Salary Slips',
                        icon: Iconsax.profile_2user,
                      ),
                      _NavChild(
                        itemKey: SideNavItemKeys.asmSalarySlip,
                        label: 'ASM Salary Slips',
                        icon: Iconsax.user_octagon,
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
  final dynamic icon;
}

class _NavGroup extends StatelessWidget {
  const _NavGroup({
    required this.icon,
    required this.title,
    required this.children,
    required this.selectedKey,
    required this.onTap,
  });

  final dynamic icon;
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
        leading: _buildIcon(icon, 18, AppColors.secondary),
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
                _buildIcon(
                  icon,
                  15,
                  isSelected ? AppColors.primary : AppColors.quaternary,
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

  final dynamic icon;
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
                _buildIcon(
                  icon,
                  18,
                  isSelected ? baseColor : textColor,
                ),
                // Helper function to render Icon or FaIcon based on icon type
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
