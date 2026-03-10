import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/gift.dart';
import '../../../theme/app_theme.dart';

class GiftCard extends StatefulWidget {
  const GiftCard({
    super.key,
    required this.gift,
    required this.onEdit,
    required this.onDelete,
  });

  final Gift gift;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  bool _isHovered = false;

  String _formatPrice(double price) => 'INR ${price.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
            width: _isHovered ? 1.5 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and action buttons
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(26),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Icon(
                          Iconsax.gift,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.gift.itemName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: _isHovered ? 1 : 0.7,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Tooltip(
                          message: 'Edit gift',
                          child: IconButton(
                            onPressed: widget.onEdit,
                            icon: const Icon(
                              Iconsax.edit_2,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            hoverColor:
                                AppColors.primary.withAlpha(13),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Tooltip(
                          message: 'Delete gift',
                          child: IconButton(
                            onPressed: widget.onDelete,
                            icon: const Icon(
                              Iconsax.trash,
                              size: 18,
                              color: AppColors.error,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            hoverColor: AppColors.error.withAlpha(13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Description
            if (widget.gift.description.isNotEmpty) ...[
              Text(
                widget.gift.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            // Tags section
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                
                _TagWithIcon(
                  icon: Iconsax.box,
                  label: 'Inventory: ${widget.gift.quantityInInventory}',
                  color: AppColors.primary,
                ),
                _TagWithIcon(
                  icon: Iconsax.money,
                  label: _formatPrice(widget.gift.price),
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagWithIcon extends StatelessWidget {
  const _TagWithIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
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
        border: Border.all(
          color: color.withAlpha(51),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
