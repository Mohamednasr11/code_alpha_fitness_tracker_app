import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        muscle_group TEXT NOT NULL,
        description TEXT,
        image_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        duration_minutes INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        set_number INTEGER NOT NULL,
        reps INTEGER NOT NULL,
        weight REAL NOT NULL,
        FOREIGN KEY (session_id) REFERENCES workout_sessions(id) ON DELETE CASCADE,
        FOREIGN KEY (exercise_id) REFERENCES exercises(id)
      )
    ''');

    await _seedExercises(db);
  }

  Future<void> _seedExercises(Database db) async {
    final exercises = [
      {
        'name': 'Bench Press',
        'muscle_group': 'Chest',
        'description': 'Classic compound chest exercise using a barbell.'
      },
      {
        'name': 'Incline Bench Press',
        'muscle_group': 'Chest',
        'description': 'Targets the upper chest.'
      },
      {
        'name': 'Dumbbell Fly',
        'muscle_group': 'Chest',
        'description': 'Isolation exercise for the chest.'
      },
      {
        'name': 'Push Up',
        'muscle_group': 'Chest',
        'description': 'Bodyweight chest exercise.'
      },
      {
        'name': 'Cable Crossover',
        'muscle_group': 'Chest',
        'description': 'Cable isolation for chest.'
      },
      {
        'name': 'Deadlift',
        'muscle_group': 'Back',
        'description': 'King of all compound exercises.'
      },
      {
        'name': 'Pull Up',
        'muscle_group': 'Back',
        'description': 'Bodyweight back exercise.'
      },
      {
        'name': 'Barbell Row',
        'muscle_group': 'Back',
        'description': 'Compound rowing movement.'
      },
      {
        'name': 'Lat Pulldown',
        'muscle_group': 'Back',
        'description': 'Cable exercise targeting lats.'
      },
      {
        'name': 'Seated Cable Row',
        'muscle_group': 'Back',
        'description': 'Cable row for mid-back.'
      },
      {
        'name': 'Squat',
        'muscle_group': 'Legs',
        'description': 'The king of leg exercises.'
      },
      {
        'name': 'Leg Press',
        'muscle_group': 'Legs',
        'description': 'Machine compound leg exercise.'
      },
      {
        'name': 'Romanian Deadlift',
        'muscle_group': 'Legs',
        'description': 'Hamstring-focused deadlift.'
      },
      {
        'name': 'Leg Curl',
        'muscle_group': 'Legs',
        'description': 'Isolation for hamstrings.'
      },
      {
        'name': 'Leg Extension',
        'muscle_group': 'Legs',
        'description': 'Isolation for quads.'
      },
      {
        'name': 'Calf Raise',
        'muscle_group': 'Legs',
        'description': 'Isolation for calves.'
      },
      {
        'name': 'Lunge',
        'muscle_group': 'Legs',
        'description': 'Unilateral leg exercise.'
      },
      {
        'name': 'Overhead Press',
        'muscle_group': 'Shoulders',
        'description': 'Compound shoulder press.'
      },
      {
        'name': 'Lateral Raise',
        'muscle_group': 'Shoulders',
        'description': 'Isolation for side delts.'
      },
      {
        'name': 'Front Raise',
        'muscle_group': 'Shoulders',
        'description': 'Isolation for front delts.'
      },
      {
        'name': 'Face Pull',
        'muscle_group': 'Shoulders',
        'description': 'Rear delt and rotator cuff.'
      },
      {
        'name': 'Arnold Press',
        'muscle_group': 'Shoulders',
        'description': 'Full shoulder press variation.'
      },
      {
        'name': 'Barbell Curl',
        'muscle_group': 'Arms',
        'description': 'Classic bicep exercise.'
      },
      {
        'name': 'Hammer Curl',
        'muscle_group': 'Arms',
        'description': 'Neutral grip bicep curl.'
      },
      {
        'name': 'Tricep Pushdown',
        'muscle_group': 'Arms',
        'description': 'Cable tricep isolation.'
      },
      {
        'name': 'Skull Crusher',
        'muscle_group': 'Arms',
        'description': 'Lying tricep extension.'
      },
      {
        'name': 'Dips',
        'muscle_group': 'Arms',
        'description': 'Bodyweight tricep exercise.'
      },
      {
        'name': 'Preacher Curl',
        'muscle_group': 'Arms',
        'description': 'Strict bicep curl.'
      },
      {
        'name': 'Plank',
        'muscle_group': 'Core',
        'description': 'Isometric core exercise.'
      },
      {
        'name': 'Crunch',
        'muscle_group': 'Core',
        'description': 'Basic abdominal exercise.'
      },
      {
        'name': 'Leg Raise',
        'muscle_group': 'Core',
        'description': 'Lower ab exercise.'
      },
      {
        'name': 'Russian Twist',
        'muscle_group': 'Core',
        'description': 'Rotational core exercise.'
      },
      {
        'name': 'Ab Wheel Rollout',
        'muscle_group': 'Core',
        'description': 'Advanced core exercise.'
      },
      {
        'name': 'Running',
        'muscle_group': 'Cardio',
        'description': 'Treadmill or outdoor running.'
      },
      {
        'name': 'Cycling',
        'muscle_group': 'Cardio',
        'description': 'Stationary or outdoor cycling.'
      },
      {
        'name': 'Jump Rope',
        'muscle_group': 'Cardio',
        'description': 'High intensity cardio.'
      },
      {
        'name': 'Rowing Machine',
        'muscle_group': 'Cardio',
        'description': 'Full body cardio.'
      },
    ];

    for (final exercise in exercises) {
      await db.insert('exercises', exercise);
    }
  }
}
