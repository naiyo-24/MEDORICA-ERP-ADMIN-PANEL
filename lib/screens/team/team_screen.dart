import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../cards/team/create_edit_team_card.dart';
import '../../cards/team/team_card.dart';
import '../../cards/team/team_description_card.dart';
import '../../cards/team/team_members_card.dart';
import '../../models/team.dart';
import '../../providers/asm_onboarding_provider.dart';
import '../../providers/mr_onboarding_provider.dart';
import '../../providers/team_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar_drawer.dart';

class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(asmOnboardingNotifierProvider.notifier).loadASMList();
      await ref.read(mrOnboardingNotifierProvider.notifier).loadMRList();
      await ref.read(teamNotifierProvider.notifier).loadTeams();
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
      currentItemKey: SideNavItemKeys.teamManagement,
    );
    if (handled) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$itemKey module will be available soon.')),
    );
  }

  Future<void> _showCreateEditDialog({Team? team}) async {
    final asmList = ref.read(asmOnboardingNotifierProvider).asmList;
    final mrList = ref.read(mrOnboardingNotifierProvider).mrList;

    if (asmList.isEmpty || mrList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please wait for ASM and MR data to load before creating a team.',
          ),
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: CreateEditTeamCard(
            initialTeam: team,
            asmList: asmList,
            mrList: mrList,
            onSubmit: (data) async {
              final notifier = ref.read(teamNotifierProvider.notifier);

              if (team == null) {
                await notifier.createTeam(
                  name: data.name,
                  description: data.description,
                  whatsappGroupLink: data.whatsappGroupLink,
                  leaderASMId: data.leaderASMId,
                  memberMRIds: data.memberMRIds,
                );
              } else {
                await notifier.updateTeam(
                  teamId: team.id,
                  name: data.name,
                  description: data.description,
                  whatsappGroupLink: data.whatsappGroupLink,
                  leaderASMId: data.leaderASMId,
                  memberMRIds: data.memberMRIds,
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _showMembersDialog(Team team) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          child: TeamMembersCard(
            team: team,
            onRemoveMember: (mrId) {
              ref
                  .read(teamNotifierProvider.notifier)
                  .removeMember(teamId: team.id, mrId: mrId);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> _showDescriptionDialog(Team team) async {
    await showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        child: TeamDescriptionCard(team: team),
      ),
    );
  }

  Future<void> _deleteTeam(Team team) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text('Are you sure you want to delete "${team.name}"?'),
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

    if (shouldDelete ?? false) {
      await ref.read(teamNotifierProvider.notifier).deleteTeam(team.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teamState = ref.watch(teamNotifierProvider);
    final teams = teamState.teams;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.surface,
      appBar: MedoricaAppBar(
        title: 'Team Management',
        subtitle: 'Build ASM-led MR teams and manage member collaboration',
        showLogo: false,
        showMenuButton: true,
        onMenuTap: _onMenuTap,
      ),
      drawer: Drawer(
        width: 320,
        child: SideNavBarDrawer(
          selectedKey: SideNavItemKeys.teamManagement,
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
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    onTap: () => _showCreateEditDialog(),
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF324048), Color(0xFF536A75)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColorDark,
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(
                              Iconsax.add_circle,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create a New Team',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontSize: 22,
                                      ),
                                ),
                                Text(
                                  'Assign ASM leader, add MRs, and set collaboration details',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (teamState.error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      teamState.error!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (teamState.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (teams.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Iconsax.people,
                          size: 38,
                          color: AppColors.quaternary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'No teams created yet.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      for (final team in teams) ...[
                        TeamCard(
                          team: team,
                          onViewMembers: () => _showMembersDialog(team),
                          onViewDescription: () => _showDescriptionDialog(team),
                          onEdit: () => _showCreateEditDialog(team: team),
                          onDelete: () => _deleteTeam(team),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
