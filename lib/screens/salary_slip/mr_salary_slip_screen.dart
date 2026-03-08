import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/salary_slip/mr/mr_salary_slip_card.dart';
import '../../cards/salary_slip/mr/mr_salary_slip_filter_card.dart';
import '../../models/mr_salary_slip.dart';
import '../../providers/mr_onboarding_provider.dart';
import '../../providers/mr_salary_slip_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class MRSalarySlipScreen extends ConsumerStatefulWidget {
  const MRSalarySlipScreen({super.key});

  @override
  ConsumerState<MRSalarySlipScreen> createState() => _MRSalarySlipScreenState();
}

class _MRSalarySlipScreenState extends ConsumerState<MRSalarySlipScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.mrSalarySlip;

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.mrSalarySlip,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  void _handleUpload(String slipId, PlatformFile file) {
    if (file.bytes != null) {
      ref
          .read(mrSalarySlipNotifierProvider.notifier)
          .uploadFile(
            slipId: slipId,
            fileBytes: file.bytes!,
            fileName: file.name,
          );
    }
  }

  void _handleView(MRSalarySlip slip) {
    if (slip.hasFile) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${slip.monthName} ${slip.year} Salary Slip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MR: ${slip.mrName}'),
              const SizedBox(height: 8),
              Text('File: ${slip.fileName}'),
              const SizedBox(height: 16),
              const Text(
                'File preview not implemented. In a real app, you would display the file here.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mrList = ref.watch(mrListProvider);
    final state = ref.watch(mrSalarySlipNotifierProvider);
    final salarySlips = ref.watch(mrSalarySlipListProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'MR Salary Slips',
        subtitle: 'Manage Medical Representative Salary Slips',
        showMenuButton: true,
        showLogo: false,
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: _selectedNavKey,
          onItemTap: _onNavTap,
        ),
      ),
      body: Column(
        children: [
          MRSalarySlipFilterCard(
            mrOptions: mrList,
            selectedMRId: state.selectedMRId,
            selectedYear: state.selectedYear,
            onMRChanged: (mrId) {
              ref
                  .read(mrSalarySlipNotifierProvider.notifier)
                  .setSelectedMR(mrId);
            },
            onYearChanged: (year) {
              ref
                  .read(mrSalarySlipNotifierProvider.notifier)
                  .setSelectedYear(year);
            },
          ),
          Expanded(
            child: salarySlips.isEmpty
                ? Center(
                    child: Text(
                      'No salary slips found',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.md,
                      top: AppSpacing.sm,
                    ),
                    itemCount: salarySlips.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final slip = salarySlips[index];
                      return MRSalarySlipCard(
                        salarySlip: slip,
                        onUpload: _handleUpload,
                        onView: () => _handleView(slip),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
