import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ─── Habit Model (replaces the one in dashboard_screen.dart) ──────────────────

class Habit {
  final int? id; // nullable — null until saved to DB
  final String name;
  final int xpReward;
  int streak;
  bool isCompleted;
  final String createdAt;

  Habit({
    this.id,
    required this.name,
    required this.xpReward,
    this.streak = 0,
    this.isCompleted = false,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  // Convert a Habit into a Map for inserting into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'xp_reward': xpReward,
      'streak': streak,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
    };
  }

  // Create a Habit from a database Map row
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      name: map['name'] as String,
      xpReward: map['xp_reward'] as int,
      streak: map['streak'] as int,
      isCompleted: (map['is_completed'] as int) == 1,
      createdAt: map['created_at'] as String,
    );
  }

  // Create a copy of this Habit with updated fields
  Habit copyWith({
    int? id,
    String? name,
    int? xpReward,
    int? streak,
    bool? isCompleted,
    String? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      xpReward: xpReward ?? this.xpReward,
      streak: streak ?? this.streak,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ─── Database Helper ──────────────────────────────────────────────────────────

class DatabaseHelper {
  // Singleton instance — only one DatabaseHelper exists in the app
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Returns the database, initializing it if it doesn't exist yet
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habit_quest.db');
    return _database!;
  }

  // Opens (or creates) the database file on the device
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Runs once when the database is first created
  Future _createDB(Database db, int version) async {
    // Habits table
    await db.execute('''
      CREATE TABLE habits (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT    NOT NULL,
        xp_reward   INTEGER NOT NULL DEFAULT 50,
        streak      INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at  TEXT    NOT NULL
      )
    ''');

    // App stats table (stores totalXP and bestStreak)
    await db.execute('''
      CREATE TABLE app_stats (
        id          INTEGER PRIMARY KEY CHECK (id = 1),
        total_xp    INTEGER NOT NULL DEFAULT 0,
        best_streak INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert the default stats row (there will only ever be one row)
    await db.insert('app_stats', {'id': 1, 'total_xp': 0, 'best_streak': 0});
  }

  // ─── Habit CRUD Operations ──────────────────────────────────────────────────

  // INSERT — add a new habit, returns the new habit with its database id
  Future<Habit> insertHabit(Habit habit) async {
    final db = await database;
    final id = await db.insert('habits', habit.toMap());
    return habit.copyWith(id: id);
  }

  // SELECT — load all habits from the database
  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final maps = await db.query('habits', orderBy: 'created_at ASC');
    return maps.map((map) => Habit.fromMap(map)).toList();
  }

  // UPDATE — save changes to an existing habit
  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  // DELETE — remove a habit by its id
  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // ─── App Stats Operations ───────────────────────────────────────────────────

  // Load totalXP and bestStreak from the database
  Future<Map<String, int>> getAppStats() async {
    final db = await database;
    final results = await db.query('app_stats', where: 'id = 1');
    if (results.isEmpty) return {'total_xp': 0, 'best_streak': 0};
    return {
      'total_xp': results.first['total_xp'] as int,
      'best_streak': results.first['best_streak'] as int,
    };
  }

  // Save totalXP and bestStreak to the database
  Future<void> updateAppStats({
    required int totalXP,
    required int bestStreak,
  }) async {
    final db = await database;
    await db.update('app_stats', {
      'total_xp': totalXP,
      'best_streak': bestStreak,
    }, where: 'id = 1');
  }

  // ─── Utility ────────────────────────────────────────────────────────────────

  // Close the database connection (call this when the app closes)
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
