import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/habit.dart';
import '../screens/add_habit_screen.dart';
import '../widgets/habit_horizontal_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Function(List<Habit>) onHabitsChanged;
  const HomeScreen({super.key, required this.onHabitsChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper.instance;
  List<Habit> habits = [];

  File? profileImage;

  String todayKey() => DateTime.now().toIso8601String().split('T')[0];

  @override
  void initState() {
    super.initState();
    loadHabits();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        profileImage = File(imagePath);
      });
    }
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
    final theme = Theme.of(context);
    final now = DateTime.now();

    final todo = habits.where((h) => !h.doneToday).toList();
    final done = habits.where((h) => h.doneToday).toList();
    final percent =
        habits.isEmpty ? 0 : ((done.length / habits.length) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(now).toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Today',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade700),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                      child: profileImage == null
                          ? const Icon(Icons.person,
                              size: 18, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DATE SELECTOR
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (_, i) {
                  final date = now.add(Duration(days: i - 3));
                  final selected = DateUtils.isSameDay(date, now);

                  return Container(
                    width: 56,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1E5C5E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white70 : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                selected ? Colors.white : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// DAILY MOMENTUM CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '🔥 ${5}-DAY STREAK',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Daily Momentum',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${done.length} of ${habits.length} habits completed.\nYou’re almost there!',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          value: percent / 100,
                          strokeWidth: 8,
                          color: const Color(0xFF1E5C5E),
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// UPCOMING
            _sectionHeader('Upcoming Habits', '${todo.length} REMAINING'),

            const SizedBox(height: 12),

            ...todo.map(
              (h) => HabitHorizontalCard(
                habit: h,
                onToggle: () async {
                  await db.toggleLog(h.id, todayKey());
                  loadHabits();
                },
              ),
            ),

            const SizedBox(height: 24),

            /// COMPLETED
            if (done.isNotEmpty) ...[
              Text(
                'Completed Today',
                style:
                    theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ...done.map(
                (h) => Opacity(
                  opacity: 0.5,
                  child: HabitHorizontalCard(
                    habit: h,
                    onToggle: () async {
                      await db.toggleLog(h.id, todayKey());
                      loadHabits();
                    },
                  ),
                ),
              ),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddHabitScreen()),
            );
            if (result == true) loadHabits();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E5C5E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.add),
          label: const Text(
            'New Habit',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
