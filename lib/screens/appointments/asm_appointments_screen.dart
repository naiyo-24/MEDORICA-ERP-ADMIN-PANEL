import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/appointments/asm/asm_appointment_card.dart';
import '../../cards/appointments/asm/asm_appointment_filter_card.dart';
import '../../providers/appointment/asm_appointments_provider.dart';
import '../../providers/onboarding/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMAppointmentsScreen extends ConsumerStatefulWidget {
  const ASMAppointmentsScreen({super.key});

  @override
  ConsumerState<ASMAppointmentsScreen> createState() =>
      _ASMAppointmentsScreenState();
}

class _ASMAppointmentsScreenState extends ConsumerState<ASMAppointmentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.asmAppointments;

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.asmAppointments,
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
    final appointments = ref.watch(asmAppointmentsListProvider);
    final count = ref.watch(asmAppointmentsCountProvider);
    final asmList = ref.watch(asmListProvider);
    final selectedASMId = ref.watch(selectedASMAppointmentIdProvider);
    final selectedDate = ref.watch(selectedASMAppointmentDateProvider);
    final notifier = ref.read(asmAppointmentsNotifierProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Appointments',
        subtitle: 'Track ASM doctor appointments with chamber details',
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
                ASMAppointmentFilterCard(
                  asmList: asmList,
                  selectedASMId: selectedASMId,
                  selectedDate: selectedDate,
                  onASMChanged: notifier.setSelectedASM,
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
                if (appointments.isEmpty)
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
                      return ASMAppointmentCard(
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
