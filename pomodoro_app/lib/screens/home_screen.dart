import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/add_habit_screen.dart';
import 'package:pomodoro_app/services/notification_service.dart';
import '../db/database_helper.dart';
import '../models/habit.dart';
import '../widgets/habit_heatmap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper.instance;
  List<Habit> habits = [];

  String todayKey() {
  return DateTime.now().toIso8601String().split('T')[0];
}


  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final habitRows = await db.getHabits();
    List<Habit> loaded = [];

    for (var h in habitRows) {
      final logs = await db.getLogs(h['id']);
      loaded.add(Habit(
        id: h['id'],
        title: h['title'],
        emoji: h['emoji'],
        color: h['color'],
        logs: logs,
      ));
    }

    setState(() => habits = loaded);
  }

  Future<void> toggleHabit(Habit habit) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await db.toggleLog(habit.id, today);
    await loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHabitScreen(),
            ),
          );

          if (result == true) {
            loadHabits();
          }
        },
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${habit.emoji} ${habit.title}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: habit.colorValue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  HabitHeatmap(
                    logs: habit.logs,
                    weeks: 8, // 🔥 GitHub gibi
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🔥 Streak: ${habit.streak}'),
                      Checkbox(
                        value: habit.doneToday,
                        onChanged: (_) async {
                          await db.toggleLog(habit.id, todayKey());
                          setState(() {}); // 🔥 UI'ı ZORLA YENİLE
                        },
                      )
                    ],
                  ),
                  if (habit.streakBroken)
                    const Text(
                      '⚠️ Streak kırıldı',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
