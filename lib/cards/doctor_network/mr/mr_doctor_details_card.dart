import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/mr_doctor_network.dart';
import '../../../theme/app_theme.dart';

class MRDoctorDetailsCard extends StatelessWidget {
  const MRDoctorDetailsCard({super.key, required this.doctor});

  final MRDoctorNetwork doctor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 900),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColorDark,
              blurRadius: 30,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Iconsax.user,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.doctorName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor.specialization,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        theme,
                        Iconsax.call,
                        'Phone',
                        doctor.phoneNo,
                      ),
                      _buildDetailRow(
                        theme,
                        Iconsax.sms,
                        'Email',
                        doctor.email ?? 'N/A',
                      ),
                      _buildDetailRow(
                        theme,
                        Iconsax.location,
                        'Address',
                        doctor.address ?? 'N/A',
                      ),
                      _buildDetailRow(
                        theme,
                        Iconsax.hospital,
                        'Specialization',
                        doctor.specialization,
                      ),
                      _buildDetailRow(
                        theme,
                        Iconsax.timer_1,
                        'Experience',
                        '${doctor.experience ?? 'N/A'} years',
                      ),
                      _buildDetailRow(
                        theme,
                        Iconsax.award,
                        'Qualification',
                        doctor.qualification ?? 'N/A',
                      ),
                      _buildDetailRow(
                        theme,
                        Iconsax.user,
                        'MR ID',
                        doctor.mrId,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Description
                      Text(
                        'Description',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          doctor.description ?? 'No description available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Chambers
                      Text(
                        'Chambers',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...(doctor.chambers ?? []).asMap().entries.map((entry) {
                        final chamber = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.sm,
                                        ),
                                      ),
                                      child: const Icon(
                                        Iconsax.building,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        chamber.name,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.location,
                                      size: 14,
                                      color: AppColors.quaternary,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        chamber.address,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              fontSize: 13,
                                              color: AppColors.quaternary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.call,
                                      size: 14,
                                      color: AppColors.quaternary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      chamber.phone,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontSize: 13,
                                            color: AppColors.quaternary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: AppColors.quaternary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
