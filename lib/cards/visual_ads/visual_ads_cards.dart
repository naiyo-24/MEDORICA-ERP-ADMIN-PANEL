import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/visual_ads.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class VisualAdsCards extends StatelessWidget {
  const VisualAdsCards({
    super.key,
    required this.ads,
    required this.onEdit,
    required this.onDelete,
  });

  final List<VisualAd> ads;
  final ValueChanged<VisualAd> onEdit;
  final ValueChanged<VisualAd> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (ads.isEmpty) {
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
              Iconsax.gallery_slash,
              size: 36,
              color: AppColors.quaternary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No visual ads created yet.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final ad in ads) ...[
          _VisualAdCard(
            ad: ad,
            onEdit: () => onEdit(ad),
            onDelete: () => onDelete(ad),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _VisualAdCard extends StatelessWidget {
  const _VisualAdCard({
    required this.ad,
    required this.onEdit,
    required this.onDelete,
  });

  final VisualAd ad;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: ad.imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Image.memory(ad.imageBytes!, fit: BoxFit.cover),
                  )
                : ad.imageUrl != null && ad.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Image.network(
                          ApiUrl.getProfilePhotoUrl(ad.imageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Iconsax.gallery,
                                size: 36,
                                color: AppColors.quaternary,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Iconsax.gallery,
                          size: 36,
                          color: AppColors.quaternary,
                        ),
                      ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'ID: ${ad.adId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Iconsax.trash, color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
