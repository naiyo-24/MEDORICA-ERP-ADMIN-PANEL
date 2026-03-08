import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/attendance/mr_attendance/mr_attendance_card.dart';
import '../../cards/attendance/mr_attendance/mr_calendar_card.dart';
import '../../models/mr.dart';
import '../../providers/mr_attendance_provider.dart';
import '../../providers/mr_onboarding_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRAttendanceScreen extends ConsumerStatefulWidget {
  const MRAttendanceScreen({super.key});

  @override
  ConsumerState<MRAttendanceScreen> createState() => _MRAttendanceScreenState();
}

class _MRAttendanceScreenState extends ConsumerState<MRAttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();
  }

  void _showAttendanceDetails(DateTime date) {
    final attendance = ref
        .read(mrAttendanceNotifierProvider)
        .getAttendanceForDate(date);

    if (attendance != null) {
      showDialog(
        context: context,
        builder: (context) => MRAttendanceCard(
          attendance: attendance,
          onClose: () => Navigator.of(context).pop(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mrList = ref.watch(mrListProvider);
    final selectedMRId = ref.watch(selectedMRIdProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Attendance',
        subtitle: 'Track and manage Medical Representative attendance',
        showMenuButton: true,
        showLogo: false,
        onMenuTap: _onMenuTap,
      ),
      drawer: SideNavBarDrawer(
        selectedKey: 'mr_attendance',
        onItemTap: _onNavTap,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.maxContentWidth,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600
                  ? AppSpacing.xl
                  : AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MR Selection Dropdown
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Iconsax.user_octagon,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Select Medical Representative',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<String>(
                        initialValue: selectedMRId.isEmpty
                            ? null
                            : selectedMRId,
                        decoration: InputDecoration(
                          hintText: 'Select MR',
                          prefixIcon: const Icon(Iconsax.user_search),
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
                        ),
                        items: mrList.map((MR mr) {
                          return DropdownMenuItem<String>(
                            value: mr.id,
                            child: Text(mr.name),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            ref
                                .read(mrAttendanceNotifierProvider.notifier)
                                .setSelectedMR(newValue);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Calendar Card
                if (selectedMRId.isNotEmpty) ...[
                  MRCalendarCard(onDateSelected: _showAttendanceDetails),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Iconsax.calendar_1,
                          size: 64,
                          color: AppColors.quaternary.withAlpha(128),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Please select an MR to view attendance',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.quaternary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
