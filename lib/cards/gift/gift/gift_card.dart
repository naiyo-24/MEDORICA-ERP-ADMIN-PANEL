import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/gift.dart';
import '../../../theme/app_theme.dart';

class GiftCard extends StatelessWidget {
  const GiftCard({
    super.key,
    required this.gift,
    required this.onEdit,
    required this.onDelete,
  });

  final Gift gift;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _formatPrice(double price) => 'INR ${price.toStringAsFixed(2)}';

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
          Row(
            children: [
              Expanded(
                child: Text(
                  gift.itemName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit gift',
                onPressed: onEdit,
                icon: const Icon(
                  Iconsax.edit,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                tooltip: 'Delete gift',
                onPressed: onDelete,
                icon: const Icon(
                  Iconsax.trash,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (gift.description.isNotEmpty)
            Text(
              gift.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.quaternary,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              
              const SizedBox(width: AppSpacing.xs),
              _Tag(
                label: 'Inventory: ${gift.quantityInInventory}',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              _Tag(
                label: 'Price: ${_formatPrice(gift.price)}',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
