import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/dashboard.dart';
import '../../theme/app_theme.dart';

class CountCardSection extends StatelessWidget {
  const CountCardSection({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _CountMetric(
        title: 'Total MR',
        value: data.totalMr,
        icon: Iconsax.profile_2user,
      ),
      _CountMetric(
        title: 'Total ASM',
        value: data.totalAsm,
        icon: Iconsax.user_octagon,
      ),
      _CountMetric(
        title: 'Distributors',
        value: data.totalDistributors,
        icon: Iconsax.truck,
      ),
      _CountMetric(
        title: 'Chemist Shops',
        value: data.totalChemistShops,
        icon: Iconsax.shop,
      ),
      _CountMetric(
        title: 'Doctors',
        value: data.totalDoctors,
        icon: Iconsax.user,
      ),
    ];

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [for (final metric in metrics) _CountCard(metric: metric)],
    );
  }
}

class _CountMetric {
  const _CountMetric({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final int value;
  final IconData icon;
}

class _CountCard extends StatelessWidget {
  const _CountCard({required this.metric});

  final _CountMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180, maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(metric.icon, color: AppColors.primary, size: 17),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              metric.value.toString(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 26,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              metric.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.quaternary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
