import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

 
Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE habits (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      emoji TEXT NOT NULL,
      color INTEGER NOT NULL,
      reminderHour INTEGER,
      reminderMinute INTEGER,
      createdAt TEXT NOT NULL
    )
  ''');

  await db.execute('''
    CREATE TABLE habit_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      habitId INTEGER NOT NULL,
      date TEXT NOT NULL
    )
  ''');
}



  // HABITS
Future<int> insertHabit(
  String title,
  String emoji,
  int color,
  int? hour,
  int? minute,
) async {
  final db = await database;

  return await db.insert('habits', {
    'title': title,
    'emoji': emoji,
    'color': color,
    'reminderHour': hour,
    'reminderMinute': minute,
    'createdAt': DateTime.now().toIso8601String(),
  });
}




  Future<List<Map<String, dynamic>>> getHabits() async {
    final db = await database;
    return await db.query('habits', orderBy: 'createdAt DESC');
  }

  // LOGS
  Future<void> toggleLog(int habitId, String date) async {
  final db = await database;

  final existing = await db.query(
    'habit_logs',
    where: 'habitId = ? AND date = ?',
    whereArgs: [habitId, date],
  );

  if (existing.isEmpty) {
    await db.insert('habit_logs', {
      'habitId': habitId,
      'date': date,
    });
  } else {
    await db.delete(
      'habit_logs',
      where: 'habitId = ? AND date = ?',
      whereArgs: [habitId, date],
    );
  }
}

  Future<List<String>> getLogs(int habitId) async {
  final db = await database;

  final result = await db.query(
    'habit_logs',
    where: 'habitId = ?',
    whereArgs: [habitId],
    orderBy: 'date DESC',
  );

  return result.map((e) => e['date'] as String).toList();
}

}
