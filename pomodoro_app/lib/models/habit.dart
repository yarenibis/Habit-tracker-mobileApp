class Habit {
  final String id;
  final String title;
  final List<String> logs; // yyyy-MM-dd (DESC sıralı)

  Habit({
    required this.id,
    required this.title,
    required this.logs,
  });

  int get streak {
    if (logs.isEmpty) return 0;

    int count = 0;
    DateTime today = _onlyDate(DateTime.now());

    for (int i = 0; i < logs.length; i++) {
      final logDate = _onlyDate(DateTime.parse(logs[i]));

      if (today.difference(logDate).inDays == count) {
        count++;
      } else {
        break; // ❌ zincir kırıldı
      }
    }
    return count;
  }

  bool get doneToday {
    final today = _onlyDate(DateTime.now()).toIso8601String().split('T')[0];
    return logs.contains(today);
  }

  bool get streakBroken {
    if (logs.isEmpty) return true;

    final yesterday = _onlyDate(DateTime.now().subtract(const Duration(days: 1)))
        .toIso8601String()
        .split('T')[0];

    return !logs.contains(yesterday) && !doneToday;
  }

  DateTime _onlyDate(DateTime d) => DateTime(d.year, d.month, d.day);
}
