import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_calendar_heatmap.dart';
import '../widgets/stat_box.dart';

class ProgressScreen extends StatefulWidget {
  final List<Habit> habits;

  const ProgressScreen({super.key, required this.habits});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late Habit selectedHabit;

  @override
  void initState() {
    super.initState();
    selectedHabit = widget.habits.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔘 HABIT SELECTOR
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.habits.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final habit = widget.habits[index];
                  return ChoiceChip(
                    label: Text('${habit.emoji} ${habit.title}'),
                    selected: habit.id == selectedHabit.id,
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: habit.id == selectedHabit.id
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black87,
                    ),
                    onSelected: (_) {
                      setState(() => selectedHabit = habit);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            /// 📅 CALENDAR
            HabitCalendarHeatmap(
              logs: selectedHabit.logMap,
            ),

            const SizedBox(height: 24),

            /// 🔥 STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatBox(
                  label: 'This Streak',
                  value: '${selectedHabit.streak} days',
                ),
                StatBox(
                  label: 'Longest Streak',
                  value: '${selectedHabit.longestStreak} days',
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Edit Habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
