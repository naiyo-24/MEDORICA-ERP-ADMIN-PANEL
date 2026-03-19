import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/doctor_network/mr_doctor_network.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_url.dart';

class MRDoctorCard extends StatelessWidget {
  const MRDoctorCard({super.key, required this.doctor, required this.onTap});

  final MRDoctorNetwork doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseUrl = ApiUrl.baseUrl;
    final photoPath = doctor.profilePhoto ?? '';
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
                    if (doctor.qualification != null && doctor.qualification!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Qualification: ${doctor.qualification}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                    if (doctor.experience != null && doctor.experience!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Experience: ${doctor.experience} yrs',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                    if (doctor.description != null && doctor.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Description: ${doctor.description}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                    if (doctor.chambers != null && doctor.chambers!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Chamber: ${doctor.chambers!.first.name}, ${doctor.chambers!.first.address} (${doctor.chambers!.first.phone})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Phone and MR Info
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
                    'MR: ${doctor.mrId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: AppColors.quaternary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (doctor.email != null && doctor.email!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        doctor.email!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ),
                  if (doctor.address != null && doctor.address!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        doctor.address!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.quaternary,
                        ),
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
