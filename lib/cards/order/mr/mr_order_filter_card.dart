import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/onboarding/mr.dart';
import '../../../models/order/mr_order.dart';
import '../../../theme/app_theme.dart';

class MROrderFilterCard extends StatelessWidget {
  const MROrderFilterCard({
    super.key,
    required this.mrList,
    required this.searchQuery,
    required this.selectedMRId,
    required this.selectedDate,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onMRChanged,
    required this.onDateChanged,
    required this.onClearDate,
    required this.onStatusChanged,
  });

  final List<MR> mrList;
  final String searchQuery;
  final String selectedMRId;
  final DateTime? selectedDate;
  final String selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onMRChanged;
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

  String _statusLabel(MROrderStatus status) {
    switch (status) {
      case MROrderStatus.approved:
        return 'Approved';
      case MROrderStatus.pending:
        return 'Pending';
      case MROrderStatus.shipped:
        return 'Shipped';
      case MROrderStatus.dispatched:
        return 'Dispatched';
      case MROrderStatus.delivered:
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
                hintText: 'MR-ORD-1001',
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
                ...MROrderStatus.values.map(
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
