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

              if (distributor == null) {
                await notifier.createDistributor(
                  name: data.name,
                  city: data.city,
                  stateName: data.state,
                  address: data.address,
                  email: data.email,
                  phone: data.phone,
                  imageBytes: data.imageBytes,
                  imageFileName: data.imageFileName,
                );
              } else {
                await notifier.updateDistributor(
                  id: distributor.id,
                  name: data.name,
                  city: data.city,
                  stateName: data.state,
                  address: data.address,
                  email: data.email,
                  phone: data.phone,
                  imageBytes: data.imageBytes,
                  imageFileName: data.imageFileName,
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
        .deleteDistributor(distributor.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Distributor removed.')));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(distributorNotifierProvider);
    final states = ref.watch(distributorStatesProvider);
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
                DistributorSearchFilterCard(
                  searchController: _searchController,
                  availableStates: states,
                  selectedState: state.selectedState,
                  onSearchChanged: (value) => ref
                      .read(distributorNotifierProvider.notifier)
                      .setSearchQuery(value),
                  onStateChanged: (value) => ref
                      .read(distributorNotifierProvider.notifier)
                      .setStateFilter(value),
                  onOnboardPressed: () => _showCreateEditDialog(),
                ),
                const SizedBox(height: AppSpacing.lg),
                DistributorCards(
                  distributors: distributors,
                  onView: _showDetailDialog,
                  onEdit: (item) => _showCreateEditDialog(distributor: item),
                  onDelete: _deleteDistributor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
