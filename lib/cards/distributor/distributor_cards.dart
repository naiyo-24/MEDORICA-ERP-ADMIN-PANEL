import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/distributor.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class DistributorCards extends StatelessWidget {
  const DistributorCards({
    super.key,
    required this.distributors,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Distributor> distributors;
  final ValueChanged<Distributor> onView;
  final ValueChanged<Distributor> onEdit;
  final ValueChanged<Distributor> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (distributors.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(
              Iconsax.user_remove,
              size: 38,
              color: AppColors.quaternary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No distributors found for this filter.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final distributor in distributors) ...[
          _DistributorCard(
            distributor: distributor,
            onView: () => onView(distributor),
            onEdit: () => onEdit(distributor),
            onDelete: () => onDelete(distributor),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _DistributorCard extends StatelessWidget {
  const _DistributorCard({
    required this.distributor,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final Distributor distributor;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Widget _buildDistributorPhoto(Distributor distributor) {
    // Try to use API photo first, then fall back to in-memory bytes
    if (distributor.distPhoto != null && distributor.distPhoto!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.network(
          ApiUrl.getProfilePhotoUrl(distributor.distPhoto!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Iconsax.profile_circle,
              size: 30,
              color: AppColors.quaternary,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            );
          },
        ),
      );
    } else if (distributor.imageBytes != null) {
      // Fall back to in-memory bytes if available (for newly added distributors)
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.memory(
          distributor.imageBytes!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Default placeholder
      return const Icon(
        Iconsax.profile_circle,
        size: 30,
        color: AppColors.quaternary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onView,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: _buildDistributorPhoto(distributor),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      distributor.distName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.location,
                          size: 15,
                          color: AppColors.quaternary,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            distributor.locationLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit distributor',
                onPressed: onEdit,
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
              ),
              IconButton(
                tooltip: 'Delete distributor',
                onPressed: onDelete,
                icon: const Icon(Iconsax.trash, color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
