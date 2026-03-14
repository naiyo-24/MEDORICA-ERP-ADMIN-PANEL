import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/onboarding/mr.dart';
import '../../../theme/app_theme.dart';

class MRFilterCard extends StatelessWidget {
  const MRFilterCard({
    super.key,
    required this.mrList,
    required this.selectedMRId,
    required this.selectedMonth,
    required this.selectedYear,
    required this.months,
    required this.years,
    required this.isApplying,
    required this.onMRChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onApply,
  });

  final List<MR> mrList;
  final String selectedMRId;
  final int selectedMonth;
  final int selectedYear;
  final List<int> months;
  final List<int> years;
  final bool isApplying;
  final ValueChanged<String?> onMRChanged;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;
  final VoidCallback onApply;

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.filter_search,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Filter Monthly Target',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  initialValue: selectedMRId.isEmpty ? null : selectedMRId,
                  decoration: const InputDecoration(
                    labelText: 'Select MR',
                    prefixIcon: Icon(Iconsax.profile_2user),
                  ),
                  items: mrList
                      .map(
                        (mr) => DropdownMenuItem<String>(
                          value: mr.mrId,
                          child: Text(mr.name),
                        ),
                      )
                      .toList(),
                  onChanged: onMRChanged,
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<int>(
                  initialValue: selectedMonth,
                  decoration: const InputDecoration(
                    labelText: 'Select Month',
                    prefixIcon: Icon(Iconsax.calendar_1),
                  ),
                  items: months
                      .map(
                        (month) => DropdownMenuItem<int>(
                          value: month,
                          child: Text(_monthNames[month - 1]),
                        ),
                      )
                      .toList(),
                  onChanged: onMonthChanged,
                ),
              ),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<int>(
                  initialValue: selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'Select Year',
                    prefixIcon: Icon(Iconsax.calendar),
                  ),
                  items: years
                      .map(
                        (year) => DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: onYearChanged,
                ),
              ),
              SizedBox(
                width: 180,
                child: ElevatedButton.icon(
                  onPressed: isApplying ? null : onApply,
                  icon: isApplying
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : const Icon(Iconsax.search_normal_1, size: 18),
                  label: Text(isApplying ? 'Applying...' : 'Apply Filter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
