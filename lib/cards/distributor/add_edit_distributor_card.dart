import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/distributor.dart';
import '../../theme/app_theme.dart';

class DistributorFormData {
  const DistributorFormData({
    required this.distName,
    required this.distPhoneNo,
    required this.distLocation,
    required this.distProducts,
    required this.paymentTerms,
    this.distEmail,
    this.distDescription,
    this.distMinOrderValueRupees,
    this.distExpectedDeliveryTimeDays,
    this.bankName,
    this.bankAcNo,
    this.branchName,
    this.ifscCode,
    this.deliveryTerritories,
    this.photoBytes,
    this.photoFileName,
  });

  final String distName;
  final String distPhoneNo;
  final String distLocation;
  final String distProducts;
  final String paymentTerms;
  final String? distEmail;
  final String? distDescription;
  final double? distMinOrderValueRupees;
  final int? distExpectedDeliveryTimeDays;
  final String? bankName;
  final String? bankAcNo;
  final String? branchName;
  final String? ifscCode;
  final String? deliveryTerritories;
  final Uint8List? photoBytes;
  final String? photoFileName;
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
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _productsController;
  late final TextEditingController _paymentTermsController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _minOrderValueController;
  late final TextEditingController _deliveryTimeController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _bankAcNoController;
  late final TextEditingController _branchNameController;
  late final TextEditingController _ifscCodeController;
  late final TextEditingController _deliveryTerritoriesController;

  Uint8List? _photoBytes;
  String? _photoFileName;
  bool _submitting = false;

  bool get _isEditing => widget.initialDistributor != null;

  String _nameInitials(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return 'D';
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first.substring(0, 1).toUpperCase();
    final second = parts.length > 1
        ? parts.last.substring(0, 1).toUpperCase()
        : '';

    return '$first$second';
  }

  @override
  void initState() {
    super.initState();
    final distributor = widget.initialDistributor;
    _nameController =
        TextEditingController(text: distributor?.distName ?? '');
    _phoneController =
        TextEditingController(text: distributor?.distPhoneNo ?? '');
    _locationController =
        TextEditingController(text: distributor?.distLocation ?? '');
    _productsController = TextEditingController(
      text: distributor?.distProducts != null
          ? (distributor!.distProducts is List
              ? (distributor.distProducts as List).join(', ')
              : distributor.distProducts.toString())
          : '',
    );
    _paymentTermsController =
        TextEditingController(text: distributor?.paymentTerms ?? '');
    _emailController =
        TextEditingController(text: distributor?.distEmail ?? '');
    _descriptionController =
        TextEditingController(text: distributor?.distDescription ?? '');
    _minOrderValueController = TextEditingController(
      text: distributor?.distMinOrderValueRupees != null
          ? distributor!.distMinOrderValueRupees.toString()
          : '',
    );
    _deliveryTimeController = TextEditingController(
      text:
          distributor?.distExpectedDeliveryTimeDays?.toString() ?? '',
    );
    _bankNameController =
        TextEditingController(text: distributor?.bankName ?? '');
    _bankAcNoController =
        TextEditingController(text: distributor?.bankAcNo ?? '');
    _branchNameController =
        TextEditingController(text: distributor?.branchName ?? '');
    _ifscCodeController =
        TextEditingController(text: distributor?.ifscCode ?? '');
    _deliveryTerritoriesController = TextEditingController(
      text: distributor?.deliveryTerritories != null
          ? (distributor!.deliveryTerritories is List
              ? (distributor.deliveryTerritories as List).join(', ')
              : distributor.deliveryTerritories.toString())
          : '',
    );
    _photoBytes = distributor?.imageBytes;
    _photoFileName = distributor?.imageFileName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _productsController.dispose();
    _paymentTermsController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _minOrderValueController.dispose();
    _deliveryTimeController.dispose();
    _bankNameController.dispose();
    _bankAcNoController.dispose();
    _branchNameController.dispose();
    _ifscCodeController.dispose();
    _deliveryTerritoriesController.dispose();
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
      _photoBytes = file.bytes;
      _photoFileName = file.name;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);

    try {
      await widget.onSubmit(
        DistributorFormData(
          distName: _nameController.text.trim(),
          distPhoneNo: _phoneController.text.trim(),
          distLocation: _locationController.text.trim(),
          distProducts: _productsController.text.trim(),
          paymentTerms: _paymentTermsController.text.trim(),
          distEmail: _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : null,
          distDescription:
              _descriptionController.text.trim().isNotEmpty
                  ? _descriptionController.text.trim()
                  : null,
          distMinOrderValueRupees:
              double.tryParse(_minOrderValueController.text.trim()),
          distExpectedDeliveryTimeDays:
              int.tryParse(_deliveryTimeController.text.trim()),
          bankName: _bankNameController.text.trim().isNotEmpty
              ? _bankNameController.text.trim()
              : null,
          bankAcNo: _bankAcNoController.text.trim().isNotEmpty
              ? _bankAcNoController.text.trim()
              : null,
          branchName: _branchNameController.text.trim().isNotEmpty
              ? _branchNameController.text.trim()
              : null,
          ifscCode: _ifscCodeController.text.trim().isNotEmpty
              ? _ifscCodeController.text.trim()
              : null,
          deliveryTerritories:
              _deliveryTerritoriesController.text.trim().isNotEmpty
                  ? _deliveryTerritoriesController.text.trim()
                  : null,
          photoBytes: _photoBytes,
          photoFileName: _photoFileName,
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _nameInitials(_nameController.text);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 900),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Form(
            key: _formKey,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: _submitting
                                ? null
                                : () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.close_circle,
                                color: AppColors.white,
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                                border: Border.all(
                                  color: AppColors.white.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  initials,
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isEditing
                                        ? 'Edit Distributor'
                                        : 'Onboard Distributor',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: AppColors.white,
                                          fontSize: 26,
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Manage profile, contact and order commitments.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel(
                          icon: Iconsax.gallery_add,
                          label: 'Branding',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 190,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: _photoBytes != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.lg,
                                          ),
                                          child: Image.memory(
                                            _photoBytes!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Iconsax.gallery_add,
                                              size: 30,
                                              color: AppColors.quaternary,
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xs,
                                            ),
                                            Text(
                                              'Tap to upload distributor photo',
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                ),
                                Positioned(
                                  right: AppSpacing.sm,
                                  bottom: AppSpacing.sm,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Iconsax.edit_2,
                                          size: 13,
                                          color: AppColors.white,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(
                                          _photoBytes == null
                                              ? 'Upload'
                                              : 'Change',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_photoFileName != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _photoFileName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        const _SectionLabel(
                          icon: Iconsax.building,
                          label: 'Business Information',
                        ),
                        const SizedBox(height: AppSpacing.sm),
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
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: Icon(Iconsax.call),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 10) {
                                    return 'Enter valid phone.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextFormField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  labelText: 'Location',
                                  prefixIcon: Icon(Iconsax.map),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter location.';
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
                                controller: _productsController,
                                minLines: 2,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Products (comma-separated)',
                                  prefixIcon: Icon(Iconsax.box_1),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter products.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _paymentTermsController,
                                    decoration: const InputDecoration(
                                      labelText: 'Payment Terms',
                                      prefixIcon: Icon(Iconsax.money),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Enter payment terms.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  TextFormField(
                                    controller: _minOrderValueController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    decoration: const InputDecoration(
                                      labelText: 'Min order value (₹)',
                                      prefixIcon: Icon(Iconsax.money_3),
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  TextFormField(
                                    controller: _deliveryTimeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Delivery time (days)',
                                      prefixIcon: Icon(Iconsax.timer_1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const _SectionLabel(
                          icon: Iconsax.call,
                          label: 'Contact and Commitments',
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 2,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            prefixIcon: Icon(Iconsax.note),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const _SectionLabel(
                          icon: Iconsax.building_4,
                          label: 'Bank Information',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _bankNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Bank Name',
                                  prefixIcon: Icon(Iconsax.building),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextFormField(
                                controller: _bankAcNoController,
                                decoration: const InputDecoration(
                                  labelText: 'Account Number',
                                  prefixIcon: Icon(Iconsax.wallet_3),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _branchNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Branch Name',
                                  prefixIcon: Icon(Iconsax.location),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextFormField(
                                controller: _ifscCodeController,
                                decoration: const InputDecoration(
                                  labelText: 'IFSC Code',
                                  prefixIcon: Icon(Iconsax.security_card),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _deliveryTerritoriesController,
                          minLines: 2,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText:
                                'Delivery Territories (comma-separated)',
                            prefixIcon: Icon(Iconsax.map),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: _submitting
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(110, 46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            ElevatedButton.icon(
                              onPressed: _submitting ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(140, 46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              icon: _submitting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : Icon(
                                      _isEditing ? Iconsax.edit : Iconsax.add,
                                    ),
                              label: Text(_isEditing ? 'Update' : 'Create'),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.quaternary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
