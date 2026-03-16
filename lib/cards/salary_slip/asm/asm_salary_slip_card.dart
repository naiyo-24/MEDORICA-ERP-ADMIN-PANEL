import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/salary_slip/asm_salary_slip.dart';
import '../../../services/api_url.dart';
import '../../../theme/app_theme.dart';

class ASMSalarySlipCard extends StatelessWidget {
  const ASMSalarySlipCard({
    super.key,
    required this.salarySlip,
    required this.onUpload,
    required this.onView,
    required this.onDelete,
  });

  final ASMSalarySlip salarySlip;
  final Future<void> Function(String asmId, PlatformFile file) onUpload;
  final VoidCallback onView;
  final VoidCallback onDelete;

  Future<void> _handleUpload(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.bytes == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to read file. Please try another PDF.'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        await onUpload(salarySlip.asmId, file);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Salary slip "${file.name}" uploaded.'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileUrl = ApiUrl.getProfilePhotoUrl(salarySlip.asmProfilePhoto);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: AppColors.primary.withAlpha(26), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: profileUrl.isEmpty
                    ? const Icon(
                        Iconsax.profile_circle,
                        color: AppColors.primary,
                        size: 24,
                      )
                    : Image.network(
                        profileUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Iconsax.profile_circle,
                          color: AppColors.primary,
                          size: 24,
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
                    salarySlip.asmName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'ASM ID: ${salarySlip.asmId}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Phone: ${salarySlip.asmPhone}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  if (salarySlip.hasFile) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
                        Icon(
                          Iconsax.tick_circle5,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            salarySlip.fileName ?? 'Salary slip available',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _handleUpload(context),
              icon: const Icon(Iconsax.document_upload, size: 18),
              label: const Text('Upload'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ElevatedButton.icon(
              onPressed: salarySlip.hasFile ? onView : null,
              icon: const Icon(Iconsax.eye, size: 18),
              label: const Text('View'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                disabledBackgroundColor: AppColors.primary.withAlpha(77),
                disabledForegroundColor: AppColors.surface.withAlpha(128),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: salarySlip.hasFile ? onDelete : null,
              icon: const Icon(Iconsax.trash, size: 18),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
