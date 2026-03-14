import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/onboarding/asm.dart';
import '../../../theme/app_theme.dart';

class ASMAppointmentFilterCard extends StatelessWidget {
  const ASMAppointmentFilterCard({
    super.key,
    required this.asmList,
    required this.selectedASMId,
    required this.selectedDate,
    required this.onASMChanged,
    required this.onDateChanged,
    required this.onClearDate,
  });

  final List<ASM> asmList;
  final String selectedASMId;
  final DateTime? selectedDate;
  final ValueChanged<String> onASMChanged;
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
              initialValue: selectedASMId,
              decoration: InputDecoration(
                labelText: 'Filter by ASM',
                hintText: 'All ASMs',
                prefixIcon: const Icon(Iconsax.user_octagon, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('All ASMs'),
                ),
                ...asmList.map(
                  (asm) => DropdownMenuItem<String>(
                    value: asm.asmId,
                    child: Text(asm.name),
                  ),
                ),
              ],
              onChanged: (value) => onASMChanged(value ?? ''),
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
