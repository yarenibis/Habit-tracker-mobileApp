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

  String emoji = '🔥';
  Color color = Colors.green;
  TimeOfDay? reminderTime;

  final db = DatabaseHelper.instance;

  Future<void> saveHabit() async {
    if (titleController.text.trim().isEmpty) return;

    final habitId = await db.insertHabit(
      titleController.text.trim(),
      emoji,
      color.value,
      reminderTime?.hour,
      reminderTime?.minute,
    );

    if (reminderTime != null) {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Alışkanlık Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TITLE
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Alışkanlık adı',
              ),
            ),

            const SizedBox(height: 16),

            // EMOJI
            DropdownButton<String>(
              value: emoji,
              items: ['🔥', '📖', '🏃‍♂️', '💧', '🧠']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => emoji = v!),
            ),

            const SizedBox(height: 16),

            // COLOR
            Row(
              children: Colors.primaries.take(6).map((c) {
                return GestureDetector(
                  onTap: () => setState(() => color = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: color == c ? 3 : 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // REMINDER
            ListTile(
              title: Text(
                reminderTime == null
                    ? 'Hatırlatma ekle'
                    : 'Hatırlatma: ${reminderTime!.format(context)}',
              ),
              trailing: const Icon(Icons.alarm),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => reminderTime = time);
                }
              },
            ),

            const Spacer(),

            // SAVE
            ElevatedButton(
              onPressed: saveHabit,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
