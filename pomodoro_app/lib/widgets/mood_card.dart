import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class MoodCard extends StatefulWidget {
  const MoodCard({super.key});

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard> {
  int? selectedMood;

  final moods = const [
    {'emoji': '😄', 'value': 5, 'label': 'Harika'},
    {'emoji': '🙂', 'value': 4, 'label': 'İyi'},
    {'emoji': '😐', 'value': 3, 'label': 'Normal'},
    {'emoji': '😔', 'value': 2, 'label': 'Kötü'},
    {'emoji': '😡', 'value': 1, 'label': 'Berbat'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTodayMood();
  }

  Future<void> _loadTodayMood() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final mood =
        await DatabaseHelper.instance.getMoodByDate(today);

    if (mood != null) {
      setState(() {
        selectedMood = mood['mood'];
      });
    }
  }

  Future<void> _saveMood(int moodValue, String emoji) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    await DatabaseHelper.instance.saveMood(
      today,
      moodValue,
      emoji,
    );

    setState(() {
      selectedMood = moodValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bugün nasılsın?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: moods.map((mood) {
                final isSelected = selectedMood == mood['value'];

                return GestureDetector(
                  onTap: () => _saveMood(
                    mood['value'] as int,
                    mood['emoji'] as String,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mood['emoji'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
