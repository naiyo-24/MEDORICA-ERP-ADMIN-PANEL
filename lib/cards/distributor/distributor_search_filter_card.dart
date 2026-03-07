import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../theme/app_theme.dart';

class DistributorSearchFilterCard extends StatelessWidget {
  const DistributorSearchFilterCard({
    super.key,
    required this.searchController,
    required this.availableStates,
    required this.selectedState,
    required this.onSearchChanged,
    required this.onStateChanged,
    required this.onOnboardPressed,
  });

  final TextEditingController searchController;
  final List<String> availableStates;
  final String selectedState;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStateChanged;
  final VoidCallback onOnboardPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.sizeOf(context).width >= 960;

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
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    onChanged: onSearchChanged,
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search distributor or city',
                      prefixIcon: Icon(Iconsax.search_normal),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: availableStates.contains(selectedState)
                        ? selectedState
                        : availableStates.first,
                    decoration: const InputDecoration(
                      labelText: 'Filter by state',
                      prefixIcon: Icon(Iconsax.location),
                    ),
                    items: availableStates
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value != null) {
                        onStateChanged(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  height: AppButtonSize.medium.height,
                  child: ElevatedButton.icon(
                    onPressed: onOnboardPressed,
                    icon: const Icon(Iconsax.add_square),
                    label: Text(
                      'Onboard Distributor',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                TextField(
                  onChanged: onSearchChanged,
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search distributor or city',
                    prefixIcon: Icon(Iconsax.search_normal),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  initialValue: availableStates.contains(selectedState)
                      ? selectedState
                      : availableStates.first,
                  decoration: const InputDecoration(
                    labelText: 'Filter by state',
                    prefixIcon: Icon(Iconsax.location),
                  ),
                  items: availableStates
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      onStateChanged(value);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  height: AppButtonSize.medium.height,
                  child: ElevatedButton.icon(
                    onPressed: onOnboardPressed,
                    icon: const Icon(Iconsax.add_square),
                    label: Text(
                      'Onboard Distributor',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
