import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/appointments/mr/mr_appointment_card.dart';
import '../../cards/appointments/mr/mr_appointment_filter_card.dart';
import '../../providers/appointment/mr_appointments_provider.dart';
import '../../providers/onboarding/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/loader.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRAppointmentsScreen extends ConsumerStatefulWidget {
  const MRAppointmentsScreen({super.key});

  @override
  ConsumerState<MRAppointmentsScreen> createState() =>
      _MRAppointmentsScreenState();
}

class _MRAppointmentsScreenState extends ConsumerState<MRAppointmentsScreen> {
    @override
    void initState() {
      super.initState();
      Future.microtask(() => ref.read(mrAppointmentsNotifierProvider.notifier).loadAppointments());
    }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrAppointments;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrAppointments,
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
    final appointments = ref.watch(mrAppointmentsListProvider);
    final count = ref.watch(mrAppointmentsCountProvider);
    final mrList = ref.watch(mrListProvider);
    final selectedMRId = ref.watch(selectedMRAppointmentIdProvider);
    final selectedDate = ref.watch(selectedMRAppointmentDateProvider);
    final notifier = ref.read(mrAppointmentsNotifierProvider.notifier);
    final isLoading = ref.watch(mrAppointmentsIsLoadingProvider);
    final error = ref.watch(mrAppointmentsErrorProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Appointments',
        subtitle: 'Track MR doctor appointments with chamber details',
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
                MRAppointmentFilterCard(
                  mrList: mrList,
                  selectedMRId: selectedMRId,
                  selectedDate: selectedDate,
                  onMRChanged: notifier.setSelectedMR,
                  onDateChanged: notifier.setSelectedDate,
                  onClearDate: notifier.clearDateFilter,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$count ${count == 1 ? 'Appointment' : 'Appointments'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.quaternary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (isLoading)
                  const MedoricaLoader()
                else if (error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: Text(
                      error,
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (appointments.isEmpty)
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
                        'No appointments found for current filters',
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
                    itemCount: appointments.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return MRAppointmentCard(
                        appointment: appointments[index],
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
