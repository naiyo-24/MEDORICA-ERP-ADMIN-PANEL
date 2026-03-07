import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorDetailCard extends StatelessWidget {
  const DistributorDetailCard({super.key, required this.distributor});

  final Distributor distributor;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColorDark,
              blurRadius: 22,
              offset: Offset(0, 10),
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
                    distributor.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 26,
                      color: AppColors.primary,
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
            _DetailRow(
              icon: Iconsax.location,
              title: 'Location',
              value: '${distributor.address}, ${distributor.locationLabel}',
            ),
            _DetailRow(
              icon: Iconsax.sms,
              title: 'Email',
              value: distributor.email,
            ),
            _DetailRow(
              icon: Iconsax.call,
              title: 'Phone',
              value: distributor.phone,
            ),
            _DetailRow(
              icon: Iconsax.timer_1,
              title: 'Expected Delivery',
              value: distributor.expectedDeliveryTime,
            ),
            _DetailRow(
              icon: Iconsax.money_3,
              title: 'Minimum Order Value',
              value: 'INR ${distributor.minimumOrderValue.toStringAsFixed(0)}',
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      _launch('mailto:${distributor.email}', context),
                  icon: const Icon(Iconsax.sms),
                  label: const Text('Mail'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launch('tel:${distributor.phone}', context),
                  icon: const Icon(Iconsax.call),
                  label: const Text('Call'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _launch(
                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(distributor.mapsQuery)}',
                    context,
                  ),
                  icon: const Icon(Iconsax.map_1),
                  label: const Text('Open In Maps'),
                ),
              ],
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
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.quaternary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$title: ',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
