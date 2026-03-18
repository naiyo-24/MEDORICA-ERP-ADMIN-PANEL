import 'package:flutter/material.dart';

class MRFilterCard extends StatelessWidget {
  final List<dynamic> mrList; // List<MR> or List<Map>
  final String? selectedMrId;
  final ValueChanged<String> onMrChanged;

  const MRFilterCard({
    super.key,
    required this.mrList,
    required this.selectedMrId,
    required this.onMrChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Select MR'),
          initialValue: selectedMrId,
          items: mrList
              .where((mr) => mr != null && mr is Object && (mr as dynamic).mrId != null && (mr as dynamic).name != null)
              .map((mr) => DropdownMenuItem<String>(
                    value: (mr as dynamic).mrId.toString(),
                    child: Text((mr as dynamic).name.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) onMrChanged(value);
          },
        ),
      ),
    );
  }
}
