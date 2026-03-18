import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/chemist_shop/mr_chemist_shop.dart';
import '../../../theme/app_theme.dart';
import '../../../services/api_url.dart';

class MRChemistShopCard extends StatelessWidget {
  const MRChemistShopCard({super.key, required this.shop});

  final MRChemistShop shop;

  void _launchBankPhoto(BuildContext context) async {
    final baseUrl = ApiUrl.baseUrl;
    final path = shop.bankPassbookPhoto ?? '';
    if (path.isEmpty) return;
    final url = path.startsWith('http') ? path : '$baseUrl/$path';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch bank details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.md),
            ),
            child: Image.network(
              shop.shopPhoto,
              width: double.infinity,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 190,
                color: AppColors.surface200,
                alignment: Alignment.center,
                child: const Icon(
                  Iconsax.gallery_slash,
                  size: 44,
                  color: AppColors.quaternary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.shopName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _Line(
                  icon: Iconsax.call,
                  label: 'Phone No',
                  value: shop.shopPhone,
                ),
                _Line(icon: Iconsax.sms, label: 'Email', value: shop.shopEmail),
                _Line(
                  icon: Iconsax.location,
                  label: 'Location',
                  value: shop.location,
                ),
                _Line(
                  icon: Iconsax.note_2,
                  label: 'Description',
                  value: shop.description,
                ),
                const Divider(color: AppColors.border),
                _Line(
                  icon: Iconsax.user,
                  label: 'Doctor Name',
                  value: shop.doctorName,
                ),
                _Line(
                  icon: Iconsax.call_calling,
                  label: 'Doctor Phone No',
                  value: shop.doctorPhone,
                ),
                _Line(
                  icon: Iconsax.profile_2user,
                  label: 'Added By MR',
                  value: shop.mrAddedBy,
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => _launchBankPhoto(context),
                  child: const Text('View Bank Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.quaternary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(color: AppColors.primary),
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
