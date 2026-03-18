import 'package:flutter/material.dart';
import '../../../models/mr_monthly_plan.dart';

class PlanDetailsCard extends StatelessWidget {
  final MRDayPlanResponse plan;

  const PlanDetailsCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plan Details for ${plan.planDate.day}/${plan.planDate.month}/${plan.planDate.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...plan.mrPlan.activities.map((activity) => ListTile(
                  title: Text(activity.type),
                  subtitle: Text('Slot: ${activity.slot}\nLocation: ${activity.location ?? "-"}\nNotes: ${activity.notes ?? "-"}'),
                )),
          ],
        ),
      ),
    );
  }
}
