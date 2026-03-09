import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/mr.dart';
import '../../../theme/app_theme.dart';

class MRAppointmentFilterCard extends StatelessWidget {
  const MRAppointmentFilterCard({
    super.key,
    required this.mrList,
    required this.selectedMRId,
    required this.selectedDate,
    required this.onMRChanged,
    required this.onDateChanged,
    required this.onClearDate,
  });

  final List<MR> mrList;
  final String selectedMRId;
  final DateTime? selectedDate;
  final ValueChanged<String> onMRChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onClearDate;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = selectedDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    onDateChanged(picked);
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }
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
    final month = months[date.month - 1];
    return '${date.day.toString().padLeft(2, '0')} $month ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          SizedBox(
            width: 360,
            child: DropdownButtonFormField<String>(
              initialValue: selectedMRId,
              decoration: InputDecoration(
                labelText: 'Filter by MR',
                hintText: 'All MRs',
                prefixIcon: const Icon(Iconsax.profile_2user, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('All MRs'),
                ),
                ...mrList.map(
                  (mr) => DropdownMenuItem<String>(
                    value: mr.mrId,
                    child: Text(mr.name),
                  ),
                ),
              ],
              onChanged: (value) => onMRChanged(value ?? ''),
            ),
          ),
          SizedBox(
            width: 320,
            child: InkWell(
              onTap: () => _pickDate(context),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Filter by date',
                  prefixIcon: const Icon(Iconsax.calendar_1, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(selectedDate),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    if (selectedDate != null)
                      InkWell(
                        onTap: onClearDate,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Iconsax.close_circle, size: 18),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
