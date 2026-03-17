import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance/mr_attendance.dart';
import '../../../models/onboarding/mr.dart';
import '../../../providers/mr_attendance_provider.dart';
import '../../../providers/mr_onboarding_provider.dart';
import '../../../services/api_url.dart';
import '../../../theme/app_theme.dart';

class MRAttendanceCard extends ConsumerWidget {
  const MRAttendanceCard({
    super.key,
    required this.attendance,
    required this.onClose,
  });

  final MRAttendance attendance;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSaving = ref.watch(mrAttendanceNotifierProvider).isSaving;

    // Fetch MR name from provider
    final mrList = ref.watch(mrListProvider);
        final mr = mrList.firstWhere(
          (m) => m.mrId == attendance.mrId,
          orElse: () => MR(
            mrId: attendance.mrId,
            name: attendance.mrName,
            phone: '',
            password: '',
          ),
        );
    final mrName = mr.name;

    // Helper to build selfie image from backend
    Widget buildSelfie(String? selfiePath) {
      if (selfiePath == null || selfiePath.isEmpty) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.camera, size: 40, color: AppColors.quaternary),
              const SizedBox(height: AppSpacing.xs),
              Text('No selfie', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.quaternary)),
            ],
          ),
        );
      }
      final url = selfiePath.startsWith('http') ? selfiePath : '${Uri.parse(ApiUrl.baseUrl).origin}/$selfiePath';
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Image.network(
          url,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 150,
            height: 150,
            color: AppColors.surface,
            child: Icon(Icons.broken_image, color: AppColors.error),
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withAlpha(204)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  topRight: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Iconsax.calendar_1,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attendance Details',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d, y').format(attendance.date),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.white.withAlpha(230),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.white),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MR Name
                    _DetailRow(
                      icon: Iconsax.user,
                      label: 'MR Name',
                      value: mrName,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Status
                    _DetailRow(
                      icon: Iconsax.status,
                      label: 'Status',
                      value: attendance.isPresent ? 'Present' : 'Absent',
                      valueColor: attendance.isPresent
                          ? Colors.green
                          : AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (attendance.isPresent) ...[
                      // Check-in Section
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.login,
                                  size: 20,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Check-In Details',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (attendance.checkInTime != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.clock,
                                    size: 16,
                                    color: AppColors.quaternary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Check-In Time:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.quaternary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    DateFormat(
                                      'hh:mm a',
                                    ).format(attendance.checkInTime!),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            Text(
                              'Check-In Selfie:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.quaternary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            buildSelfie(attendance.checkInSelfieFileName),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Check-out Section
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Iconsax.logout,
                                  size: 20,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Check-Out Details',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (attendance.checkOutTime != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.clock,
                                    size: 16,
                                    color: AppColors.quaternary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Check-Out Time:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.quaternary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    DateFormat(
                                      'hh:mm a',
                                    ).format(attendance.checkOutTime!),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            Text(
                              'Check-Out Selfie:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.quaternary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            buildSelfie(attendance.checkOutSelfieFileName),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Remarks
                    if (attendance.remarks != null &&
                        attendance.remarks!.isNotEmpty) ...[
                      _DetailRow(
                        icon: Iconsax.note_text,
                        label: 'Remarks',
                        value: attendance.remarks!,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    // Action Buttons
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    await ref
                                        .read(
                                          mrAttendanceNotifierProvider.notifier,
                                        )
                                        .markAttendance(
                                          mrId: attendance.mrId,
                                          attendanceId: int.tryParse(attendance.id) ?? 0,
                                          isPresent: true,
                                        );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Marked as Present'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Iconsax.tick_circle, size: 20),
                                      SizedBox(width: AppSpacing.xs),
                                      Text('Mark Present'),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    await ref
                                        .read(
                                          mrAttendanceNotifierProvider.notifier,
                                        )
                                        .markAttendance(
                                          mrId: attendance.mrId,
                                          attendanceId: int.tryParse(attendance.id) ?? 0,
                                          isPresent: false,
                                        );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Marked as Absent'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Iconsax.close_circle, size: 20),
                                      SizedBox(width: AppSpacing.xs),
                                      Text('Mark Absent'),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
