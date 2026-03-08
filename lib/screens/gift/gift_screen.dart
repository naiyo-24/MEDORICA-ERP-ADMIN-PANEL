import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/gift/gift/edit_create_gift_card.dart';
import '../../cards/gift/gift/gift_card.dart';
import '../../models/gift.dart';
import '../../providers/gift_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class GiftScreen extends ConsumerStatefulWidget {
  const GiftScreen({super.key});

  @override
  ConsumerState<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends ConsumerState<GiftScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.manageGifts;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.manageGifts,
    );

    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  void _showGiftForm({Gift? gift}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: EditCreateGiftCard(
          initialGift: gift,
          onSubmit: (formData) async {
            if (gift != null) {
              await ref
                  .read(giftNotifierProvider.notifier)
                  .updateGift(
                    gift: gift.copyWith(
                      itemName: formData.itemName,
                      description: formData.description,
                      quantityInInventory: formData.quantityInInventory,
                      price: formData.price,
                    ),
                  );
              return;
            }

            await ref
                .read(giftNotifierProvider.notifier)
                .addGift(
                  gift: Gift(
                    id: 'gift_${DateTime.now().millisecondsSinceEpoch}',
                    itemName: formData.itemName,
                    description: formData.description,
                    quantityInInventory: formData.quantityInInventory,
                    price: formData.price,
                    createdAt: DateTime.now(),
                  ),
                );
          },
        ),
      ),
    );
  }

  Future<void> _deleteGift(String giftId) async {
    await ref.read(giftNotifierProvider.notifier).deleteGift(giftId: giftId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gifts = ref.watch(giftListProvider);
    final giftCount = ref.watch(giftCountProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Gift Management',
        subtitle: 'Manage gift inventory and allocations for field teams',
        showLogo: false,
        showMenuButton: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: _selectedNavKey,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => _showGiftForm(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF455A64), Color(0xFF607D8B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowColorDark,
                          blurRadius: 14,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(
                            Iconsax.gift,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Create Premium Gift',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Add a new inventory item with quantity and pricing',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Iconsax.arrow_right_3,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Gift Inventory',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$giftCount ${giftCount == 1 ? 'item' : 'items'} available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (gifts.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        'No gifts added yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gifts.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final gift = gifts[index];
                      return GiftCard(
                        gift: gift,
                        onEdit: () => _showGiftForm(gift: gift),
                        onDelete: () => _deleteGift(gift.id),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
