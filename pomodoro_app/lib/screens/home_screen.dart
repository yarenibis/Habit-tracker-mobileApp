import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/widgets/section_title.dart';
import '../db/database_helper.dart';
import '../models/habit.dart';
import '../screens/add_habit_screen.dart';
import '../widgets/week_calendar.dart';
import '../widgets/habit_horizontal_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(List<Habit>) onHabitsChanged;
  const HomeScreen({
    super.key,
  required this.onHabitsChanged,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper.instance;
  List<Habit> habits = [];

  String todayKey() => DateTime.now().toIso8601String().split('T')[0];

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
widget.onHabitsChanged(loaded);
  }

  @override
  Widget build(BuildContext context) {
    final todayText = DateFormat('MMMM d').format(DateTime.now());

    final todoHabits =
        habits.where((h) => !h.doneToday).toList();
    final doneHabits =
        habits.where((h) => h.doneToday).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHabitScreen(),
            ),
          );
          if (result == true) loadHabits();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 8),

              /// 🟢 HEADER
              Text(
                'Today',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                todayText,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              /// 📅 WEEK CALENDAR
              const WeekCalendar(),

              const SizedBox(height: 20),

              /// 🖼️ ILLUSTRATION
              Image.asset(
                'assets/images/Healthy.png',
                height: 220,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              /// 📌 TO DO
              SectionTitle(title: 'To Do'),
              const SizedBox(height: 8),

              ...todoHabits.map(
                (habit) => HabitHorizontalCard(
                  habit: habit,
                  onToggle: () async {
                    await db.toggleLog(habit.id, todayKey());
                    loadHabits();
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// ✅ DONE
              if (doneHabits.isNotEmpty) ...[
                SectionTitle(title: 'Done'),
                const SizedBox(height: 8),
                ...doneHabits.map(
                  (habit) => HabitHorizontalCard(
                    habit: habit,
                    onToggle: () async {
                      await db.toggleLog(habit.id, todayKey());
                      loadHabits();
                    },
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
