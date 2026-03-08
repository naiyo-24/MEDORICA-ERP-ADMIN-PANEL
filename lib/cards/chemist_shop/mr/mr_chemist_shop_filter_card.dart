import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/mr.dart';
import '../../../theme/app_theme.dart';

class MRChemistShopFilterCard extends StatelessWidget {
  const MRChemistShopFilterCard({
    super.key,
    required this.mrList,
    required this.locationOptions,
    required this.selectedMRId,
    required this.selectedLocation,
    required this.onSearchChanged,
    required this.onMRChanged,
    required this.onLocationChanged,
  });

  final List<MR> mrList;
  final List<String> locationOptions;
  final String selectedMRId;
  final String selectedLocation;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onMRChanged;
  final ValueChanged<String> onLocationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search chemist shop by name, phone, email or doctor',
              prefixIcon: const Icon(Iconsax.search_normal, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedMRId,
                  decoration: InputDecoration(
                    labelText: 'Filter by MR',
                    prefixIcon: const Icon(Iconsax.profile_2user, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('All MRs')),
                    ...mrList.map(
                      (mr) =>
                          DropdownMenuItem(value: mr.id, child: Text(mr.name)),
                    ),
                  ],
                  onChanged: (value) => onMRChanged(value ?? ''),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedLocation,
                  decoration: InputDecoration(
                    labelText: 'Filter by Location',
                    prefixIcon: const Icon(Iconsax.location, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  items: locationOptions
                      .map(
                        (location) => DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      onLocationChanged(value ?? 'All Locations'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
