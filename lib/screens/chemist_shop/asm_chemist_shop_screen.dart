import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/chemist_shop/asm/asm_chemist_shop_card.dart';
import '../../cards/chemist_shop/asm/asm_chemist_shop_filter_card.dart';
import '../../providers/asm_chemist_shop_provider.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMChemistShopScreen extends ConsumerStatefulWidget {
  const ASMChemistShopScreen({super.key});

  @override
  ConsumerState<ASMChemistShopScreen> createState() =>
      _ASMChemistShopScreenState();
}

class _ASMChemistShopScreenState extends ConsumerState<ASMChemistShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.asmShopNetwork;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.asmShopNetwork,
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
    final shops = ref.watch(asmChemistShopListProvider);
    final count = ref.watch(asmChemistShopCountProvider);
    final locations = ref.watch(asmChemistLocationsProvider);
    final asmList = ref.watch(asmListProvider);
    final state = ref.watch(asmChemistShopNotifierProvider);
    final notifier = ref.read(asmChemistShopNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Chemist Shop Network',
        subtitle: 'Manage chemist shops associated with Area Sales Managers',
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
                ASMChemistShopFilterCard(
                  asmList: asmList,
                  locationOptions: locations,
                  selectedASMId: state.selectedASMId,
                  selectedLocation: state.selectedLocation,
                  onSearchChanged: notifier.setSearchQuery,
                  onASMChanged: notifier.setSelectedASMId,
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
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return ASMChemistShopCard(shop: shops[index]);
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
