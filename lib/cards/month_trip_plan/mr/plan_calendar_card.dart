import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../models/mr_monthly_plan.dart';

class PlanCalendarCard extends StatelessWidget {
  final List<MRDayPlanResponse> plans;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const PlanCalendarCard({
    super.key,
    required this.plans,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final plannedDates = plans.map((e) => DateTime(e.planDate.year, e.planDate.month, e.planDate.day)).toSet();
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Planned Dates', style: TextStyle(fontWeight: FontWeight.bold)),
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: selectedDate ?? DateTime.now(),
              selectedDayPredicate: (day) => selectedDate != null && isSameDay(day, selectedDate),
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selected, _) {
                if (plannedDates.any((d) => isSameDay(d, selected))) {
                  onDateSelected(selected);
                }
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (plannedDates.any((d) => isSameDay(d, date))) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
