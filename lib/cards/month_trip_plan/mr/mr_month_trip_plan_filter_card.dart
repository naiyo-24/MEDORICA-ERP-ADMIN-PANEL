import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/mr.dart';
import '../../../theme/app_theme.dart';

class MRMonthTripPlanFilterCard extends StatelessWidget {
  const MRMonthTripPlanFilterCard({
    super.key,
    required this.mrOptions,
    required this.selectedMRId,
    required this.selectedDate,
    required this.onMRChanged,
    required this.onDateChanged,
    required this.onCreatePressed,
  });

  final List<MR> mrOptions;
  final String selectedMRId;
  final DateTime? selectedDate;
  final ValueChanged<String> onMRChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onCreatePressed;

  String _formatDate(DateTime date) {
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = selectedDate ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      onDateChanged(DateTime(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedMRId,
            decoration: InputDecoration(
              labelText: 'Select MR',
              prefixIcon: const Icon(Iconsax.profile_2user, size: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('All MRs')),
              ...mrOptions.map(
                (mr) => DropdownMenuItem(value: mr.mrId, child: Text(mr.name)),
              ),
            ],
            onChanged: (value) => onMRChanged(value ?? ''),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickDate(context),
                icon: const Icon(Iconsax.calendar_1, size: 16),
                label: Text(
                  selectedDate == null
                      ? 'Filter by Date'
                      : _formatDate(selectedDate!),
                ),
              ),
              if (selectedDate != null)
                OutlinedButton.icon(
                  onPressed: () => onDateChanged(null),
                  icon: const Icon(Iconsax.close_circle, size: 16),
                  label: const Text('Clear Date'),
                ),
              ElevatedButton.icon(
                onPressed: onCreatePressed,
                icon: const Icon(Iconsax.add, size: 16),
                label: const Text('Create Month Plan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
