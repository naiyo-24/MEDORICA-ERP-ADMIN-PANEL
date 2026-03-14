import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/onboarding/asm.dart';
import '../../models/onboarding/mr.dart';
import '../../models/team.dart';
import '../../theme/app_theme.dart';

class TeamFormData {
  const TeamFormData({
    required this.name,
    required this.description,
    required this.whatsappGroupLink,
    required this.leaderASMId,
    required this.memberMRIds,
  });

  final String name;
  final String description;
  final String whatsappGroupLink;
  final String leaderASMId;
  final List<String> memberMRIds;
}

class CreateEditTeamCard extends StatefulWidget {
  const CreateEditTeamCard({
    super.key,
    this.initialTeam,
    required this.asmList,
    required this.mrList,
    required this.onSubmit,
  });

  final Team? initialTeam;
  final List<ASM> asmList;
  final List<MR> mrList;
  final Future<void> Function(TeamFormData data) onSubmit;

  @override
  State<CreateEditTeamCard> createState() => _CreateEditTeamCardState();
}

class _CreateEditTeamCardState extends State<CreateEditTeamCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _linkController;

  String? _selectedLeaderASMId;
  late Set<String> _selectedMemberMRIds;
  bool _submitting = false;

  bool get _isEditing => widget.initialTeam != null;

  @override
  void initState() {
    super.initState();
    final team = widget.initialTeam;
    _nameController = TextEditingController(text: team?.name ?? '');
    _descriptionController = TextEditingController(
      text: team?.description ?? '',
    );
    _linkController = TextEditingController(
      text: team?.whatsappGroupLink ?? '',
    );
    _selectedLeaderASMId = team?.leaderASMId;
    _selectedMemberMRIds =
        team?.members.map((e) => e.mrId).toSet() ?? <String>{};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLeaderASMId == null || _selectedLeaderASMId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an ASM as team leader.')),
      );
      return;
    }

    if (_selectedMemberMRIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one MR member.')),
      );
      return;
    }

    setState(() => _submitting = true);

    await widget.onSubmit(
      TeamFormData(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        whatsappGroupLink: _linkController.text.trim(),
        leaderASMId: _selectedLeaderASMId!,
        memberMRIds: _selectedMemberMRIds.toList(growable: false),
      ),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 760,
        constraints: const BoxConstraints(maxHeight: 780),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColorDark,
              blurRadius: 30,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, Color(0xFF60737C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isEditing ? 'Edit Team' : 'Create New Team',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.white,
                                  fontSize: 26,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Assign one ASM as leader and add MR members to build a high-performing unit.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _submitting
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Iconsax.close_circle,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Team Name',
                            prefixIcon: Icon(Iconsax.people),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a team name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Team Description',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Iconsax.document_text),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter team description.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _linkController,
                          decoration: const InputDecoration(
                            labelText: 'WhatsApp Group Link',
                            prefixIcon: Icon(Iconsax.link),
                            hintText: 'https://chat.whatsapp.com/...',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter WhatsApp group link.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedLeaderASMId,
                          decoration: const InputDecoration(
                            labelText: 'Team Leader (ASM)',
                            prefixIcon: Icon(Iconsax.user_octagon),
                          ),
                          items: widget.asmList
                              .map(
                                (asm) => DropdownMenuItem<String>(
                                  value: asm.asmId,
                                  child: Text(asm.name),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            setState(() {
                              _selectedLeaderASMId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select ASM leader.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select MR Team Members',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              ...widget.mrList.map(
                                (mr) => CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  value: _selectedMemberMRIds.contains(mr.mrId),
                                  title: Text(mr.name),
                                  subtitle: Text(
                                    mr.headquarterAssigned ?? 'Not assigned',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked ?? false) {
                                        _selectedMemberMRIds.add(mr.mrId);
                                      } else {
                                        _selectedMemberMRIds.remove(mr.mrId);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _submitting
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            ElevatedButton.icon(
                              onPressed: _submitting ? null : _submit,
                              icon: Icon(
                                _isEditing ? Iconsax.edit : Iconsax.add_square,
                              ),
                              label: Text(
                                _isEditing ? 'Save Changes' : 'Create Team',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
