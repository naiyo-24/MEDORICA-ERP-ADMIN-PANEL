import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/doctor_network/mr/mr_doctor_cards.dart';
import '../../cards/doctor_network/mr/mr_doctor_details_card.dart';
import '../../cards/doctor_network/mr/mr_doctor_search_filter_card.dart';
import '../../models/doctor_network/mr_doctor_network.dart';
import '../../providers/doctor_network/mr_doctor_network_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

import '../../widgets/loader.dart';

class MRDoctorNetworkScreen extends ConsumerStatefulWidget {
  const MRDoctorNetworkScreen({super.key});

  @override
  ConsumerState<MRDoctorNetworkScreen> createState() =>
      _MRDoctorNetworkScreenState();
}

class _MRDoctorNetworkScreenState extends ConsumerState<MRDoctorNetworkScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.dashboard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mrDoctorNetworkNotifierProvider.notifier).loadAllDoctors();
    });
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
      currentItemKey: 'mr_doctor_networks',
    );
    if (handled) {
      return;
    }

    setState(() {
      _selectedNavKey = itemKey;
    });
  }

  void _showDoctorDetails(MRDoctorNetwork doctor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: MRDoctorDetailsCard(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorList = ref.watch(mrDoctorListProvider);
    final doctorCount = ref.watch(mrDoctorCountProvider);
    final mrOptions = ref.watch(uniqueMRsProvider);
    final departmentOptions = ref.watch(uniqueDepartmentsProvider);
    final notifier = ref.read(mrDoctorNetworkNotifierProvider.notifier);
    final state = ref.watch(mrDoctorNetworkNotifierProvider);
    final isLoading = ref.watch(mrDoctorNetworkIsLoadingProvider);

    ref.listen(mrDoctorNetworkNotifierProvider.select((s) => s.error), (
      prev,
      next,
    ) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Doctor Network',
        subtitle: 'Manage doctors added by Medical Representatives',
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
      body: isLoading
          ? const Center(child: MedoricaLoader())
          : SingleChildScrollView(
              padding: AppLayout.screenPadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppLayout.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MRDoctorSearchFilterCard(
                        onSearchChanged: (query) {
                          notifier.setSearchQuery(query);
                        },
                        onMRFilterChanged: (mr) {
                          notifier.setSelectedMR(mr);
                        },
                        onDepartmentFilterChanged: (dept) {
                          notifier.setSelectedDepartment(dept);
                        },
                        mrOptions: mrOptions,
                        departmentOptions: departmentOptions,
                        selectedMR: state.selectedMR.isEmpty
                            ? 'All MRs'
                            : state.selectedMR,
                        selectedDepartment: state.selectedDepartment.isEmpty
                            ? 'All Departments'
                            : state.selectedDepartment,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Doctor Count
                      Text(
                        '$doctorCount ${doctorCount == 1 ? 'Doctor' : 'Doctors'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.quaternary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      if (doctorList.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xl,
                          ),
                          child: Center(
                            child: Text(
                              'No doctors found',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppColors.quaternary),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: doctorList.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final doctor = doctorList[index];
                            return MRDoctorCard(
                              doctor: doctor,
                              onTap: () => _showDoctorDetails(doctor),
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
