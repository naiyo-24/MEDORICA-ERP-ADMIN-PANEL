import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/onboarding/asm/asm_card.dart';
import '../../cards/onboarding/asm/asm_details_card.dart';
import '../../cards/onboarding/asm/asm_search_filter_card.dart';
import '../../cards/onboarding/asm/onboard_edit_asm_card.dart';
import '../../models/asm.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMOnboardingScreen extends ConsumerStatefulWidget {
  const ASMOnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ASMOnboardingScreenState();
}

class _ASMOnboardingScreenState extends ConsumerState<ASMOnboardingScreen> {
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
      currentItemKey: SideNavItemKeys.asmOnboarding,
    );
    if (handled) {
      return;
    }

    setState(() {
      _selectedNavKey = itemKey;
    });
  }

  void _showASMDetails(ASM asm) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ASMDetailsCard(asm: asm),
      ),
    );
  }

  void _showOnboardEditForm({ASM? asm}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: OnboardEditASMCard(
          initialASM: asm,
          onSubmit: (formData) async {
            if (asm != null) {
              // Update existing ASM
              final updatedASM = asm.copyWith(
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
                  .read(asmOnboardingNotifierProvider.notifier)
                  .updateASM(asm: updatedASM);
            } else {
              // Add new ASM
              final newASM = ASM(
                id: 'asm_${DateTime.now().millisecondsSinceEpoch}',
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
                  .read(asmOnboardingNotifierProvider.notifier)
                  .addASM(asm: newASM);
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    asm != null
                        ? 'ASM updated successfully'
                        : 'ASM onboarded successfully',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _deleteASM(ASM asm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete ASM'),
        content: Text('Are you sure you want to delete ${asm.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(asmOnboardingNotifierProvider.notifier)
                  .deleteASM(asmId: asm.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ASM deleted successfully')),
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
    final asmList = ref.watch(asmListProvider);
    final notifier = ref.read(asmOnboardingNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Onboarding',
        subtitle: 'Manage and onboard Area Sales Managers',
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
                ASMSearchFilterCard(
                  onSearchChanged: (query) {
                    notifier.setSearchQuery(query);
                  },
                  onOnboardPressed: () => _showOnboardEditForm(),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (asmList.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Center(
                      child: Text(
                        'No ASMs found',
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
                    itemCount: asmList.length,
                    itemBuilder: (context, index) {
                      final asm = asmList[index];
                      return ASMCard(
                        asm: asm,
                        onTap: () => _showASMDetails(asm),
                        onEdit: () => _showOnboardEditForm(asm: asm),
                        onDelete: () => _deleteASM(asm),
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
