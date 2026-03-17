import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/chemist_shop/mr/mr_chemist_shop_card.dart';
import '../../cards/chemist_shop/mr/mr_chemist_shop_filter_card.dart';
import '../../providers/mr_chemist_shop_provider.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRChemistShopScreen extends ConsumerStatefulWidget {
  const MRChemistShopScreen({super.key});

  @override
  ConsumerState<MRChemistShopScreen> createState() =>
      _MRChemistShopScreenState();
}

class _MRChemistShopScreenState extends ConsumerState<MRChemistShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrShopNetwork;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrShopNetwork,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shops = ref.watch(mrChemistShopListProvider);
    final count = ref.watch(mrChemistShopCountProvider);
    final locations = ref.watch(mrChemistLocationsProvider);
    final mrList = ref.watch(mrListProvider);
    final state = ref.watch(mrChemistShopNotifierProvider);
    final notifier = ref.read(mrChemistShopNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Chemist Shop Network',
        subtitle:
            'Manage chemist shops associated with Medical Representatives',
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
                MRChemistShopFilterCard(
                  mrList: mrList,
                  locationOptions: locations,
                  selectedMRId: state.selectedMRId,
                  selectedLocation: state.selectedLocation,
                  onSearchChanged: notifier.setSearchQuery,
                  onMRChanged: notifier.setSelectedMRId,
                  onLocationChanged: notifier.setSelectedLocation,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$count ${count == 1 ? 'Shop' : 'Shops'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (shops.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxl,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Center(
                      child: Text(
                        'No chemist shops found for current filters',
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
                    itemCount: shops.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return MRChemistShopCard(shop: shops[index]);
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
