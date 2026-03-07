import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/notification.dart';
import '../../theme/app_theme.dart';

class NotificationFormData {
  const NotificationFormData({
    required this.title,
    required this.message,
    required this.audience,
  });

  final String title;
  final String message;
  final NotificationAudience audience;
}

class AddNotificationCard extends StatefulWidget {
  const AddNotificationCard({super.key, required this.onSubmit});

  final Future<void> Function(NotificationFormData data) onSubmit;

  @override
  State<AddNotificationCard> createState() => _AddNotificationCardState();
}

class _AddNotificationCardState extends State<AddNotificationCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  NotificationAudience _audience = NotificationAudience.all;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);

    await widget.onSubmit(
      NotificationFormData(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        audience: _audience,
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
        width: 560,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColorDark,
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Notification',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Compose a notification and select audience type.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Notification title',
                  prefixIcon: Icon(Iconsax.notification),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _messageController,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  prefixIcon: Icon(Iconsax.note_text),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter message.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<NotificationAudience>(
                value: _audience,
                decoration: const InputDecoration(
                  labelText: 'Audience',
                  prefixIcon: Icon(Iconsax.profile_2user),
                ),
                items: const [
                  DropdownMenuItem(
                    value: NotificationAudience.all,
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: NotificationAudience.mr,
                    child: Text('MR'),
                  ),
                  DropdownMenuItem(
                    value: NotificationAudience.asm,
                    child: Text('ASM'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _audience = value);
                  }
                },
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
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: _submitting ? null : _submit,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Iconsax.add),
                    label: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
