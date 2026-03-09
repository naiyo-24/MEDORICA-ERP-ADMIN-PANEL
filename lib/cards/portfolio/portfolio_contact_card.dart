import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/portfolio.dart';
import '../../theme/app_theme.dart';

class PortfolioContactCard extends StatelessWidget {
  const PortfolioContactCard({
    super.key,
    required this.data,
    required this.onEdit,
  });

  final PortfolioData data;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Contact Details',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Edit contacts',
                onPressed: onEdit,
                icon: const Icon(Iconsax.edit, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _ContactRow(icon: Iconsax.call, label: 'Phone', value: data.phone),
          _ContactRow(icon: Iconsax.sms, label: 'Email', value: data.email),
          _ContactRow(
            icon: Iconsax.global,
            label: 'Website',
            value: data.website,
          ),
          _ContactRow(
            icon: Iconsax.location,
            label: 'Address',
            value: data.address,
          ),
          _ContactRow(
            icon: Iconsax.building,
            label: 'Office Address',
            value: data.officeAddress,
          ),
          _ContactRow(
            icon: Iconsax.instagram,
            label: 'Instagram',
            value: data.instagram,
          ),
          _ContactRow(
            icon: Icons.facebook,
            label: 'Facebook',
            value: data.facebook,
          ),
          _ContactRow(
            icon: Icons.link_off,
            label: 'LinkedIn',
            value: data.linkedin,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
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
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.quaternary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
