import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/attendance/asm_attendance/asm_attendance_card.dart';
import '../../cards/attendance/asm_attendance/asm_calendar_card.dart';
import '../../models/onboarding/asm.dart';
import '../../providers/asm_attendance_provider.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMAttendanceScreen extends ConsumerStatefulWidget {
  const ASMAttendanceScreen({super.key});

  @override
  ConsumerState<ASMAttendanceScreen> createState() =>
      _ASMAttendanceScreenState();
}

class _ASMAttendanceScreenState extends ConsumerState<ASMAttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();
  }

  void _showAttendanceDetails(DateTime date) {
    final attendance = ref.read(asmAttendanceByDateProvider(date));

    if (attendance != null) {
      showDialog(
        context: context,
        builder: (context) => ASMAttendanceCard(
          attendance: attendance,
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asmList = ref.watch(asmListProvider);
    final selectedASMId = ref.watch(selectedASMIdProvider);
    final presentCount = ref.watch(asmPresentCountProvider);
    final checkInSelfieCount = ref.watch(asmCheckInSelfieCountProvider);
    final checkOutSelfieCount = ref.watch(asmCheckOutSelfieCountProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Attendance',
        subtitle: 'Track and manage ASM attendance records',
        showMenuButton: true,
        showLogo: false,
        onMenuTap: _onMenuTap,
      ),
      drawer: SideNavBarDrawer(
        selectedKey: SideNavItemKeys.asmAttendance,
        onItemTap: _onNavTap,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenPadding = constraints.maxWidth > 1200
              ? (constraints.maxWidth - 1200) / 2
              : AppSpacing.md;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenPadding,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ASM Selection Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withAlpha(51),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: const Icon(
                              Iconsax.user_octagon,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Select ASM',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        initialValue: selectedASMId.isEmpty
                            ? null
                            : selectedASMId,
                        decoration: InputDecoration(
                          hintText: 'Select an ASM',
                          prefixIcon: const Icon(
                            Iconsax.user_octagon,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        items: asmList.map((ASM asm) {
                          return DropdownMenuItem<String>(
                            value: asm.asmId,
                            child: Text(
                              '${asm.name} - ${asm.headquarterAssigned}',
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            ref
                                .read(asmAttendanceNotifierProvider.notifier)
                                .setSelectedASM(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                if (selectedASMId.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),

                  // Calendar Card
                  ASMCalendarCard(onDateSelected: _showAttendanceDetails),

                  const SizedBox(height: AppSpacing.md),

                  // Legend
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _LegendItem(color: Colors.green, label: 'Present'),
                        _LegendItem(color: Colors.red, label: 'Absent'),
                        _LegendItem(color: Colors.blue, label: 'Both selfies'),
                        _LegendItem(color: Colors.orange, label: 'One selfie'),
                        Text(
                          'Sundays (No attendance)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.quaternary.withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Selfie Coverage
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.camera,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Selfie coverage this month: Check-in $checkInSelfieCount/$presentCount, Check-out $checkOutSelfieCount/$presentCount',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.quaternary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
