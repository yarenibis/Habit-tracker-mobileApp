import 'package:flutter/material.dart';
class Habit {
  final int id;
  final String title;
  final String emoji;
  final int color;
  final List<String> logs;

  Habit({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.logs,
  });

  Color get colorValue => Color(color);


  bool get doneToday {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return logs.contains(today);
  }

  int get streak {
    int count = 0;
    DateTime day = DateTime.now();

    while (true) {
      final key = day.toIso8601String().split('T')[0];
      if (logs.contains(key)) {
        count++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return count;
  }

  bool get streakBroken {
    final yesterday =
        DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0];

    return !logs.contains(yesterday) && streak > 0;
  }
}
