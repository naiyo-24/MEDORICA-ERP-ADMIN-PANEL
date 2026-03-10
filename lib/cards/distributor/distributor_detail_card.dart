import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/distributor.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class DistributorDetailCard extends StatelessWidget {
  const DistributorDetailCard({super.key, required this.distributor});

  final Distributor distributor;

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return 'D';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Future<void> _launch(String value, BuildContext context) async {
    final uri = Uri.parse(value);
    final canOpen = await canLaunchUrl(uri);
    if (!canOpen && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open this action right now.')),
      );
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _formatProducts(dynamic products) {
    if (products == null) return 'N/A';
    if (products is List) {
      return products.join(', ');
    }
    return products.toString();
  }

  String _formatTerritories(dynamic territories) {
    if (territories == null) return 'N/A';
    if (territories is List) {
      return territories.join(', ');
    }
    return territories.toString();
  }

  bool _hasBankInfo(Distributor distributor) {
    return distributor.bankName != null ||
        distributor.bankAcNo != null ||
        distributor.branchName != null ||
        distributor.ifscCode != null;
  }

  Widget _buildDistributorPhoto(BuildContext context, String initials) {
    if (distributor.distPhoto != null && distributor.distPhoto!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.network(
          ApiUrl.getProfilePhotoUrl(distributor.distPhoto!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                initials,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            );
          },
        ),
      );
    }

    if (distributor.imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Image.memory(
          distributor.imageBytes!,
          fit: BoxFit.cover,
        ),
      );
    }

    return Center(
      child: Text(
        initials,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initialsFromName(distributor.distName);

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
                            child: _buildDistributorPhoto(context, initials),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  distributor.distName,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontSize: 26,
                                      ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: AppColors.white.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Iconsax.location,
                                        color: AppColors.white,
                                        size: 15,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Flexible(
                                        child: Text(
                                          distributor.locationLabel,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
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
                      // Key Metrics
                      Row(
                        children: [
                          Expanded(
                            child: _MetricCard(
                              icon: Iconsax.timer_1,
                              label: 'Expected Delivery',
                              value:
                                  '${distributor.distExpectedDeliveryTimeDays ?? 'N/A'} days',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _MetricCard(
                              icon: Iconsax.money_3,
                              label: 'Minimum Order',
                              value:
                                  'INR ${(distributor.distMinOrderValueRupees ?? 0).toStringAsFixed(0)}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Contact Information
                      Text(
                        'Contact Information',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.quaternary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
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
                        child: Column(
                          children: [
                            _PremiumInfoTile(
                              icon: Iconsax.location,
                              title: 'Location',
                              value: distributor.distLocation ?? 'N/A',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _PremiumInfoTile(
                              icon: Iconsax.sms,
                              title: 'Email',
                              value: distributor.distEmail ?? 'N/A',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _PremiumInfoTile(
                              icon: Iconsax.call,
                              title: 'Phone',
                              value: distributor.distPhoneNo,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Products and Terms
                      Text(
                        'Products & Terms',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.quaternary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PremiumInfoTile(
                              icon: Iconsax.box_1,
                              title: 'Products',
                              value: _formatProducts(distributor.distProducts),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _PremiumInfoTile(
                              icon: Iconsax.receipt_1,
                              title: 'Payment Terms',
                              value: distributor.paymentTerms ?? 'N/A',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _PremiumInfoTile(
                              icon: Iconsax.note,
                              title: 'Description',
                              value: (distributor.distDescription != null &&
                                      distributor.distDescription!.trim().isNotEmpty)
                                  ? distributor.distDescription!
                                  : 'N/A',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Bank Information
                      if (_hasBankInfo(distributor)) ...[
                        Text(
                          'Bank Information',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
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
                          child: Column(
                            children: [
                              if (distributor.bankName != null)
                                _PremiumInfoTile(
                                  icon: Iconsax.building,
                                  title: 'Bank Name',
                                  value: distributor.bankName!,
                                ),
                              if (distributor.bankName != null &&
                                  (distributor.bankAcNo != null ||
                                      distributor.branchName != null ||
                                      distributor.ifscCode != null))
                                const SizedBox(height: AppSpacing.sm),
                              if (distributor.bankAcNo != null)
                                _PremiumInfoTile(
                                  icon: Iconsax.wallet_3,
                                  title: 'Account Number',
                                  value: distributor.bankAcNo!,
                                ),
                              if (distributor.bankAcNo != null &&
                                  (distributor.branchName != null ||
                                      distributor.ifscCode != null))
                                const SizedBox(height: AppSpacing.sm),
                              if (distributor.branchName != null)
                                _PremiumInfoTile(
                                  icon: Iconsax.location,
                                  title: 'Branch',
                                  value: distributor.branchName!,
                                ),
                              if (distributor.branchName != null &&
                                  distributor.ifscCode != null)
                                const SizedBox(height: AppSpacing.sm),
                              if (distributor.ifscCode != null)
                                _PremiumInfoTile(
                                  icon: Iconsax.security_card,
                                  title: 'IFSC Code',
                                  value: distributor.ifscCode!,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      // Delivery Territories
                      if (distributor.deliveryTerritories != null) ...[
                        Text(
                          'Delivery Territories',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
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
                            _formatTerritories(
                                distributor.deliveryTerritories),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      // Action Buttons
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          _ActionButton(
                            label: 'Mail',
                            icon: Iconsax.sms,
                            onTap: () => distributor.distEmail != null
                                ? _launch('mailto:${distributor.distEmail}',
                                    context)
                                : null,
                          ),
                          _ActionButton(
                            label: 'Call',
                            icon: Iconsax.call,
                            onTap: () =>
                                _launch('tel:${distributor.distPhoneNo}',
                                    context),
                          ),
                          _ActionButton(
                            label: 'Open In Maps',
                            icon: Iconsax.map_1,
                            isPrimary: false,
                            onTap: () => _launch(
                              'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(distributor.mapsQuery)}',
                              context,
                            ),
                          ),
                        ],
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

class _MetricCard extends StatelessWidget {
  const _MetricCard({
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primaryDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.quaternary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumInfoTile extends StatelessWidget {
  const _PremiumInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
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
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: isPrimary ? AppColors.primary : AppColors.white,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isPrimary ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isPrimary ? AppColors.white : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isPrimary ? AppColors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
