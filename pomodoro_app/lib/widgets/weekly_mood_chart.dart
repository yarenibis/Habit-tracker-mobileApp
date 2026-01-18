import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class WeeklyMoodChart extends StatefulWidget {
  const WeeklyMoodChart({super.key});

  @override
  State<WeeklyMoodChart> createState() => _WeeklyMoodChartState();
}

class _WeeklyMoodChartState extends State<WeeklyMoodChart> {
  List<Map<String, dynamic>> moods = [];

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final data = await DatabaseHelper.instance.getLast7DaysMood();
    setState(() {
      moods = data;
    });
  }

  String _dayName(String date) {
    final d = DateTime.parse(date);
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cts', 'Paz'];
    return days[d.weekday - 1];
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
              "Weekly Mood",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                if (index >= moods.length) {
                  return _buildEmptyDay();
                }

                final mood = moods[index]['mood'] as int;
                final date = moods[index]['date'];

                return _buildMoodDay(
                  mood: mood,
                  dayLabel: _dayName(date), // MM-DD
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodDay({
    required int mood,
    required String dayLabel,
  }) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _moodColor(mood),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            _moodEmoji(mood),
            style: const TextStyle(fontSize: 22),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dayLabel,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildEmptyDay() {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "-",
          style: TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  String _moodEmoji(int mood) {
    switch (mood) {
      case 1:
        return "😞";
      case 2:
        return "😕";
      case 3:
        return "😐";
      case 4:
        return "🙂";
      case 5:
        return "😄";
      default:
        return "❓";
    }
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return Colors.red.shade300;
      case 2:
        return Colors.orange.shade300;
      case 3:
        return Colors.grey.shade400;
      case 4:
        return Colors.lightGreen.shade400;
      case 5:
        return Colors.green.shade500;
      default:
        return Colors.grey.shade300;
    }
  }
}
