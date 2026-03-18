import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../models/mr_monthly_plan.dart';
import '../../../theme/app_theme.dart';

class PlanDetailsCard extends StatelessWidget {
  final MRDayPlanResponse plan;

  const PlanDetailsCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: AppColors.surface,
      margin: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.calendar_1, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Plan Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${plan.planDate.day}/${plan.planDate.month}/${plan.planDate.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.quaternary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.divider, thickness: 1.2),
            const SizedBox(height: 16),
            ...plan.activities.map((activity) => Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.surface200,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Iconsax.note_text, color: AppColors.primary, size: 28),
                    title: Text(
                      activity.type,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Iconsax.clock, size: 18, color: AppColors.quaternary),
                            const SizedBox(width: 6),
                            Text(
                              'Slot: ${activity.slot}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.quaternary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Iconsax.location, size: 18, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Location: ${activity.location ?? "-"}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Iconsax.message_text, size: 18, color: AppColors.success),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Notes: ${activity.notes ?? "-"}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
