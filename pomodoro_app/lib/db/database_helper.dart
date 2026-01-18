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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // ================= CREATE =================
  Future _createDB(Database db, int version) async {
    /// HABITS
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

    /// HABIT LOGS
    await db.execute('''
      CREATE TABLE habit_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habitId INTEGER NOT NULL,
        date TEXT NOT NULL,
        mood INTEGER,
        UNIQUE(habitId, date)
      )
    ''');

    /// DAILY MOOD (GENEL RUH HALİ)
    await db.execute('''
      CREATE TABLE daily_mood (
        date TEXT PRIMARY KEY,
        mood INTEGER NOT NULL,
        emoji TEXT NOT NULL
      )
    ''');
  }

  // ================= UPGRADE =================
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      /// habit_logs → mood kolonu
      await db.execute(
        'ALTER TABLE habit_logs ADD COLUMN mood INTEGER',
      );

      /// daily_mood (varsa dokunmaz)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_mood (
          date TEXT PRIMARY KEY,
          mood INTEGER NOT NULL,
          emoji TEXT NOT NULL
        )
      ''');
    }
  }

  // ================= HABITS =================

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

  // ================= HABIT LOGS =================

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

  Future<void> updateHabitMood(
    int habitId,
    String date,
    int mood,
  ) async {
    final db = await database;

    await db.update(
      'habit_logs',
      {'mood': mood},
      where: 'habitId = ? AND date = ?',
      whereArgs: [habitId, date],
    );
  }

  // ================= DAILY MOOD =================

  Future<void> saveMood(
    String date,
    int mood,
    String emoji,
  ) async {
    final db = await database;

    await db.insert(
      'daily_mood',
      {
        'date': date,
        'mood': mood,
        'emoji': emoji,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getMoodByDate(String date) async {
    final db = await database;

    final result = await db.query(
      'daily_mood',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (result.isNotEmpty) return result.first;
    return null;
  }

  /// 🔥 WEEKLY MOOD (SON 7 GÜN)
  Future<List<Map<String, dynamic>>> getLast7DaysMood() async {
    final db = await database;

    return await db.query(
      'daily_mood',
      orderBy: 'date DESC',
      limit: 7,
    );
  }

  Future<List<Map<String, dynamic>>> getAllDailyMoods() async {
    final db = await database;

    return await db.query(
      'daily_mood',
      orderBy: 'date DESC',
    );
  }
}
