import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../providers/mr_attendance_provider.dart';
import '../../../theme/app_theme.dart';

class MRCalendarCard extends ConsumerStatefulWidget {
  const MRCalendarCard({
    super.key,
    required this.onDateSelected,
  });

  final Function(DateTime) onDateSelected;

  @override
  ConsumerState<MRCalendarCard> createState() => _MRCalendarCardState();
}

class _MRCalendarCardState extends ConsumerState<MRCalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(mrAttendanceNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (selectedDay, focusedDay) {
          // Don't allow selection of Sundays or future dates
          if (selectedDay.weekday == DateTime.sunday ||
              selectedDay.isAfter(DateTime.now())) {
            return;
          }

          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          widget.onDateSelected(selectedDay);
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });

          // Update the month/year in state
          ref.read(mrAttendanceNotifierProvider.notifier).setSelectedMonth(
                focusedDay.month,
                focusedDay.year,
              );
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          outsideDaysVisible: false,
          disabledTextStyle: TextStyle(
            color: AppColors.quaternary.withOpacity(0.3),
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.primary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.quaternary,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        enabledDayPredicate: (day) {
          // Disable Sundays and future dates
          return day.weekday != DateTime.sunday && !day.isAfter(DateTime.now());
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            // Don't show markers on Sundays or future dates
            if (date.weekday == DateTime.sunday || date.isAfter(DateTime.now())) {
              return null;
            }

            final attendance = state.getAttendanceForDate(date);
            if (attendance == null) {
              return null;
            }

            return Positioned(
              bottom: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: attendance.isPresent ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
