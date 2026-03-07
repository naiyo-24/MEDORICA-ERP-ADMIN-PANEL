import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/portfolio/edit_portfolio_card.dart';
import '../../cards/portfolio/portfolio_contact_card.dart';
import '../../cards/portfolio/portfolio_description_card.dart';
import '../../cards/portfolio/portfolio_director_message_card.dart';
import '../../providers/portfolio_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onMenuTap() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _onNavTap(String itemKey) {
    Navigator.of(context).pop();

    final handled = SideNavRouteIndex.handleTap(
      context: context,
      ref: ref,
      itemKey: itemKey,
      currentItemKey: SideNavItemKeys.ourPortfolio,
    );
    if (handled) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemKey module will be available soon.')),
    );
  }

  Future<void> _openEditDialog(PortfolioEditType type) async {
    final data = ref.read(portfolioDataProvider);

    final result = await showDialog<EditPortfolioResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: EditPortfolioCard(type: type, data: data),
      ),
    );

    if (result == null) {
      return;
    }

    final notifier = ref.read(portfolioNotifierProvider.notifier);

    switch (type) {
      case PortfolioEditType.description:
        if (result.description != null) {
          await notifier.updateDescription(result.description!);
        }
      case PortfolioEditType.directorMessage:
        if (result.directorMessage != null) {
          await notifier.updateDirectorMessage(result.directorMessage!);
        }
      case PortfolioEditType.contacts:
        await notifier.updateContact(
          phone: result.phone ?? data.phone,
          email: result.email ?? data.email,
          website: result.website ?? data.website,
          instagram: result.instagram ?? data.instagram,
          facebook: result.facebook ?? data.facebook,
          linkedin: result.linkedin ?? data.linkedin,
        );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio content updated.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = ref.watch(portfolioDataProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Our Portfolio',
        subtitle: 'Company narrative, leadership message and contact presence',
        showLogo: false,
        showSubtitle: true,
        showMenuButton: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: SideNavItemKeys.ourPortfolio,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PortfolioDescriptionCard(
                  description: portfolio.description,
                  onEdit: () => _openEditDialog(PortfolioEditType.description),
                ),
                const SizedBox(height: AppSpacing.lg),
                PortfolioDirectorMessageCard(
                  message: portfolio.directorMessage,
                  onEdit: () =>
                      _openEditDialog(PortfolioEditType.directorMessage),
                ),
                const SizedBox(height: AppSpacing.lg),
                PortfolioContactCard(
                  data: portfolio,
                  onEdit: () => _openEditDialog(PortfolioEditType.contacts),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
