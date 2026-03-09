import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/team.dart';
import '../../theme/app_theme.dart';

class TeamDescriptionCard extends StatelessWidget {
  const TeamDescriptionCard({super.key, required this.team});

  final Team team;

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.tryParse(team.whatsappGroupLink.trim());
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid WhatsApp group link.')),
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the WhatsApp group link.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 620,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColorDark,
              blurRadius: 26,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    team.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontSize: 24,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Iconsax.close_circle),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Description',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(team.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Iconsax.profile_2user, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Total Members: ${team.totalMembers}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WhatsApp Group Link',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    team.whatsappGroupLink,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: () => _openLink(context),
                    icon: const Icon(Iconsax.link),
                    label: const Text('Open Link'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
