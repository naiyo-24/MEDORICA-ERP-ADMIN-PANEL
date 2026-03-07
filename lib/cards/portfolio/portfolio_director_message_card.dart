import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../theme/app_theme.dart';

class PortfolioDirectorMessageCard extends StatelessWidget {
  const PortfolioDirectorMessageCard({
    super.key,
    required this.message,
    required this.onEdit,
  });

  final String message;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Director Message',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit director message',
                onPressed: onEdit,
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              '"$message"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
