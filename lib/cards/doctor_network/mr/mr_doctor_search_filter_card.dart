import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../theme/app_theme.dart';

class MRDoctorSearchFilterCard extends StatelessWidget {
  const MRDoctorSearchFilterCard({
    super.key,
    required this.onSearchChanged,
    required this.onMRFilterChanged,
    required this.onDepartmentFilterChanged,
    required this.mrOptions,
    required this.departmentOptions,
    required this.selectedMR,
    required this.selectedDepartment,
  });

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onMRFilterChanged;
  final ValueChanged<String> onDepartmentFilterChanged;
  final List<String> mrOptions;
  final List<String> departmentOptions;
  final String selectedMR;
  final String selectedDepartment;

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search doctors by name, phone, or email',
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
          
          // Filter Row
          Row(
            children: [
              // MR Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedMR.isEmpty ? 'All MRs' : selectedMR,
                  decoration: InputDecoration(
                    labelText: 'Filter by MR',
                    prefixIcon: const Icon(Iconsax.user, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  items: mrOptions
                      .map((mr) => DropdownMenuItem(
                            value: mr,
                            child: Text(mr),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onMRFilterChanged(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              
              // Department Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedDepartment.isEmpty
                      ? 'All Departments'
                      : selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Filter by Department',
                    prefixIcon: const Icon(Iconsax.hospital, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                  items: departmentOptions
                      .map((dept) => DropdownMenuItem(
                            value: dept,
                            child: Text(dept),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onDepartmentFilterChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
