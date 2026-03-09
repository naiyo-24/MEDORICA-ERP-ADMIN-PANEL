import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm.dart';
import '../../../theme/app_theme.dart';

class ASMGiftApplicationFilterCard extends StatelessWidget {
  const ASMGiftApplicationFilterCard({
    super.key,
    required this.asmOptions,
    required this.doctorOptions,
    required this.selectedASMId,
    required this.selectedDoctor,
    required this.onSearchChanged,
    required this.onASMChanged,
    required this.onDoctorChanged,
  });

  final List<ASM> asmOptions;
  final List<String> doctorOptions;
  final String selectedASMId;
  final String selectedDoctor;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onASMChanged;
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
              hintText: 'Search ASM or doctor',
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
                  initialValue: selectedASMId,
                  decoration: InputDecoration(
                    labelText: 'Filter by ASM',
                    prefixIcon: const Icon(Iconsax.user_octagon, size: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('All ASMs')),
                    ...asmOptions.map(
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
