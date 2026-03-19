import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../models/order/mr_order.dart';
import '../../../providers/order/mr_order_provider.dart';
import '../../../theme/app_theme.dart';

class MROrderCard extends StatelessWidget {
  const MROrderCard({super.key, required this.order});

  final MROrder order;



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
      case MROrderStatus.approved:
        return 'Approved';
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
      case MROrderStatus.approved:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _statusColor(order.status);
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(mrOrderNotifierProvider.notifier);
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
                  Icon(Iconsax.document, color: AppColors.primary, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text(order.id, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withAlpha(26),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.status_up, color: _statusColor(order.status), size: 16),
                        const SizedBox(width: 4),
                        Text(_statusLabel(order.status), style: theme.textTheme.bodySmall?.copyWith(color: _statusColor(order.status), fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.xs,
                children: [
                  _InfoChip(icon: Iconsax.profile_2user, label: 'MR', value: order.mrId),
                  _InfoChip(icon: Iconsax.shop, label: 'Chemist Shop', value: order.chemistShopName),
                  _InfoChip(icon: Iconsax.user, label: 'Doctor', value: order.doctorName),
                  _InfoChip(icon: Iconsax.truck, label: 'Distributor', value: order.distributorName),
                  _InfoChip(icon: Iconsax.calendar_1, label: 'Created', value: order.orderDate.toString()),
                  _InfoChip(icon: Iconsax.clock, label: 'Updated', value: order.deliveryDateTime.toString()),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Iconsax.money_send, color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text('Total Amount:', style: theme.textTheme.bodySmall),
                  const SizedBox(width: 4),
                  Text('₹${order.totalAmountRupees}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (order.productsWithPrice is List && (order.productsWithPrice as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.box, color: AppColors.primary, size: 18),
                          const SizedBox(width: 6),
                          Text('Products:', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...List<Widget>.from(
                        (order.productsWithPrice as List).map((prod) {
                          final name = prod['name']?.toString() ?? '-';
                          final qty = prod['quantity']?.toString() ?? '-';
                          final pack = prod['pack']?.toString() ?? '-';
                          final total = prod['totalAmount']?.toString() ?? '-';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Icon(Iconsax.tag, color: AppColors.quaternary, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text('$name (Qty: $qty, Pack: $pack)', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.quaternary)),
                                ),
                                Text('₹$total', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Icon(Iconsax.status_up, color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: DropdownButtonFormField<MROrderStatus>(
                      initialValue: order.status,
                      decoration: InputDecoration(
                        labelText: 'Update Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      items: MROrderStatus.values
                          .map(
                            (status) => DropdownMenuItem<MROrderStatus>(
                              value: status,
                              child: Text(_statusLabel(status)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) async {
                        if (value != null && value != order.status) {
                          await notifier.updateOrderStatus(orderId: order.id, status: value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          
          ),
        );
      },
    );
  }
}

// Modern info chip widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoChip({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.quaternary),
          const SizedBox(width: 4),
          Text('$label:', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.quaternary)),
          const SizedBox(width: 2),
          Text(value, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
       

