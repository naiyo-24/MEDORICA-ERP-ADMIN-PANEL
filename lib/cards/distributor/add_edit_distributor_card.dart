import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorFormData {
  const DistributorFormData({
    required this.name,
    required this.city,
    required this.state,
    required this.address,
    required this.email,
    required this.phone,
    required this.expectedDeliveryTime,
    required this.minimumOrderValue,
    this.imageBytes,
    this.imageFileName,
  });

  final String name;
  final String city;
  final String state;
  final String address;
  final String email;
  final String phone;
  final String expectedDeliveryTime;
  final double minimumOrderValue;
  final Uint8List? imageBytes;
  final String? imageFileName;
}

class AddEditDistributorCard extends StatefulWidget {
  const AddEditDistributorCard({
    super.key,
    this.initialDistributor,
    required this.onSubmit,
  });

  final Distributor? initialDistributor;
  final Future<void> Function(DistributorFormData data) onSubmit;

  @override
  State<AddEditDistributorCard> createState() => _AddEditDistributorCardState();
}

class _AddEditDistributorCardState extends State<AddEditDistributorCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _expectedDeliveryTimeController;
  late final TextEditingController _minimumOrderValueController;

  Uint8List? _imageBytes;
  String? _imageFileName;
  bool _submitting = false;

  bool get _isEditing => widget.initialDistributor != null;

  @override
  void initState() {
    super.initState();
    final distributor = widget.initialDistributor;
    _nameController = TextEditingController(text: distributor?.name ?? '');
    _cityController = TextEditingController(text: distributor?.city ?? '');
    _stateController = TextEditingController(text: distributor?.state ?? '');
    _addressController = TextEditingController(
      text: distributor?.address ?? '',
    );
    _emailController = TextEditingController(text: distributor?.email ?? '');
    _phoneController = TextEditingController(text: distributor?.phone ?? '');
    _expectedDeliveryTimeController = TextEditingController(
      text: distributor?.expectedDeliveryTime ?? '',
    );
    _minimumOrderValueController = TextEditingController(
      text: distributor != null
          ? distributor.minimumOrderValue.toStringAsFixed(0)
          : '',
    );
    _imageBytes = distributor?.imageBytes;
    _imageFileName = distributor?.imageFileName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _expectedDeliveryTimeController.dispose();
    _minimumOrderValueController.dispose();
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
      _imageFileName = file.name;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);

    await widget.onSubmit(
      DistributorFormData(
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        expectedDeliveryTime: _expectedDeliveryTimeController.text.trim(),
        minimumOrderValue:
            double.tryParse(_minimumOrderValueController.text.trim()) ?? 0,
        imageBytes: _imageBytes,
        imageFileName: _imageFileName,
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
        width: 620,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? 'Edit Distributor' : 'Onboard Distributor',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Manage distributor details, profile image and contact endpoints.',
                  style: theme.textTheme.bodySmall,
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
                            child: Image.memory(
                              _imageBytes!,
                              fit: BoxFit.cover,
                            ),
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
                                'Tap to upload distributor photo',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                  ),
                ),
                if (_imageFileName != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _imageFileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Distributor name',
                    prefixIcon: Icon(Iconsax.profile_2user),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter distributor name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          prefixIcon: Icon(Iconsax.building),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter city.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Iconsax.map),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter state.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _addressController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Iconsax.location),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Iconsax.sms),
                        ),
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty || !text.contains('@')) {
                            return 'Enter a valid email.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Iconsax.call),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 10) {
                            return 'Enter valid phone.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expectedDeliveryTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Expected delivery time',
                          prefixIcon: Icon(Iconsax.timer_1),
                          hintText: 'e.g. 24-48 hours',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter delivery time.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        controller: _minimumOrderValueController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Minimum order value',
                          prefixIcon: Icon(Iconsax.money_3),
                          hintText: 'e.g. 5000',
                        ),
                        validator: (value) {
                          final parsed = double.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Enter valid amount.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                          : Icon(_isEditing ? Iconsax.edit : Iconsax.add),
                      label: Text(_isEditing ? 'Update' : 'Create'),
                    ),
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
