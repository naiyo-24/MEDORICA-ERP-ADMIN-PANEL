import 'package:flutter/material.dart';

import '../../models/portfolio.dart';
import '../../theme/app_theme.dart';

enum PortfolioEditType { description, directorMessage, contacts }

class EditPortfolioResult {
  const EditPortfolioResult({
    this.description,
    this.directorMessage,
    this.phone,
    this.email,
    this.website,
    this.instagram,
    this.facebook,
    this.linkedin,
  });

  final String? description;
  final String? directorMessage;

  final String? phone;
  final String? email;
  final String? website;
  final String? instagram;
  final String? facebook;
  final String? linkedin;
}

class EditPortfolioCard extends StatefulWidget {
  const EditPortfolioCard({super.key, required this.type, required this.data});

  final PortfolioEditType type;
  final PortfolioData data;

  @override
  State<EditPortfolioCard> createState() => _EditPortfolioCardState();
}

class _EditPortfolioCardState extends State<EditPortfolioCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _descriptionController;
  late final TextEditingController _directorController;

  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;
  late final TextEditingController _instagramController;
  late final TextEditingController _facebookController;
  late final TextEditingController _linkedinController;

  @override
  void initState() {
    super.initState();
    final data = widget.data;

    _descriptionController = TextEditingController(text: data.description);
    _directorController = TextEditingController(text: data.directorMessage);

    _phoneController = TextEditingController(text: data.phone);
    _emailController = TextEditingController(text: data.email);
    _websiteController = TextEditingController(text: data.website);
    _instagramController = TextEditingController(text: data.instagram);
    _facebookController = TextEditingController(text: data.facebook);
    _linkedinController = TextEditingController(text: data.linkedin);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _directorController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    switch (widget.type) {
      case PortfolioEditType.description:
        Navigator.of(context).pop(
          EditPortfolioResult(description: _descriptionController.text.trim()),
        );
      case PortfolioEditType.directorMessage:
        Navigator.of(context).pop(
          EditPortfolioResult(directorMessage: _directorController.text.trim()),
        );
      case PortfolioEditType.contacts:
        Navigator.of(context).pop(
          EditPortfolioResult(
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            website: _websiteController.text.trim(),
            instagram: _instagramController.text.trim(),
            facebook: _facebookController.text.trim(),
            linkedin: _linkedinController.text.trim(),
          ),
        );
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 26,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ..._buildFields(),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Save Changes'),
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

  String get _title {
    switch (widget.type) {
      case PortfolioEditType.description:
        return 'Edit Portfolio Description';
      case PortfolioEditType.directorMessage:
        return 'Edit Director Message';
      case PortfolioEditType.contacts:
        return 'Edit Contact Details';
    }
  }

  List<Widget> _buildFields() {
    switch (widget.type) {
      case PortfolioEditType.description:
        return [
          _textarea(controller: _descriptionController, label: 'Description'),
        ];
      case PortfolioEditType.directorMessage:
        return [
          _textarea(controller: _directorController, label: 'Director message'),
        ];
      case PortfolioEditType.contacts:
        return [
          _textField(controller: _phoneController, label: 'Phone number'),
          const SizedBox(height: AppSpacing.sm),
          _textField(controller: _emailController, label: 'Email'),
          const SizedBox(height: AppSpacing.sm),
          _textField(controller: _websiteController, label: 'Website'),
          const SizedBox(height: AppSpacing.sm),
          _textField(controller: _instagramController, label: 'Instagram link'),
          const SizedBox(height: AppSpacing.sm),
          _textField(controller: _facebookController, label: 'Facebook link'),
          const SizedBox(height: AppSpacing.sm),
          _textField(controller: _linkedinController, label: 'LinkedIn link'),
        ];
    }
  }

  Widget _textarea({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 8,
      decoration: InputDecoration(labelText: label, alignLabelWithHint: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required.';
        }
        return null;
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required.';
        }
        return null;
      },
    );
  }
}
