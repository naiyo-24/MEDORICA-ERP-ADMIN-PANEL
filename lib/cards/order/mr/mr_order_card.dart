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
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${order.id}', style: theme.textTheme.bodySmall),
                    Text('MR ID: ${order.mrId}', style: theme.textTheme.bodySmall),
                    Text('Distributor ID: ${order.distributorName}', style: theme.textTheme.bodySmall),
                    Text('Chemist Shop ID: ${order.chemistShopName}', style: theme.textTheme.bodySmall),
                    Text('Doctor ID: ${order.doctorName}', style: theme.textTheme.bodySmall),
                    Text('Created At: ${order.orderDate}', style: theme.textTheme.bodySmall),
                    Text('Updated At: ${order.deliveryDateTime}', style: theme.textTheme.bodySmall),
                    Text('Total Amount: ₹${order.totalAmountRupees}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (order.productsWithPrice is List && (order.productsWithPrice as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Products:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
                                Expanded(
                                  child: Text(
                                    '$name (Qty: $qty, Pack: $pack)',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.quaternary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '₹$total',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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

