import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/order/mr_order.dart';
import '../../../theme/app_theme.dart';

class MROrderCard extends StatelessWidget {
  const MROrderCard({super.key, required this.order});

  final MROrder order;

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

  String _statusLabel(MROrderStatus status) {
    switch (status) {
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

  Color _statusColor(MROrderStatus status) {
    switch (status) {
      case MROrderStatus.pending:
        return Colors.orange;
      case MROrderStatus.shipped:
        return AppColors.primary;
      case MROrderStatus.dispatched:
        return Colors.blue;
      case MROrderStatus.delivered:
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
                icon: Iconsax.profile_2user,
                label: 'MR',
                value: order.mrName,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(label: 'Doctor Interested', value: order.doctorName),
          _DetailRow(
            label: 'Chemist Shop Ordered For',
            value: order.chemistShopName,
          ),
          _DetailRow(
            label: 'Distributor Responsible',
            value: order.distributorName,
          ),
          _DetailRow(
            label: 'Delivery Time & Date',
            value:
                '${_date(order.deliveryDateTime)} | ${_time(order.deliveryDateTime)}',
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
