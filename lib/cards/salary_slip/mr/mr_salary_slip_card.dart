import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';

import '../../../models/salary_slip/mr_salary_slip.dart';
import '../../../theme/app_theme.dart';


import '../../../services/api_url.dart';


class MRSalarySlipCard extends StatelessWidget {
  const MRSalarySlipCard({
    super.key,
    required this.salarySlip,
    required this.onUpload,
    required this.onView,
    required this.onDelete,
  });

  final MRSalarySlip salarySlip;
  final Future<void> Function(String mrId, PlatformFile file) onUpload;
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
        await onUpload(salarySlip.mrId, file);
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
    final profileUrl = ApiUrl.getProfilePhotoUrl(salarySlip.mrProfilePhoto);

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
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  NetworkImage(profileUrl),
              backgroundColor: AppColors.primary.withAlpha(40),
              child: null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salarySlip.mrName,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text('MR ID: ${salarySlip.mrId}',
                      style: theme.textTheme.bodySmall),
                  Text('Phone: ${salarySlip.mrPhone}',
                      style: theme.textTheme.bodySmall),
                  if (salarySlip.hasFile)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        salarySlip.fileName ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => _handleUpload(context),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Iconsax.eye),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                  ),
                  onPressed: salarySlip.hasFile ? onView : null,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Iconsax.trash),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  onPressed: salarySlip.hasFile ? onDelete : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
                
            