class DailyMood {
  final String date; // yyyy-MM-dd
  final int mood;    // 1–5
  final String emoji;

  DailyMood({
    required this.date,
    required this.mood,
    required this.emoji,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'mood': mood,
      'emoji': emoji,
    };
  }

  factory DailyMood.fromMap(Map<String, dynamic> map) {
    return DailyMood(
      date: map['date'],
      mood: map['mood'],
      emoji: map['emoji'],
    );
  }
}
