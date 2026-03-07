import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/onboarding/mr/mr_card.dart';
import '../../cards/onboarding/mr/mr_details_card.dart';
import '../../cards/onboarding/mr/mr_search_filter_card.dart';
import '../../cards/onboarding/mr/onboard_edit_mr_card.dart';
import '../../models/mr.dart';
import '../../providers/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MROnboardingScreen extends ConsumerStatefulWidget {
  const MROnboardingScreen({super.key});

  @override
  ConsumerState<MROnboardingScreen> createState() =>
      _MROnboardingScreenState();
}

class _MROnboardingScreenState extends ConsumerState<MROnboardingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.dashboard;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.dashboard,
    );
    if (handled) {
      return;
    }

    setState(() {
      _selectedNavKey = itemKey;
    });
  }

  void _showMRDetails(MR mr) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: MRDetailsCard(mr: mr),
      ),
    );
  }

  void _showOnboardEditForm({MR? mr}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: OnboardEditMRCard(
          initialMR: mr,
          onSubmit: (formData) async {
            if (mr != null) {
              // Update existing MR
              final updatedMR = mr.copyWith(
                name: formData.name,
                phone: formData.phone,
                altPhone: formData.altPhone,
                email: formData.email,
                address: formData.address,
                headquarterAssigned: formData.headquarterAssigned,
                territoriesOfWork: formData.territoriesOfWork,
                bankName: formData.bankName,
                bankBranchName: formData.bankBranchName,
                bankAccountNumber: formData.bankAccountNumber,
                ifscCode: formData.ifscCode,
                monthlyTarget: formData.monthlyTarget,
                password: formData.password,
                photoBytes: formData.photoBytes,
                photoFileName: formData.photoFileName,
              );
              await ref
                  .read(mrOnboardingNotifierProvider.notifier)
                  .updateMR(mr: updatedMR);
            } else {
              // Add new MR
              final newMR = MR(
                id: 'mr_${DateTime.now().millisecondsSinceEpoch}',
                name: formData.name,
                phone: formData.phone,
                altPhone: formData.altPhone,
                email: formData.email,
                address: formData.address,
                headquarterAssigned: formData.headquarterAssigned,
                territoriesOfWork: formData.territoriesOfWork,
                bankName: formData.bankName,
                bankBranchName: formData.bankBranchName,
                bankAccountNumber: formData.bankAccountNumber,
                ifscCode: formData.ifscCode,
                monthlyTarget: formData.monthlyTarget,
                password: formData.password,
                photoBytes: formData.photoBytes,
                photoFileName: formData.photoFileName,
                createdAt: DateTime.now(),
              );
              await ref
                  .read(mrOnboardingNotifierProvider.notifier)
                  .addMR(mr: newMR);
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    mr != null
                        ? 'MR updated successfully'
                        : 'MR onboarded successfully',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _deleteMR(MR mr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete MR'),
        content: Text('Are you sure you want to delete ${mr.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(mrOnboardingNotifierProvider.notifier)
                  .deleteMR(mrId: mr.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('MR deleted successfully')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mrList = ref.watch(mrListProvider);
    final notifier = ref.read(mrOnboardingNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Onboarding',
        subtitle: 'Manage and onboard Medical Representatives',
        showLogo: false,
        showSubtitle: true,
        showBackButton: false,
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
            constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MRSearchFilterCard(
                  onSearchChanged: (query) {
                    notifier.setSearchQuery(query);
                  },
                  onOnboardPressed: () => _showOnboardEditForm(),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (mrList.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Center(
                      child: Text(
                        'No MRs found',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.quaternary,
                        ),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 8 / 1,
                      mainAxisSpacing: AppSpacing.sm,
                    ),
                    itemCount: mrList.length,
                    itemBuilder: (context, index) {
                      final mr = mrList[index];
                      return MRCard(
                        mr: mr,
                        onTap: () => _showMRDetails(mr),
                        onEdit: () => _showOnboardEditForm(mr: mr),
                        onDelete: () => _deleteMR(mr),
                      );
                    },
                  ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
