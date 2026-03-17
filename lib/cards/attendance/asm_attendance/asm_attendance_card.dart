import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance/asm_attendance.dart';
import '../../../providers/asm_attendance_provider.dart';
import '../../../theme/app_theme.dart';

class ASMAttendanceCard extends ConsumerWidget {
  const ASMAttendanceCard({
    super.key,
    required this.attendance,
    required this.onClose,
  });

  final ASMAttendance attendance;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSaving = ref.watch(asmAttendanceNotifierProvider).isSaving;

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
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
                      borderRadius: BorderRadius.circular(AppRadius.md),
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
                          'ASM Attendance Details',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
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
                    // ASM Name
                    _DetailRow(
                      icon: Iconsax.user_octagon,
                      label: 'ASM Name',
                      value: attendance.asmName,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Status
                    _DetailRow(
                      icon: attendance.isPresent
                          ? Iconsax.tick_circle
                          : Iconsax.close_circle,
                      label: 'Status',
                      value: attendance.isPresent ? 'Present' : 'Absent',
                      valueColor: attendance.isPresent
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (attendance.isPresent) ...[
                      // Check In Time
                      if (attendance.checkInTime != null) ...[
                        _DetailRow(
                          icon: Iconsax.login,
                          label: 'Check In Time',
                          value: DateFormat(
                            'hh:mm a',
                          ).format(attendance.checkInTime!),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Check In Selfie
                      if (attendance.checkInSelfie != null) ...[
                        Text(
                          'Check In Selfie',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (attendance.checkInSelfieFileName != null) ...[
                          Text(
                            attendance.checkInSelfieFileName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.quaternary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            color: AppColors.surface,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.memory(
                              attendance.checkInSelfie!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ] else ...[
                        _DetailRow(
                          icon: Iconsax.camera,
                          label: 'Check In Selfie',
                          value: 'Not uploaded',
                          valueColor: AppColors.quaternary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Check Out Time
                      if (attendance.checkOutTime != null) ...[
                        _DetailRow(
                          icon: Iconsax.logout,
                          label: 'Check Out Time',
                          value: DateFormat(
                            'hh:mm a',
                          ).format(attendance.checkOutTime!),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Check Out Selfie
                      if (attendance.checkOutSelfie != null) ...[
                        Text(
                          'Check Out Selfie',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        if (attendance.checkOutSelfieFileName != null) ...[
                          Text(
                            attendance.checkOutSelfieFileName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.quaternary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            color: AppColors.surface,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.memory(
                              attendance.checkOutSelfie!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ] else ...[
                        _DetailRow(
                          icon: Iconsax.camera,
                          label: 'Check Out Selfie',
                          value: 'Not uploaded',
                          valueColor: AppColors.quaternary,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],

                    // Remarks
                    if (attendance.remarks != null &&
                        attendance.remarks!.isNotEmpty) ...[
                      _DetailRow(
                        icon: Iconsax.message_text,
                        label: 'Remarks',
                        value: attendance.remarks!,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],

                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    // Admin Actions
                    Text(
                      'Admin Actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    await ref
                                        .read(
                                          asmAttendanceNotifierProvider
                                              .notifier,
                                        )
                                        .markAttendance(
                                          asmId: attendance.asmId,
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
                                      onClose();
                                    }
                                  },
                            icon: isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Iconsax.tick_circle, size: 20),
                            label: const Text('Mark Present'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    await ref
                                        .read(
                                          asmAttendanceNotifierProvider
                                              .notifier,
                                        )
                                        .markAttendance(
                                          asmId: attendance.asmId,
                                          attendanceId: int.tryParse(attendance.id) ?? 0,
                                          isPresent: false,
                                        );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Marked as Absent'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      onClose();
                                    }
                                  },
                            icon: isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Iconsax.close_circle, size: 20),
                            label: const Text('Mark Absent'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
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
                  color: AppColors.quaternary.withAlpha(230),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: valueColor ?? AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
