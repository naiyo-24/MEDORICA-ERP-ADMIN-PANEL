import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/gift/mr/mr_gift_application_card.dart';
import '../../cards/gift/mr/mr_gift_application_filter_card.dart';
import '../../providers/gift/mr_gift_application_provider.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRGiftApplicationsScreen extends ConsumerStatefulWidget {
  const MRGiftApplicationsScreen({super.key});

  @override
  ConsumerState<MRGiftApplicationsScreen> createState() =>
      _MRGiftApplicationsScreenState();
}

class _MRGiftApplicationsScreenState
    extends ConsumerState<MRGiftApplicationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrGiftApplications;

  void _onMenuTap() => _scaffoldKey.currentState?.openDrawer();

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrGiftApplications,
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
    final applications = ref.watch(mrGiftApplicationListProvider);
    final count = ref.watch(mrGiftApplicationCountProvider);
    final mrOptions = ref.watch(mrListProvider);
    final doctorOptions = ref.watch(mrGiftDoctorOptionsProvider);
    final state = ref.watch(mrGiftApplicationNotifierProvider);
    final notifier = ref.read(mrGiftApplicationNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Gift Applications',
        subtitle: 'Review and update gift requests raised by MRs',
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
                MRGiftApplicationFilterCard(
                  mrOptions: mrOptions,
                  doctorOptions: doctorOptions,
                  selectedMRId: state.selectedMRId,
                  selectedDoctor: state.selectedDoctorName,
                  onSearchChanged: notifier.setSearchQuery,
                  onMRChanged: notifier.setSelectedMRId,
                  onDoctorChanged: notifier.setSelectedDoctorName,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$count ${count == 1 ? 'Application' : 'Applications'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (applications.isEmpty)
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
                        'No MR gift applications found',
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
                    itemCount: applications.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final app = applications[index];
                      return MRGiftApplicationCard(
                        application: app,
                        onStatusChanged: (status) {
                          notifier.updateStatus(
                            applicationId: app.id,
                            status: status,
                          );
                        },
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
