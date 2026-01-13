import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../services/notification_service.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final titleController = TextEditingController();
  final db = DatabaseHelper.instance;

  String emoji = '🧘';
  Color selectedColor = const Color(0xFF1E5C5E);
  TimeOfDay? reminderTime;
  bool reminderEnabled = false;
  int selectedFrequency = 0; // 0: Daily, 1: Weekly, 2: Specific

  final emojis = ['🧘', '📖', '💧', '🏃‍♂️'];
  final colors = [
    const Color(0xFF1E5C5E),
    const Color(0xFFFFC0CB),
    const Color(0xFFB8C1EC),
    const Color(0xFFFFE4B5),
    const Color(0xFFDFF2EA),
    const Color(0xFFEAEAEA),
  ];

  Future<void> saveHabit() async {
    if (titleController.text.trim().isEmpty) return;

    final habitId = await db.insertHabit(
      titleController.text.trim(),
      emoji,
      selectedColor.value,
      reminderEnabled ? reminderTime?.hour : null,
      reminderEnabled ? reminderTime?.minute : null,
    );

    if (reminderEnabled && reminderTime != null) {
      await NotificationService.scheduleDaily(
        id: habitId,
        title: 'Alışkanlık Zamanı $emoji',
        body: '${titleController.text} alışkanlığını yaptın mı?',
        hour: reminderTime!.hour,
        minute: reminderTime!.minute,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
        title: const Text('Create New Habit'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// HABIT NAME
            const Text('Habit Name', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'e.g. Morning Meditation',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ICON & COLOR
            const Text('Choose Icon & Color', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Row(
              children: emojis.map((e) {
                final selected = emoji == e;
                return GestureDetector(
                  onTap: () => setState(() => emoji = e),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected
                          ? selectedColor.withOpacity(0.15)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? selectedColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(e, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            Row(
              children: colors.map((c) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: selectedColor == c ? 3 : 1,
                        color: selectedColor == c ? Colors.black : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// FREQUENCY
            const Text('Frequency', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Row(
              children: ['Daily', 'Weekly', 'Specific'].asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                final selected = selectedFrequency == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedFrequency = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.colorScheme.primary.withOpacity(0.15)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            /// REMINDER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_none),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Reminder',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          reminderTime == null
                              ? 'Set a specific time'
                              : reminderTime!.format(context),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: reminderEnabled,
                    onChanged: (v) async {
                      if (v) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time == null) return;
                        reminderTime = time;
                      }
                      setState(() => reminderEnabled = v);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// CREATE BUTTON
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Create Habit 🚀',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
