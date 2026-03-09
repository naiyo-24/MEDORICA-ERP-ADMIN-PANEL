import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/team.dart';
import '../../theme/app_theme.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    required this.onViewMembers,
    required this.onViewDescription,
    required this.onEdit,
    required this.onDelete,
  });

  final Team team;
  final VoidCallback onViewMembers;
  final VoidCallback onViewDescription;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  team.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Edit Team',
                onPressed: onEdit,
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
              ),
              IconButton(
                tooltip: 'Delete Team',
                onPressed: onDelete,
                icon: const Icon(Iconsax.trash, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Iconsax.user, size: 16, color: AppColors.quaternary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Team Leader: ${team.leaderASMName}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(
                Iconsax.profile_2user,
                size: 16,
                color: AppColors.quaternary,
              ),
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
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OutlinedButton.icon(
                onPressed: onViewMembers,
                icon: const Icon(Iconsax.people),
                label: const Text('View Members'),
              ),
              OutlinedButton.icon(
                onPressed: onViewDescription,
                icon: const Icon(Iconsax.document_text),
                label: const Text('View Description'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
