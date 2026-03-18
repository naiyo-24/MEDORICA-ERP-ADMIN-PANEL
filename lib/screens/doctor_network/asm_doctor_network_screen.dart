import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/doctor_network/asm/asm_doctor_cards.dart';
import '../../cards/doctor_network/asm/asm_doctor_details_card.dart';
import '../../cards/doctor_network/asm/asm_doctor_search_filter_card.dart';
import '../../models/doctor_network/asm_doctor_network.dart';
import '../../providers/doctor_network/asm_doctor_network_provider.dart';
import '../../providers/onboarding/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMDoctorNetworkScreen extends ConsumerStatefulWidget {
  const ASMDoctorNetworkScreen({super.key});

  @override
  ConsumerState<ASMDoctorNetworkScreen> createState() =>
      _ASMDoctorNetworkScreenState();
}

class _ASMDoctorNetworkScreenState
    extends ConsumerState<ASMDoctorNetworkScreen> {
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
      currentItemKey: 'asm_doctor_networks',
    );
    if (handled) {
      return;
    }

    setState(() {
      _selectedNavKey = itemKey;
    });
  }

  void _showDoctorDetails(ASMDoctorNetwork doctor) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ASMDoctorDetailsCard(doctor: doctor),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(asmDoctorNetworkNotifierProvider.notifier).loadDoctorList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorList = ref.watch(asmDoctorListProvider);
    final doctorCount = ref.watch(asmDoctorCountProvider);
    final asmList = ref.watch(asmListProvider);
    final asmNames = ['All ASMs', ...asmList.map((a) => a.name).toSet()];
    final departmentOptions = ref.watch(uniqueASMDepartmentsProvider);
    final notifier = ref.read(asmDoctorNetworkNotifierProvider.notifier);
    final state = ref.watch(asmDoctorNetworkNotifierProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Doctor Network',
        subtitle: 'Manage doctors added by Area Sales Managers',
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
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ASMDoctorSearchFilterCard(
                  onSearchChanged: (query) {
                    notifier.setSearchQuery(query);
                    notifier.loadDoctorList(asmId: state.selectedASM);
                  },
                  onASMFilterChanged: (asm) {
                    notifier.setSelectedASM(asm);
                    notifier.loadDoctorList(asmId: asm);
                  },
                  onDepartmentFilterChanged: (dept) {
                    notifier.setSelectedDepartment(dept);
                  },
                  asmOptions: asmNames,
                  departmentOptions: departmentOptions,
                  selectedASM: state.selectedASM.isEmpty
                      ? 'All ASMs'
                      : state.selectedASM,
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
                      return ASMDoctorCard(
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
