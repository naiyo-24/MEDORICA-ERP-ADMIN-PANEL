import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cards/salary_slip/mr/mr_salary_slip_card.dart';
import '../../models/salary_slip/mr_salary_slip.dart';
import '../../providers/salary_slip/mr_salary_slip_provider.dart';
import '../../services/api_url.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(mrSalarySlipNotifierProvider.notifier).loadSalarySlips();
    });
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();
    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: _selectedNavKey,
    );
    if (!handled) {
      setState(() {
        _selectedNavKey = itemKey;
      });
    }
  }

  Future<void> _handleUpload(String mrId, PlatformFile file) async {
    if (file.bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to read selected PDF file.')),
        );
      }
      return;
    }
    await ref
        .read(mrSalarySlipNotifierProvider.notifier)
        .uploadFile(mrId: mrId, fileBytes: file.bytes!, fileName: file.name);
  }

  Future<void> _handleView(MRSalarySlip slip) async {
    if (!slip.hasFile) {
      return;
    }
    final url =
        '${ApiUrl.baseUrl}${ApiUrl.mrSalarySlipDownloadByMr(slip.mrId)}';
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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleDelete(MRSalarySlip slip) async {
    await ref
        .read(mrSalarySlipNotifierProvider.notifier)
        .deleteSalarySlip(slip.mrId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Salary slip deleted.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _ = Theme.of(context);
    final salarySlips = ref.watch(mrSalarySlipListProvider);
    final isLoading = ref.watch(mrSalarySlipLoadingProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: MedoricaAppBar(
        title: 'MR Salary Slips',
        subtitle: 'Manage Medical Representative Salary Slips',
        showMenuButton: true,
        showLogo: false,
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: _selectedNavKey,
          onItemTap: _onNavTap,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: salarySlips.length,
              itemBuilder: (context, index) {
                final slip = salarySlips[index];
                return MRSalarySlipCard(
                  salarySlip: slip,
                  onUpload: _handleUpload,
                  onView: () => _handleView(slip),
                  onDelete: () => _handleDelete(slip),
                );
              },
            ),
    );
  }
}



