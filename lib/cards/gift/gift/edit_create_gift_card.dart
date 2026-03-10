import 'package:flutter/material.dart';

import '../../../models/gift.dart';
import '../../../theme/app_theme.dart';

class GiftFormData {
  const GiftFormData({
    required this.itemName,
    required this.description,
    required this.quantityInInventory,
    required this.price,
  });

  final String itemName;
  final String description;
  final int quantityInInventory;
  final double price;
}

class EditCreateGiftCard extends StatefulWidget {
  const EditCreateGiftCard({
    super.key,
    this.initialGift,
    required this.onSubmit,
  });

  final Gift? initialGift;
  final Future<void> Function(GiftFormData data) onSubmit;

  @override
  State<EditCreateGiftCard> createState() => _EditCreateGiftCardState();
}

class _EditCreateGiftCardState extends State<EditCreateGiftCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  bool _saving = false;

  bool get _isEdit => widget.initialGift != null;

  @override
  void initState() {
    super.initState();
    final gift = widget.initialGift;
    _itemNameController = TextEditingController(text: gift?.itemName ?? '');
    _descriptionController = TextEditingController(
      text: gift?.description ?? '',
    );
    _quantityController = TextEditingController(
      text: gift == null ? '' : gift.quantityInInventory.toString(),
    );
    _priceController = TextEditingController(
      text: gift == null ? '' : gift.price.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.onSubmit(
        GiftFormData(
          itemName: _itemNameController.text.trim(),
          description: _descriptionController.text.trim(),
          quantityInInventory: int.parse(_quantityController.text.trim()),
          price: double.parse(_priceController.text.trim()),
        ),
      );
      if (mounted) {
        setState(() => _saving = false);
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 560),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEdit ? 'Edit Gift Item' : 'Create Gift Item',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _itemNameController,
              decoration: const InputDecoration(labelText: 'Gift item name'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Item name is required'
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Description is required'
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity in inventory',
                    ),
                    validator: (value) {
                      final parsed = int.tryParse(value?.trim() ?? '');
                      if (parsed == null || parsed < 0) {
                        return 'Enter valid quantity';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Price'),
                    validator: (value) {
                      final parsed = double.tryParse(value?.trim() ?? '');
                      if (parsed == null || parsed < 0) {
                        return 'Enter valid price';
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
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.xs),
                ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  child: Text(_isEdit ? 'Update Gift' : 'Create Gift'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
