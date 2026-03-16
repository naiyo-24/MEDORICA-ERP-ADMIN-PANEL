import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/monthly_target/asm_monthly_target.dart';
import '../../../theme/app_theme.dart';

class ASMMonthlyTargetCard extends StatelessWidget {
  const ASMMonthlyTargetCard({super.key, required this.target});

  final ASMMonthlyTarget target;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final number = NumberFormat.decimalPattern('en_IN');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            target.asmName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Monthly Target Summary (${target.month}/${target.year})',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.quaternary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _MetricTile(
                label: 'Total Target',
                value: number.format(target.totalTarget.round()),
                valueColor: AppColors.primary,
              ),
              _MetricTile(
                label: 'Target Achieved',
                value: number.format(target.targetAchieved.round()),
                valueColor: AppColors.success,
              ),
              _MetricTile(
                label: 'Target Missed',
                value: number.format(target.targetMissed.round()),
                valueColor: AppColors.error,
              ),
              _MetricTile(
                label: 'Target Yet Left to Achieve',
                value: number.format(target.targetYetLeftToAchieve.round()),
                valueColor: AppColors.quaternary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Progress ${(target.progress * 100).toStringAsFixed(1)}%',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: target.progress,
              backgroundColor: AppColors.surface300,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 250,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.quaternary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
