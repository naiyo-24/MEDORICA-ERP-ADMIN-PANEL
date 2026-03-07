import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/visual_ads/create_edit_visual_ads_card.dart';
import '../../cards/visual_ads/visual_ads_cards.dart';
import '../../models/visual_ads.dart';
import '../../providers/visual_ads_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class VisualAdsScreen extends ConsumerStatefulWidget {
  const VisualAdsScreen({super.key});

  @override
  ConsumerState<VisualAdsScreen> createState() => _VisualAdsScreenState();
}

class _VisualAdsScreenState extends ConsumerState<VisualAdsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.visualAdsManagement,
    );
    if (handled) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemKey module will be available soon.')),
    );
  }

  Future<void> _showCreateOrEditDialog({VisualAd? ad}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: CreateEditVisualAdsCard(
            initialAd: ad,
            onSubmit: (data) async {
              final notifier = ref.read(visualAdsNotifierProvider.notifier);

              if (ad == null) {
                await notifier.createAd(
                  name: data.name,
                  imageBytes: data.imageBytes,
                  imageFileName: data.imageFileName,
                );
              } else {
                await notifier.updateAd(
                  id: ad.id,
                  name: data.name,
                  imageBytes: data.imageBytes,
                  imageFileName: data.imageFileName,
                );
              }

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ad == null ? 'Visual ad created.' : 'Visual ad updated.',
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _deleteAd(VisualAd ad) {
    ref.read(visualAdsNotifierProvider.notifier).deleteAd(ad.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Visual ad deleted.')));
  }

  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(visualAdsListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Visual Ads Management',
        subtitle: 'Create, edit and manage campaign creatives',
        showLogo: false,
        showMenuButton: true,
        showSubtitle: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: SideNavItemKeys.visualAdsManagement,
          onItemTap: _onNavTap,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppLayout.screenPadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppButtonSize.large.height,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowColorDark,
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _showCreateOrEditDialog(),
                      icon: SizedBox(
                        width: 20,
                        height: 20,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: const [
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Icon(Iconsax.gallery, size: 16),
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Icon(Iconsax.add_circle, size: 12),
                            ),
                          ],
                        ),
                      ),
                      label: Text(
                        'Create Visual Ad',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                VisualAdsCards(
                  ads: ads,
                  onEdit: (ad) => _showCreateOrEditDialog(ad: ad),
                  onDelete: _deleteAd,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
