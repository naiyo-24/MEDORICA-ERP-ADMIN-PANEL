import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/mr_gift_application.dart';
import '../../../theme/app_theme.dart';

class MRGiftApplicationCard extends StatelessWidget {
  const MRGiftApplicationCard({
    super.key,
    required this.application,
    required this.onStatusChanged,
  });

  final MRGiftApplication application;
  final ValueChanged<GiftApplicationStatus> onStatusChanged;

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

  String _statusLabel(GiftApplicationStatus status) {
    switch (status) {
      case GiftApplicationStatus.pending:
        return 'Pending';
      case GiftApplicationStatus.shipped:
        return 'Shipped';
      case GiftApplicationStatus.delivered:
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
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            application.doctorName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _Row(
            label: 'Gift Item Required',
            value: application.giftItemRequired,
          ),
          _Row(label: 'MR Who Requested', value: application.mrRequestedBy),
          _Row(label: 'Date', value: _date(application.date)),
          _Row(label: 'Occasion', value: application.occasion),
          _Row(label: 'Message', value: application.message),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Iconsax.tick_circle,
                size: 15,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Status',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DropdownButtonFormField<GiftApplicationStatus>(
                  initialValue: application.status,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  items: GiftApplicationStatus.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(_statusLabel(s)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onStatusChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.quaternary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
