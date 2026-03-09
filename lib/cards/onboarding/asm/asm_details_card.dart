import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm.dart';
import '../../../services/api_url.dart';
import '../../../theme/app_theme.dart';

class ASMDetailsCard extends StatelessWidget {
  const ASMDetailsCard({super.key, required this.asm});

  final ASM asm;

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return 'ASM';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initialsFromName(asm.name);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 620,
        constraints: const BoxConstraints(maxHeight: 700),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF60737C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.close_circle,
                              color: AppColors.white,
                              size: 19,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            child: asm.photoBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                    child: Image.memory(
                                      asm.photoBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : (asm.profilePhoto != null &&
                                      asm.profilePhoto!.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                    child: Image.network(
                                      ApiUrl.getProfilePhotoUrl(
                                        asm.profilePhoto,
                                      ),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                initials,
                                                style: theme
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      color: AppColors.white,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors.white,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      initials,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            color: AppColors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asm.name,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontSize: 26,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  asm.headquarterAssigned ?? 'Not assigned',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(
                        icon: Iconsax.profile_2user,
                        label: 'Name',
                        value: asm.name,
                      ),
                      _DetailRow(
                        icon: Iconsax.call,
                        label: 'Phone',
                        value: asm.phone,
                      ),
                      _DetailRow(
                        icon: Iconsax.call,
                        label: 'Alt Phone',
                        value: asm.altPhone ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.sms,
                        label: 'Email',
                        value: asm.email ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.location,
                        label: 'Address',
                        value: asm.address ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.building_4,
                        label: 'Headquarters',
                        value: asm.headquarterAssigned ?? 'Not assigned',
                      ),
                      _DetailRow(
                        icon: Iconsax.map,
                        label: 'Territories',
                        value:
                            asm.territoriesOfWork?.toString() ?? 'Not assigned',
                      ),
                      _DetailRow(
                        icon: Iconsax.building,
                        label: 'Bank Name',
                        value: asm.bankName ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.building,
                        label: 'Bank Branch',
                        value: asm.bankBranchName ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.card,
                        label: 'Account Number',
                        value: asm.bankAccountNumber ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.code,
                        label: 'IFSC Code',
                        value: asm.ifscCode ?? 'Not provided',
                      ),
                      _DetailRow(
                        icon: Iconsax.chart_1,
                        label: 'Monthly Target',
                        value: asm.monthlyTarget != null
                            ? '₹${asm.monthlyTarget!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.calendar,
                        label: 'Joining Date',
                        value: asm.joiningDate != null
                            ? '${asm.joiningDate!.day}-${asm.joiningDate!.month}-${asm.joiningDate!.year}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.money,
                        label: 'Basic Salary',
                        value: asm.basicSalary != null
                            ? '₹${asm.basicSalary!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.money_2,
                        label: 'Daily Allowances',
                        value: asm.dailyAllowances != null
                            ? '₹${asm.dailyAllowances!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.house,
                        label: 'HRA',
                        value: asm.hra != null
                            ? '₹${asm.hra!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.mobile,
                        label: 'Phone Allowances',
                        value: asm.phoneAllowances != null
                            ? '₹${asm.phoneAllowances!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.people,
                        label: 'Children Allowances',
                        value: asm.childrenAllowances != null
                            ? '₹${asm.childrenAllowances!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.dollar_circle,
                        label: 'Special Allowances',
                        value: asm.specialAllowances != null
                            ? '₹${asm.specialAllowances!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.hospital,
                        label: 'Medical Allowances',
                        value: asm.medicalAllowances != null
                            ? '₹${asm.medicalAllowances!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.health,
                        label: 'ESIC',
                        value: asm.esic != null
                            ? '₹${asm.esic!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.money_4,
                        label: 'Total Monthly Compensation',
                        value: asm.totalMonthlyCompensation != null
                            ? '₹${asm.totalMonthlyCompensation!.toStringAsFixed(0)}'
                            : 'Not set',
                      ),
                      _DetailRow(
                        icon: Iconsax.lock,
                        label: 'Password',
                        value: '••••••••',
                      ),
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
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
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
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.quaternary,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
