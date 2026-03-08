import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm_month_trip_plan.dart';
import '../../../theme/app_theme.dart';

class ASMMonthTripPlanCard extends StatelessWidget {
  const ASMMonthTripPlanCard({
    super.key,
    required this.group,
    required this.onEdit,
    required this.onDelete,
  });

  final ASMMonthTripPlan group;
  final void Function(ASMTripPlanItem item) onEdit;
  final void Function(ASMTripPlanItem item) onDelete;

  String _date(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  String _time(BuildContext context, TimeOfDay t) {
    return MaterialLocalizations.of(context).formatTimeOfDay(t);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.asmName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Date: ${_date(group.date)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.quaternary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...group.plans.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_date(group.date)} | ${_time(context, item.time)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    tooltip: 'Edit plan',
                    onPressed: () => onEdit(item),
                    icon: const Icon(
                      Iconsax.edit,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete plan',
                    onPressed: () => onDelete(item),
                    icon: const Icon(
                      Iconsax.trash,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
