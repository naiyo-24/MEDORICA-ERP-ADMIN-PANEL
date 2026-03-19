import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/doctor_network/asm_doctor_network.dart';
import '../../../services/api_url.dart';
import '../../../theme/app_theme.dart';

class ASMDoctorCard extends StatelessWidget {
  const ASMDoctorCard({super.key, required this.doctor, required this.onTap});

  final ASMDoctorNetwork doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseUrl = ApiUrl.baseUrl;
    final photoPath = doctor.photo ?? '';
    final doctorPhoto = photoPath.isNotEmpty && !photoPath.startsWith('http')
        ? '$baseUrl/$photoPath'
        : photoPath;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              // Doctor Photo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: doctorPhoto.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Image.network(
                          doctorPhoto,
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Iconsax.user,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      )
                    : const Icon(
                        Iconsax.user,
                        color: AppColors.primary,
                        size: 24,
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Doctor Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      doctor.doctorName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.hospital,
                          size: 12,
                          color: AppColors.quaternary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.specialization,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: AppColors.quaternary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Phone and ASM Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.call,
                        size: 12,
                        color: AppColors.quaternary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doctor.phoneNo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: AppColors.quaternary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ASM: ${doctor.asmId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: AppColors.quaternary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),

              // Arrow Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
