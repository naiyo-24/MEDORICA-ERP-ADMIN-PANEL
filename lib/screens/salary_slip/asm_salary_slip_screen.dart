import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cards/salary_slip/asm/asm_salary_slip_card.dart';
import '../../models/salary_slip/asm_salary_slip.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../providers/asm_salary_slip_provider.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class ASMSalarySlipScreen extends ConsumerStatefulWidget {
  const ASMSalarySlipScreen({super.key});

  @override
  ConsumerState<ASMSalarySlipScreen> createState() =>
      _ASMSalarySlipScreenState();
}

class _ASMSalarySlipScreenState extends ConsumerState<ASMSalarySlipScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedNavKey = SideNavItemKeys.asmSalarySlip;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(asmOnboardingNotifierProvider.notifier).loadASMList();
      await ref.read(asmSalarySlipNotifierProvider.notifier).loadSalarySlips();
    });
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.asmSalarySlip,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  Future<void> _handleUpload(String asmId, PlatformFile file) async {
    if (file.bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to read selected PDF file.')),
        );
      }
      return;
    }

    await ref
        .read(asmSalarySlipNotifierProvider.notifier)
        .uploadFile(asmId: asmId, fileBytes: file.bytes!, fileName: file.name);
  }

  Future<void> _handleView(ASMSalarySlip slip) async {
    if (!slip.hasFile) {
      return;
    }

    final url =
        '${ApiUrl.baseUrl}${ApiUrl.asmSalarySlipDownloadByAsm(slip.asmId)}';
    final uri = Uri.parse(url);
    final canLaunch = await canLaunchUrl(uri);

    if (!canLaunch) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open salary slip URL: $url')),
        );
      }
      return;
    }

    final launched = await launchUrl(uri, webOnlyWindowName: '_blank');

    if (mounted && !launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open salary slip for ${slip.asmName}.'),
        ),
      );
    }
  }

  Future<void> _handleDelete(ASMSalarySlip slip) async {
    if (!slip.hasFile) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Salary Slip'),
        content: Text(
          'Delete salary slip for ${slip.asmName} (${slip.asmId})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      await ref.read(asmSalarySlipNotifierProvider.notifier).deleteByAsm(slip);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salary slip deleted successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(asmSalarySlipNotifierProvider);
    final salarySlips = ref.watch(asmSalarySlipListProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'ASM Salary Slips',
        subtitle: 'Manage Area Sales Manager Salary Slips',
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
          if (state.error != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                state.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : salarySlips.isEmpty
                ? Center(
                    child: Text(
                      'No ASM records found',
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
                      return ASMSalarySlipCard(
                        salarySlip: slip,
                        onUpload: _handleUpload,
                        onView: () async => _handleView(slip),
                        onDelete: () async => _handleDelete(slip),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
