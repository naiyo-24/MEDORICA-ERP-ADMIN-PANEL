import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/onboarding/mr.dart';
import '../../../theme/app_theme.dart';

class MRGiftApplicationFilterCard extends StatelessWidget {
  const MRGiftApplicationFilterCard({
    super.key,
    required this.mrOptions,
    required this.doctorOptions,
    required this.selectedMRId,
    required this.selectedDoctor,
    required this.onSearchChanged,
    required this.onMRChanged,
    required this.onDoctorChanged,
  });

  final List<MR> mrOptions;
  final List<String> doctorOptions;
  final String selectedMRId;
  final String selectedDoctor;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onMRChanged;
  final ValueChanged<String> onDoctorChanged;

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
              hintText: 'Search MR or doctor',
              prefixIcon: const Icon(Iconsax.search_normal, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
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
                  ),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('All MRs')),
                    ...mrOptions.map(
                      (mr) =>
                          DropdownMenuItem(value: mr.mrId, child: Text(mr.name)),
                    ),
                  ],
                  onChanged: (value) => onMRChanged(value ?? ''),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedDoctor,
                  decoration: InputDecoration(
                    labelText: 'Select Doctor',
                    prefixIcon: const Icon(Iconsax.hospital, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  items: doctorOptions
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (value) => onDoctorChanged(value ?? 'All Doctors'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
