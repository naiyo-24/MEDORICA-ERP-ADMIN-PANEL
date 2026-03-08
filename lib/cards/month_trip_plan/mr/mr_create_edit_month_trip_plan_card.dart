import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../theme/app_theme.dart';

class MRCreateEditMonthTripPlanCard extends StatefulWidget {
  const MRCreateEditMonthTripPlanCard({
    super.key,
    required this.title,
    required this.initialDate,
    required this.initialTime,
    required this.initialDescription,
    required this.onSave,
    required this.onCancel,
  });

  final String title;
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final String initialDescription;
  final void Function(DateTime date, TimeOfDay time, String description) onSave;
  final VoidCallback onCancel;

  @override
  State<MRCreateEditMonthTripPlanCard> createState() =>
      _MRCreateEditMonthTripPlanCardState();
}

class _MRCreateEditMonthTripPlanCardState
    extends State<MRCreateEditMonthTripPlanCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    _selectedTime = widget.initialTime;
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  String _date(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(_selectedTime);

    return Container(
      width: 520,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Iconsax.calendar_1, size: 16),
                  label: Text(_date(_selectedDate)),
                ),
                OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Iconsax.clock, size: 16),
                  label: Text(time),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Plan Description',
                hintText: 'Add plan details for the selected date and time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter plan description';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.xs),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    widget.onSave(
                      _selectedDate,
                      _selectedTime,
                      _descriptionController.text.trim(),
                    );
                  },
                  child: const Text('Save Plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
