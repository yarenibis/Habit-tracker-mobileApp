import 'package:flutter/material.dart';

class Habit {
  final int id;
  final String title;
  final String emoji;
  final int color;
  final List<String> logs; // yyyy-MM-dd

  Habit({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    required this.logs,
  });

  Color get colorValue => Color(color);

  String _key(DateTime d) => d.toIso8601String().split('T')[0];

  /// ✅ Bugün yapıldı mı
  bool get doneToday {
    return logs.contains(_key(DateTime.now()));
  }

  /// 🔥 Mevcut streak
  int get streak {
    int count = 0;
    DateTime day = DateTime.now();

    while (logs.contains(_key(day))) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  /// 🏆 En uzun streak
  int get longestStreak {
    if (logs.isEmpty) return 0;

    final sorted = logs
        .map((e) => DateTime.parse(e))
        .toList()
      ..sort();

    int longest = 1;
    int current = 1;

    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
        current++;
        longest = current > longest ? current : longest;
      } else {
        current = 1;
      }
    }
    return longest;
  }

  /// 📅 Calendar için map
  Map<String, bool> get logMap {
    return {
      for (var d in logs) d: true,
    };
  }
}
