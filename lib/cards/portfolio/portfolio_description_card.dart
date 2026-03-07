import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../theme/app_theme.dart';

class PortfolioDescriptionCard extends StatelessWidget {
  const PortfolioDescriptionCard({
    super.key,
    required this.description,
    required this.onEdit,
  });

  final String description;
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
                  'Portfolio Description',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit description',
                onPressed: onEdit,
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
