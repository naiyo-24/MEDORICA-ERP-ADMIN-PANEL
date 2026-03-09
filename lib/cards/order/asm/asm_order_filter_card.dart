import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm.dart';
import '../../../models/asm_order.dart';
import '../../../theme/app_theme.dart';

class ASMOrderFilterCard extends StatelessWidget {
  const ASMOrderFilterCard({
    super.key,
    required this.asmList,
    required this.searchQuery,
    required this.selectedASMId,
    required this.selectedDate,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onASMChanged,
    required this.onDateChanged,
    required this.onClearDate,
    required this.onStatusChanged,
  });

  final List<ASM> asmList;
  final String searchQuery;
  final String selectedASMId;
  final DateTime? selectedDate;
  final String selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onASMChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onClearDate;
  final ValueChanged<String> onStatusChanged;

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

    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _statusLabel(ASMOrderStatus status) {
    switch (status) {
      case ASMOrderStatus.pending:
        return 'Pending';
      case ASMOrderStatus.shipped:
        return 'Shipped';
      case ASMOrderStatus.dispatched:
        return 'Dispatched';
      case ASMOrderStatus.delivered:
        return 'Delivered';
    }
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
            width: 280,
            child: TextFormField(
              initialValue: searchQuery,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search by Order ID',
                hintText: 'ASM-ORD-1001',
                prefixIcon: const Icon(Iconsax.search_normal_1, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 300,
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
            width: 280,
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
          SizedBox(
            width: 240,
            child: DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                hintText: 'All Statuses',
                prefixIcon: const Icon(Iconsax.box, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('All Statuses'),
                ),
                ...ASMOrderStatus.values.map(
                  (status) => DropdownMenuItem<String>(
                    value: status.name,
                    child: Text(_statusLabel(status)),
                  ),
                ),
              ],
              onChanged: (value) => onStatusChanged(value ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}
