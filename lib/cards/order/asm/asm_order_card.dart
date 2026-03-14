import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm_order.dart';
import '../../../theme/app_theme.dart';

class ASMOrderCard extends StatelessWidget {
  const ASMOrderCard({
    super.key,
    required this.order,
    required this.onStatusChanged,
    required this.onDelete,
    this.isBusy = false,
  });

  final ASMOrder order;
  final ValueChanged<ASMOrderStatus> onStatusChanged;
  final VoidCallback onDelete;
  final bool isBusy;

  String _date(DateTime value) {
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
    return '${value.day.toString().padLeft(2, '0')} ${months[value.month - 1]} ${value.year}';
  }

  String _time(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} $period';
  }

  String _statusLabel(ASMOrderStatus status) {
    switch (status) {
      case ASMOrderStatus.pending:
        return 'Pending';
      case ASMOrderStatus.approved:
        return 'Approved';
      case ASMOrderStatus.shipped:
        return 'Shipped';
      case ASMOrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _statusColor(ASMOrderStatus status) {
    switch (status) {
      case ASMOrderStatus.pending:
        return Colors.orange;
      case ASMOrderStatus.approved:
        return Colors.teal;
      case ASMOrderStatus.shipped:
        return AppColors.primary;
      case ASMOrderStatus.delivered:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(order.status);

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  order.id,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  _statusLabel(order.status),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              _InfoChip(
                icon: Iconsax.calendar_1,
                label: 'Order Date',
                value: _date(order.orderDate),
              ),
              _InfoChip(
                icon: Iconsax.clock,
                label: 'Delivery',
                value:
                    '${_date(order.deliveryDateTime)} at ${_time(order.deliveryDateTime)}',
              ),
              _InfoChip(
                icon: Iconsax.user_octagon,
                label: 'ASM',
                value: order.asmName,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(
            label: 'Doctor Interested',
            value: order.doctorName == '-'
                ? (order.doctorId ?? '-')
                : order.doctorName,
          ),
          _DetailRow(
            label: 'Chemist Shop Ordered For',
            value: order.chemistShopName == '-'
                ? (order.chemistShopId ?? '-')
                : order.chemistShopName,
          ),
          _DetailRow(
            label: 'Distributor Responsible',
            value: order.distributorName == '-'
                ? (order.distributorId ?? '-')
                : order.distributorName,
          ),
          _DetailRow(
            label: 'Delivery Time & Date',
            value:
                '${_date(order.deliveryDateTime)} | ${_time(order.deliveryDateTime)}',
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ASMOrderStatus>(
                  initialValue: order.status,
                  decoration: InputDecoration(
                    labelText: 'Update Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  items: ASMOrderStatus.values
                      .map(
                        (status) => DropdownMenuItem<ASMOrderStatus>(
                          value: status,
                          child: Text(_statusLabel(status)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: isBusy
                      ? null
                      : (value) {
                          if (value != null && value != order.status) {
                            onStatusChanged(value);
                          }
                        },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton.icon(
                onPressed: isBusy ? null : onDelete,
                icon: const Icon(Iconsax.trash, size: 18),
                label: const Text('Delete'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.quaternary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.quaternary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 190,
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
