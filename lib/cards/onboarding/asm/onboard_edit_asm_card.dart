import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm.dart';
import '../../../theme/app_theme.dart';

class ASMFormData {
  const ASMFormData({
    required this.name,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.address,
    required this.headquarterAssigned,
    required this.territoriesOfWork,
    required this.bankName,
    required this.bankBranchName,
    required this.bankAccountNumber,
    required this.ifscCode,
    required this.monthlyTarget,
    required this.password,
    this.joiningDate,
    this.basicSalary,
    this.dailyAllowances,
    this.hra,
    this.phoneAllowances,
    this.childrenAllowances,
    this.esic,
    this.specialAllowances,
    this.medicalAllowances,
    this.totalMonthlyCompensation,
    this.photoBytes,
    this.photoFileName,
  });

  final String name;
  final String phone;
  final String altPhone;
  final String email;
  final String address;
  final String headquarterAssigned;
  final String territoriesOfWork;
  final String bankName;
  final String bankBranchName;
  final String bankAccountNumber;
  final String ifscCode;
  final double monthlyTarget;
  final String password;
  final DateTime? joiningDate;
  final double? basicSalary;
  final double? dailyAllowances;
  final double? hra;
  final double? phoneAllowances;
  final double? childrenAllowances;
  final double? esic;
  final double? specialAllowances;
  final double? medicalAllowances;
  final double? totalMonthlyCompensation;
  final Uint8List? photoBytes;
  final String? photoFileName;
}

class OnboardEditASMCard extends StatefulWidget {
  const OnboardEditASMCard({
    super.key,
    this.initialASM,
    required this.onSubmit,
  });

  final ASM? initialASM;
  final Future<void> Function(ASMFormData data) onSubmit;

  @override
  State<OnboardEditASMCard> createState() => _OnboardEditASMCardState();
}

class _OnboardEditASMCardState extends State<OnboardEditASMCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _altPhoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _headquarterController;
  late final TextEditingController _territoriesController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _bankBranchController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _ifscCodeController;
  late final TextEditingController _targetController;
  late final TextEditingController _passwordController;
  late final TextEditingController _joiningDateController;
  late final TextEditingController _basicSalaryController;
  late final TextEditingController _dailyAllowancesController;
  late final TextEditingController _hraController;
  late final TextEditingController _phoneAllowancesController;
  late final TextEditingController _childrenAllowancesController;
  late final TextEditingController _esicController;
  late final TextEditingController _specialAllowancesController;
  late final TextEditingController _medicalAllowancesController;
  late final TextEditingController _totalCompensationController;

  Uint8List? _photoBytes;
  String? _photoFileName;
  bool _submitting = false;
  bool _isPasswordVisible = false;

  bool get _isEditing => widget.initialASM != null;

  String _territoriesWorkToString(dynamic territories) {
    if (territories == null) return '';
    if (territories is String) return territories;
    if (territories is List) {
      return territories.join(', ');
    }
    return territories.toString();
  }

  @override
  void initState() {
    super.initState();
    final asm = widget.initialASM;
    _nameController = TextEditingController(text: asm?.name ?? '');
    _phoneController = TextEditingController(text: asm?.phone ?? '');
    _altPhoneController = TextEditingController(text: asm?.altPhone ?? '');
    _emailController = TextEditingController(text: asm?.email ?? '');
    _addressController = TextEditingController(text: asm?.address ?? '');
    _headquarterController = TextEditingController(
      text: asm?.headquarterAssigned ?? '',
    );
    _territoriesController = TextEditingController(
      text: _territoriesWorkToString(asm?.territoriesOfWork),
    );
    _bankNameController = TextEditingController(text: asm?.bankName ?? '');
    _bankBranchController = TextEditingController(
      text: asm?.bankBranchName ?? '',
    );
    _accountNumberController = TextEditingController(
      text: asm?.bankAccountNumber ?? '',
    );
    _ifscCodeController = TextEditingController(text: asm?.ifscCode ?? '');
    _targetController = TextEditingController(
      text: asm?.monthlyTarget != null
          ? asm!.monthlyTarget!.toStringAsFixed(0)
          : '',
    );
    _passwordController = TextEditingController(text: asm?.password ?? '');
    _joiningDateController = TextEditingController(
      text: asm?.joiningDate != null
          ? '${asm!.joiningDate!.year}-${asm.joiningDate!.month.toString().padLeft(2, '0')}-${asm.joiningDate!.day.toString().padLeft(2, '0')}'
          : '',
    );
    _basicSalaryController = TextEditingController(
      text: asm?.basicSalary?.toStringAsFixed(0) ?? '',
    );
    _dailyAllowancesController = TextEditingController(
      text: asm?.dailyAllowances?.toStringAsFixed(0) ?? '',
    );
    _hraController = TextEditingController(
      text: asm?.hra?.toStringAsFixed(0) ?? '',
    );
    _phoneAllowancesController = TextEditingController(
      text: asm?.phoneAllowances?.toStringAsFixed(0) ?? '',
    );
    _childrenAllowancesController = TextEditingController(
      text: asm?.childrenAllowances?.toStringAsFixed(0) ?? '',
    );
    _esicController = TextEditingController(
      text: asm?.esic?.toStringAsFixed(0) ?? '',
    );
    _specialAllowancesController = TextEditingController(
      text: asm?.specialAllowances?.toStringAsFixed(0) ?? '',
    );
    _medicalAllowancesController = TextEditingController(
      text: asm?.medicalAllowances?.toStringAsFixed(0) ?? '',
    );
    _totalCompensationController = TextEditingController(
      text: asm?.totalMonthlyCompensation?.toStringAsFixed(0) ?? '',
    );
    _photoBytes = asm?.photoBytes;
    _photoFileName = asm?.photoFileName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _headquarterController.dispose();
    _territoriesController.dispose();
    _bankNameController.dispose();
    _bankBranchController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _targetController.dispose();
    _passwordController.dispose();
    _joiningDateController.dispose();
    _basicSalaryController.dispose();
    _dailyAllowancesController.dispose();
    _hraController.dispose();
    _phoneAllowancesController.dispose();
    _childrenAllowancesController.dispose();
    _esicController.dispose();
    _specialAllowancesController.dispose();
    _medicalAllowancesController.dispose();
    _totalCompensationController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
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

    await widget.onSubmit(
      ASMFormData(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        altPhone: _altPhoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        headquarterAssigned: _headquarterController.text.trim(),
        territoriesOfWork: _territoriesController.text.trim(),
        bankName: _bankNameController.text.trim(),
        bankBranchName: _bankBranchController.text.trim(),
        bankAccountNumber: _accountNumberController.text.trim(),
        ifscCode: _ifscCodeController.text.trim(),
        monthlyTarget: double.tryParse(_targetController.text.trim()) ?? 0,
        password: _passwordController.text.trim(),
        joiningDate: _joiningDateController.text.trim().isNotEmpty
            ? DateTime.tryParse(_joiningDateController.text.trim())
            : null,
        basicSalary: _basicSalaryController.text.trim().isNotEmpty
            ? double.tryParse(_basicSalaryController.text.trim())
            : null,
        dailyAllowances: _dailyAllowancesController.text.trim().isNotEmpty
            ? double.tryParse(_dailyAllowancesController.text.trim())
            : null,
        hra: _hraController.text.trim().isNotEmpty
            ? double.tryParse(_hraController.text.trim())
            : null,
        phoneAllowances: _phoneAllowancesController.text.trim().isNotEmpty
            ? double.tryParse(_phoneAllowancesController.text.trim())
            : null,
        childrenAllowances: _childrenAllowancesController.text.trim().isNotEmpty
            ? double.tryParse(_childrenAllowancesController.text.trim())
            : null,
        esic: _esicController.text.trim().isNotEmpty
            ? double.tryParse(_esicController.text.trim())
            : null,
        specialAllowances: _specialAllowancesController.text.trim().isNotEmpty
            ? double.tryParse(_specialAllowancesController.text.trim())
            : null,
        medicalAllowances: _medicalAllowancesController.text.trim().isNotEmpty
            ? double.tryParse(_medicalAllowancesController.text.trim())
            : null,
        totalMonthlyCompensation:
            _totalCompensationController.text.trim().isNotEmpty
            ? double.tryParse(_totalCompensationController.text.trim())
            : null,
        photoBytes: _photoBytes,
        photoFileName: _photoFileName,
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
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _isEditing ? 'Edit ASM' : 'Onboard New ASM',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Iconsax.close_circle,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Photo Section
                        Text(
                          'Photo',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        InkWell(
                          onTap: _pickPhoto,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: _photoBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                    child: Image.memory(
                                      _photoBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.camera,
                                          color: AppColors.quaternary,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Pick Photo',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: AppColors.quaternary,
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Personal Information
                        _buildSectionTitle(theme, 'Personal Information'),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Iconsax.profile_2user,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Iconsax.call,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Phone is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _altPhoneController,
                          label: 'Alternate Phone',
                          icon: Iconsax.call,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Iconsax.sms,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Email is required';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value!)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          icon: Iconsax.location,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Address is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Assignment & Territory
                        _buildSectionTitle(theme, 'Assignment & Territory'),
                        _buildTextField(
                          controller: _headquarterController,
                          label: 'Headquarter Assigned',
                          icon: Iconsax.building_4,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Headquarter is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _territoriesController,
                          label: 'Territories of Work',
                          icon: Iconsax.map,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Territories are required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Bank Details
                        _buildSectionTitle(theme, 'Bank Details'),
                        _buildTextField(
                          controller: _bankNameController,
                          label: 'Bank Name',
                          icon: Iconsax.building,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Bank name is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _bankBranchController,
                          label: 'Bank Branch',
                          icon: Iconsax.building,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Bank branch is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _accountNumberController,
                          label: 'Account Number',
                          icon: Iconsax.card,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Account number is required';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _ifscCodeController,
                          label: 'IFSC Code',
                          icon: Iconsax.code,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'IFSC code is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Other Details
                        _buildSectionTitle(theme, 'Other Details'),
                        _buildTextField(
                          controller: _joiningDateController,
                          label: 'Joining Date (YYYY-MM-DD)',
                          icon: Iconsax.calendar,
                        ),
                        _buildTextField(
                          controller: _targetController,
                          label: 'Monthly Target (₹)',
                          icon: Iconsax.chart_1,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Monthly target is required';
                            }
                            if (double.tryParse(value!) == null) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                        _buildPasswordField(theme),
                        const SizedBox(height: AppSpacing.lg),

                        // Salary & Compensation
                        _buildSectionTitle(theme, 'Salary & Compensation'),
                        _buildTextField(
                          controller: _basicSalaryController,
                          label: 'Basic Salary (₹)',
                          icon: Iconsax.money,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _dailyAllowancesController,
                          label: 'Daily Allowances (₹)',
                          icon: Iconsax.money_2,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _hraController,
                          label: 'HRA (₹)',
                          icon: Iconsax.house,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _phoneAllowancesController,
                          label: 'Phone Allowances (₹)',
                          icon: Iconsax.mobile,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _childrenAllowancesController,
                          label: 'Children Allowances (₹)',
                          icon: Iconsax.people,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _esicController,
                          label: 'ESIC (₹)',
                          icon: Iconsax.health,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _specialAllowancesController,
                          label: 'Special Allowances (₹)',
                          icon: Iconsax.dollar_circle,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _medicalAllowancesController,
                          label: 'Medical Allowances (₹)',
                          icon: Iconsax.hospital,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        _buildTextField(
                          controller: _totalCompensationController,
                          label: 'Total Monthly Compensation (₹)',
                          icon: Iconsax.money_4,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: Material(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: InkWell(
                              onTap: _submitting ? null : _submit,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: Center(
                                child: _submitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.white,
                                              ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _isEditing
                                            ? 'Update ASM'
                                            : 'Onboard ASM',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                              ),
                            ),
                          ),
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

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return 'Password is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Iconsax.lock, size: 16),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
              size: 16,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
