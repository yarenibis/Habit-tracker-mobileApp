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
    return Container(
      padding: const EdgeInsets.all(20),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now(),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(
            Icons.chevron_left_rounded,
            color: Colors.blue.shade600,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right_rounded,
            color: Colors.blue.shade600,
            size: 28,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
          weekendStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.blue.shade600,
          ),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          cellMargin: const EdgeInsets.all(4),
          defaultTextStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          weekendTextStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade700,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            final done = _isDone(day);
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: done
                    ? LinearGradient(
                        colors: [
                          AppTheme.green,
                          AppTheme.green.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: done ? null : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: done ? Colors.transparent : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: done
                    ? [
                        BoxShadow(
                          color: AppTheme.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: done ? Colors.white : Colors.black87,
                  fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            );
          },
          todayBuilder: (context, day, _) {
            final done = _isDone(day);
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: done
                      ? [AppTheme.green, AppTheme.green.withOpacity(0.8)]
                      : [AppTheme.blue, AppTheme.blue.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (done ? AppTheme.green : AppTheme.blue)
                        .withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            );
          },
          outsideBuilder: (context, day, _) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
