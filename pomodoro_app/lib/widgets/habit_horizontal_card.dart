import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitHorizontalCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitHorizontalCard({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: habit.colorValue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${habit.emoji} ${habit.title}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: habit.doneToday ? const Icon(Icons.check, size: 16) : null,
            ),
          ),
        ],
      ),
    );
  }
}
