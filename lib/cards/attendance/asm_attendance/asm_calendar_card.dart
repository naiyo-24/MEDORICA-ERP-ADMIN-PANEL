import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../providers/attendance/asm_attendance_provider.dart';
import '../../../theme/app_theme.dart';

class ASMCalendarCard extends ConsumerStatefulWidget {
  const ASMCalendarCard({super.key, required this.onDateSelected});

  final Function(DateTime) onDateSelected;

  @override
  ConsumerState<ASMCalendarCard> createState() => _ASMCalendarCardState();
}

class _ASMCalendarCardState extends ConsumerState<ASMCalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Color? _selfieStatusColor(bool isPresent, bool hasCheckIn, bool hasCheckOut) {
    if (!isPresent) {
      return null;
    }
    if (hasCheckIn && hasCheckOut) {
      return Colors.blue;
    }
    if (hasCheckIn || hasCheckOut) {
      return Colors.orange;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(asmAttendanceNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
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
          // Don't allow selection of Sundays
          if (selectedDay.weekday == DateTime.sunday) {
            return;
          }

          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          // Notify parent widget
          widget.onDateSelected(selectedDay);
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });

          // Update month/year in state if different
          if (focusedDay.month != state.selectedMonth ||
              focusedDay.year != state.selectedYear) {
            ref
                .read(asmAttendanceNotifierProvider.notifier)
                .setSelectedMonth(focusedDay.month, focusedDay.year);
          }
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.error,
          ),
          defaultTextStyle: theme.textTheme.bodyMedium!,
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight.withAlpha(77),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: theme.textTheme.titleMedium!.copyWith(
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
          weekdayStyle: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            // Don't show markers for Sundays
            if (day.weekday == DateTime.sunday) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.error.withAlpha(128),
                  ),
                ),
              );
            }

            final attendance = state.getAttendanceForDate(day);
            final selfieStatusColor = attendance == null
                ? null
                : _selfieStatusColor(
                    attendance.isPresent,
                    attendance.hasCheckInSelfie,
                    attendance.hasCheckOutSelfie,
                  );

            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('${day.day}', style: theme.textTheme.bodyMedium),
                  if (attendance != null)
                    Positioned(
                      bottom: 2,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: attendance.isPresent
                              ? Colors.green
                              : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (selfieStatusColor != null)
                    Positioned(
                      bottom: 2,
                      right: 8,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: selfieStatusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
