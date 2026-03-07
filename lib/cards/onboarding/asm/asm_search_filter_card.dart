import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../theme/app_theme.dart';

class ASMSearchFilterCard extends StatefulWidget {
  const ASMSearchFilterCard({
    super.key,
    required this.onSearchChanged,
    required this.onOnboardPressed,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onOnboardPressed;

  @override
  State<ASMSearchFilterCard> createState() => _ASMSearchFilterCardState();
}

class _ASMSearchFilterCardState extends State<ASMSearchFilterCard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          Text(
            'Search & Filter',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search by name, phone, or email...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      prefixIcon: const Icon(
                        Iconsax.search_normal,
                        color: AppColors.quaternary,
                        size: 18,
                      ),
                      hintStyle: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.quaternary,
                      ),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: InkWell(
                  onTap: widget.onOnboardPressed,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.add,
                          color: AppColors.white,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Onboard ASM',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
