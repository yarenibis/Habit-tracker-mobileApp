import 'package:flutter/material.dart';
import 'package:pomodoro_app/theme/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitCalendarHeatmap extends StatelessWidget {
  final Map<String, bool> logs;

  const HabitCalendarHeatmap({super.key, required this.logs});

  bool _isDone(DateTime day) {
    final key = day.toIso8601String().split('T')[0];
    return logs[key] == true;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now(),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) {
          final done = _isDone(day);
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: done ? AppTheme.green : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: done ? Colors.white : Colors.black,
              ),
            ),
          );
        },
        todayBuilder: (context, day, _) {
          final done = _isDone(day);
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: done ? AppTheme.green : AppTheme.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
