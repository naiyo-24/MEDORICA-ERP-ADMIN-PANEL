import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_theme.dart';

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
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(right: BorderSide(color: AppColors.border)),
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
              child: Divider(color: AppColors.divider),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                children: [
                  _NavTile(
                    icon: Iconsax.home_2,
                    title: 'Dashboard',
                    itemKey: 'dashboard',
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
                      ),
                      _NavChild(
                        itemKey: 'asm_onboarding',
                        label: 'ASM Onboarding',
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
                      _NavChild(itemKey: 'asm_targets', label: 'ASM Targets'),
                      _NavChild(itemKey: 'mr_targets', label: 'MR Targets'),
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
                      ),
                      _NavChild(
                        itemKey: 'asm_doctor_networks',
                        label: 'ASM Doctor Networks',
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
                      ),
                      _NavChild(
                        itemKey: 'asm_appointments',
                        label: 'ASM Appointments',
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
                      ),
                      _NavChild(
                        itemKey: 'mr_shop_network',
                        label: 'MR Shop Network',
                      ),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: FontAwesomeIcons.truckFast,
                    title: 'Distributor Management',
                    itemKey: 'distributor_management',
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
                      ),
                      _NavChild(itemKey: 'mr_trip_plan', label: 'MR Trip Plan'),
                    ],
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.gallery,
                    title: 'Visual Ads Management',
                    itemKey: 'visual_ads_management',
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    itemKey: 'notifications',
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                  _NavTile(
                    icon: FontAwesomeIcons.circleQuestion,
                    title: 'Help Center',
                    itemKey: 'help_center',
                    selectedKey: selectedKey,
                    onTap: onItemTap,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppColors.divider),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
              child: _NavTile(
                icon: Iconsax.logout,
                title: 'Log Out',
                itemKey: 'logout',
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
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
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
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Your managerial command center',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
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
  const _NavChild({required this.itemKey, required this.label});

  final String itemKey;
  final String label;
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
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.quaternary,
        leading: Icon(icon, size: 18, color: AppColors.primary),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: hasSelectedChild
            ? AppColors.primaryLight
            : Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        children: [
          for (final child in children)
            _NavSubTile(
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
    required this.label,
    required this.itemKey,
    required this.selectedKey,
    required this.onTap,
  });

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
        color: isSelected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(itemKey),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.quaternary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
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

    final baseColor = danger ? AppColors.error : AppColors.primary;
    final textColor = danger
        ? AppColors.error
        : (isSelected ? AppColors.primary : AppColors.quaternary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isSelected ? AppColors.primaryLight : Colors.transparent,
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
