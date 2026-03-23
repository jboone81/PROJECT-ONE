import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ─── Habit Model ──────────────────────────────────────────────────────────────

class Habit {
  final int? id;
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
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    print('🔧 Initializing database...');
    final stopwatch = Stopwatch()..start();
    _database = await _initDB('habit_quest.db');
    print('✅ Database initialized in ${stopwatch.elapsedMilliseconds}ms');
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
      singleInstance: true, // Ensure only one instance
    );
  }

  Future _createDB(Database db, int version) async {
    // Habits table
    await db.execute('''
      CREATE TABLE habits (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        name         TEXT    NOT NULL,
        xp_reward    INTEGER NOT NULL DEFAULT 50,
        streak       INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at   TEXT    NOT NULL
      )
    ''');

    // App stats table
    await db.execute('''
      CREATE TABLE app_stats (
        id          INTEGER PRIMARY KEY CHECK (id = 1),
        total_xp    INTEGER NOT NULL DEFAULT 0,
        best_streak INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Habit history table — logs every completion event with a timestamp
    // This is what powers the real stats charts
    await db.execute('''
      CREATE TABLE habit_history (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id   INTEGER NOT NULL,
        habit_name TEXT    NOT NULL,
        xp_earned  INTEGER NOT NULL,
        completed_at TEXT  NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    // Insert default stats row
    await db.insert('app_stats', {'id': 1, 'total_xp': 0, 'best_streak': 0});
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration to add missions table
      await db.execute('''
        CREATE TABLE missions (
          id           INTEGER PRIMARY KEY AUTOINCREMENT,
          title        TEXT    NOT NULL,
          description  TEXT,
          xp_reward    INTEGER NOT NULL DEFAULT 100,
          is_completed INTEGER NOT NULL DEFAULT 0,
          created_at   TEXT    NOT NULL,
          completed_at TEXT
        )
      ''');
      
      // Add indexes for better query performance
      await db.execute('CREATE INDEX IF NOT EXISTS idx_habit_history_date ON habit_history(completed_at)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_habit_history_habit_id ON habit_history(habit_id)');
    }
  }

  // ─── Habit CRUD ────────────────────────────────────────────────────────────

  Future<Habit> insertHabit(Habit habit) async {
    final db = await database;
    final id = await db.insert('habits', habit.toMap());
    return habit.copyWith(id: id);
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final maps = await db.query('habits', orderBy: 'created_at ASC');
    return maps.map((map) => Habit.fromMap(map)).toList();
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(int id) async {
    final db = await database;
    // Also delete all history entries for this habit
    await db.delete('habit_history', where: 'habit_id = ?', whereArgs: [id]);
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Habit History ─────────────────────────────────────────────────────────

  // Call this every time a habit is marked as completed
  Future<void> insertHistoryEntry({
    required int habitId,
    required String habitName,
    required int xpEarned,
  }) async {
    final db = await database;
    await db.insert('habit_history', {
      'habit_id': habitId,
      'habit_name': habitName,
      'xp_earned': xpEarned,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }

  // Returns how many habits were completed on each of the last 7 days
  Future<List<Map<String, dynamic>>> getWeeklyCompletions() async {
    final db = await database;
    final today = DateTime.now();
    final List<Map<String, dynamic>> result = [];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dayStart = DateTime(
        date.year,
        date.month,
        date.day,
      ).toIso8601String();
      final dayEnd = DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
      ).toIso8601String();

      final rows = await db.rawQuery(
        '''
        SELECT COUNT(DISTINCT habit_id) as completed
        FROM habit_history
        WHERE completed_at >= ? AND completed_at <= ?
      ''',
        [dayStart, dayEnd],
      );

      result.add({'date': date, 'completed': rows.first['completed'] as int});
    }

    return result;
  }

  // Returns total XP earned on each of the last 7 days (cumulative)
  Future<List<Map<String, dynamic>>> getWeeklyXP() async {
    final db = await database;
    final today = DateTime.now();
    final List<Map<String, dynamic>> result = [];

    // Get the total XP before this week as the starting point
    final weekStart = today.subtract(const Duration(days: 6));
    final weekStartStr = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    ).toIso8601String();

    final beforeWeek = await db.rawQuery(
      '''
      SELECT COALESCE(SUM(xp_earned), 0) as total
      FROM habit_history
      WHERE completed_at < ?
    ''',
      [weekStartStr],
    );

    int runningXP = (beforeWeek.first['total'] as int?) ?? 0;

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dayStart = DateTime(
        date.year,
        date.month,
        date.day,
      ).toIso8601String();
      final dayEnd = DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
      ).toIso8601String();

      final rows = await db.rawQuery(
        '''
        SELECT COALESCE(SUM(xp_earned), 0) as xp
        FROM habit_history
        WHERE completed_at >= ? AND completed_at <= ?
      ''',
        [dayStart, dayEnd],
      );

      runningXP += (rows.first['xp'] as int?) ?? 0;

      result.add({'date': date, 'xp': runningXP});
    }

    return result;
  }

  // Returns completion rate for each habit over the last 7 days
  Future<List<Map<String, dynamic>>> getHabitWeeklyRates() async {
    final db = await database;
    final weekAgo = DateTime.now()
        .subtract(const Duration(days: 7))
        .toIso8601String();

    final rows = await db.rawQuery(
      '''
      SELECT habit_id, habit_name, COUNT(*) as completions
      FROM habit_history
      WHERE completed_at >= ?
      GROUP BY habit_id, habit_name
    ''',
      [weekAgo],
    );

    return rows
        .map(
          (row) => {
            'habit_id': row['habit_id'],
            'habit_name': row['habit_name'],
            'completions': row['completions'],
            // Rate out of 7 days
            'rate': ((row['completions'] as int) / 7).clamp(0.0, 1.0),
          },
        )
        .toList();
  }

  // ─── App Stats ─────────────────────────────────────────────────────────────

  Future<Map<String, int>> getAppStats() async {
    final db = await database;
    final results = await db.query('app_stats', where: 'id = 1');
    if (results.isEmpty) return {'total_xp': 0, 'best_streak': 0};
    return {
      'total_xp': results.first['total_xp'] as int,
      'best_streak': results.first['best_streak'] as int,
    };
  }

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

  // ─── Mission CRUD ──────────────────────────────────────────────────────────

  Future<void> insertMission({
    required String title,
    required String description,
    required int xpReward,
  }) async {
    final db = await database;
    await db.insert('missions', {
      'title': title,
      'description': description,
      'xp_reward': xpReward,
      'is_completed': 0,
      'created_at': DateTime.now().toIso8601String(),
      'completed_at': null,
    });
  }

  Future<List<Map<String, dynamic>>> getAllMissions() async {
    final db = await database;
    return await db.query('missions', orderBy: 'created_at ASC');
  }

  Future<void> completeMission(int missionId) async {
    final db = await database;
    await db.update('missions', {
      'is_completed': 1,
      'completed_at': DateTime.now().toIso8601String(),
    }, where: 'id = ?', whereArgs: [missionId]);
  }

  Future<void> deleteMission(int missionId) async {
    final db = await database;
    await db.delete('missions', where: 'id = ?', whereArgs: [missionId]);
  }

  // ─── Utility ───────────────────────────────────────────────────────────────

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
