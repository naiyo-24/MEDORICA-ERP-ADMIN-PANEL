import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/mr.dart';
import '../../../theme/app_theme.dart';

class MRSalarySlipFilterCard extends StatelessWidget {
  const MRSalarySlipFilterCard({
    super.key,
    required this.mrOptions,
    required this.selectedMRId,
    required this.selectedYear,
    required this.onMRChanged,
    required this.onYearChanged,
  });

  final List<MR> mrOptions;
  final String selectedMRId;
  final int selectedYear;
  final ValueChanged<String> onMRChanged;
  final ValueChanged<int> onYearChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = List.generate(75, (index) => 2026 + index);

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.all(AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.primary.withAlpha(51),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Salary Slips',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medical Representative',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<String>(
                        initialValue: selectedMRId,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.user, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                        ),
                        items: mrOptions.map((mr) {
                          return DropdownMenuItem(
                            value: mr.id,
                            child: Text(mr.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) onMRChanged(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Year',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<int>(
                        initialValue: selectedYear,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.calendar_1, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                        ),
                        items: years.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) onYearChanged(value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
