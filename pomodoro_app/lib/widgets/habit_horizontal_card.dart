import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitHorizontalCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const HabitHorizontalCard({
    super.key,
    required this.habit,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                habit.emoji,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔥 ${habit.streak} gün',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: habit.doneToday,
                onChanged: (_) => onToggle(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
