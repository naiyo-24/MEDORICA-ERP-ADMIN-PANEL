import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/visual_ads.dart';
import '../../theme/app_theme.dart';

class VisualAdFormData {
  const VisualAdFormData({
    required this.name,
    this.imageBytes,
    this.imageFileName,
  });

  final String name;
  final Uint8List? imageBytes;
  final String? imageFileName;
}

class CreateEditVisualAdsCard extends StatefulWidget {
  const CreateEditVisualAdsCard({
    super.key,
    this.initialAd,
    required this.onSubmit,
  });

  final VisualAd? initialAd;
  final Future<void> Function(VisualAdFormData data) onSubmit;

  @override
  State<CreateEditVisualAdsCard> createState() =>
      _CreateEditVisualAdsCardState();
}

class _CreateEditVisualAdsCardState extends State<CreateEditVisualAdsCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  Uint8List? _imageBytes;
  String? _imageName;
  bool _submitting = false;

  bool get _isEditing => widget.initialAd != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialAd?.name ?? '');
    _imageBytes = widget.initialAd?.imageBytes;
    _imageName = widget.initialAd?.imageFileName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.first;
    if (file.bytes == null) {
      return;
    }

    setState(() {
      _imageBytes = file.bytes;
      _imageName = file.name;
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);

    await widget.onSubmit(
      VisualAdFormData(
        name: _nameController.text.trim(),
        imageBytes: _imageBytes,
        imageFileName: _imageName,
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
        width: 520,
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
                _isEditing ? 'Edit Visual Ad' : 'Create Visual Ad',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 26,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Provide ad name and upload an image.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad name',
                  prefixIcon: Icon(Iconsax.text),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter ad name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.gallery_add,
                              size: 28,
                              color: AppColors.quaternary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Tap to select ad image',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                ),
              ),
              if (_imageName != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _imageName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.quaternary,
                  ),
                ),
              ],
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
                    onPressed: _submitting ? null : _onSubmit,
                    icon: _submitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(_isEditing ? Iconsax.edit : Iconsax.add),
                    label: Text(_isEditing ? 'Update' : 'Create'),
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
