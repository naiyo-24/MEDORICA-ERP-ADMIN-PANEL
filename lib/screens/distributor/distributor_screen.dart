import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/distributor/add_edit_distributor_card.dart';
import '../../cards/distributor/distributor_cards.dart';
import '../../cards/distributor/distributor_detail_card.dart';
import '../../cards/distributor/distributor_search_filter_card.dart';
import '../../models/distributor.dart';
import '../../providers/distributor_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class DistributorScreen extends ConsumerStatefulWidget {
  const DistributorScreen({super.key});

  @override
  ConsumerState<DistributorScreen> createState() => _DistributorScreenState();
}

class _DistributorScreenState extends ConsumerState<DistributorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.distributorManagement,
    );
    if (handled) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemKey module will be available soon.')),
    );
  }

  Future<void> _showCreateEditDialog({Distributor? distributor}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: AddEditDistributorCard(
            initialDistributor: distributor,
            onSubmit: (data) async {
              final notifier = ref.read(distributorNotifierProvider.notifier);

              try {
                if (distributor == null) {
                  await notifier.createDistributor(
                    distName: data.distName,
                    distPhoneNo: data.distPhoneNo,
                    distLocation: data.distLocation,
                    distProducts: data.distProducts,
                    paymentTerms: data.paymentTerms,
                    distEmail: data.distEmail,
                    distDescription: data.distDescription,
                    distMinOrderValueRupees: data.distMinOrderValueRupees,
                    distExpectedDeliveryTimeDays:
                        data.distExpectedDeliveryTimeDays,
                    bankName: data.bankName,
                    bankAcNo: data.bankAcNo,
                    branchName: data.branchName,
                    ifscCode: data.ifscCode,
                    deliveryTerritories: data.deliveryTerritories,
                    photoBytes: data.photoBytes,
                    photoFileName: data.photoFileName,
                  );
                } else {
                  await notifier.updateDistributor(
                    distId: distributor.distId,
                    distName: data.distName,
                    distPhoneNo: data.distPhoneNo,
                    distLocation: data.distLocation,
                    distEmail: data.distEmail,
                    distDescription: data.distDescription,
                    distMinOrderValueRupees: data.distMinOrderValueRupees,
                    distProducts: data.distProducts,
                    distExpectedDeliveryTimeDays:
                        data.distExpectedDeliveryTimeDays,
                    paymentTerms: data.paymentTerms,
                    bankName: data.bankName,
                    bankAcNo: data.bankAcNo,
                    branchName: data.branchName,
                    ifscCode: data.ifscCode,
                    deliveryTerritories: data.deliveryTerritories,
                    photoBytes: data.photoBytes,
                    photoFileName: data.photoFileName,
                  );
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        distributor == null
                            ? 'Distributor onboarded successfully.'
                            : 'Distributor updated successfully.',
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _showDetailDialog(Distributor distributor) async {
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        child: DistributorDetailCard(distributor: distributor),
      ),
    );
  }

  void _deleteDistributor(Distributor distributor) {
    ref
        .read(distributorNotifierProvider.notifier)
        .deleteDistributor(distributor.distId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Distributor removed.')));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(distributorNotifierProvider);
    final isLoading = state.isLoading && !state.hasLoadedOnce;
    final isSaving = state.isSaving;
    final error = state.error;
    final distributors = ref.watch(filteredDistributorsProvider);

    if (_searchController.text != state.searchQuery) {
      _searchController
        ..text = state.searchQuery
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: state.searchQuery.length),
        );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Distributor Management',
        subtitle: 'Search, onboard and maintain distributor directory',
        showLogo: false,
        showSubtitle: true,
        showMenuButton: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: SideNavItemKeys.distributorManagement,
          onItemTap: _onNavTap,
        ),
      ),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: MedoricaLoader(
                title: 'Loading Distributors',
                subtitle: 'Fetching distributor information...',
              ),
            )
          else if (error != null)
            Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Error Loading Distributors',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          error,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(distributorNotifierProvider.notifier)
                                .refreshDistributors();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
          else
            SingleChildScrollView(
              padding: AppLayout.screenPadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppLayout.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DistributorSearchFilterCard(
                        searchController: _searchController,
                        onSearchChanged: (value) => ref
                            .read(distributorNotifierProvider.notifier)
                            .setSearchQuery(value),
                        onOnboardPressed: () => _showCreateEditDialog(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (state.isLoading && state.hasLoadedOnce)
                        const Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: MedoricaLoader(
                            compact: true,
                            title: 'Updating',
                          ),
                        )
                      else
                        DistributorCards(
                          distributors: distributors,
                          onView: _showDetailDialog,
                          onEdit: (item) =>
                              _showCreateEditDialog(distributor: item),
                          onDelete: _deleteDistributor,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          if (isSaving)
            Container(
              color: Colors.black.withValues(alpha: 0.25),
              child: const Center(
                child: MedoricaLoader(
                  compact: true,
                  title: 'Saving Distributor',
                  subtitle: 'Please wait while we process your request...',
                ),
              ),
            ),
        ],
      ),
    );
  }

}
