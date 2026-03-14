import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/onboarding/asm.dart';
import '../../../theme/app_theme.dart';

class ASMChemistShopFilterCard extends StatelessWidget {
  const ASMChemistShopFilterCard({
    super.key,
    required this.asmList,
    required this.locationOptions,
    required this.selectedASMId,
    required this.selectedLocation,
    required this.onSearchChanged,
    required this.onASMChanged,
    required this.onLocationChanged,
  });

  final List<ASM> asmList;
  final List<String> locationOptions;
  final String selectedASMId;
  final String selectedLocation;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onASMChanged;
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
                  initialValue: selectedASMId,
                  decoration: InputDecoration(
                    labelText: 'Filter by ASM',
                    prefixIcon: const Icon(Iconsax.user_octagon, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('All ASMs')),
                    ...asmList.map(
                      (asm) => DropdownMenuItem(
                        value: asm.asmId,
                        child: Text(asm.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => onASMChanged(value ?? ''),
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
