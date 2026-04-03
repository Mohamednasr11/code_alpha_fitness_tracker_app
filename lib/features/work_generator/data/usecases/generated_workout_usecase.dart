
import '../../domain/generated_workout.dart';

class GenerateWorkoutUsecase {
  List<GeneratedWorkoutDay> call(GeneratorInput input) {
    final days = _getDayCount(input.daysPerWeek);
    final split = _getSplit(input.goal, days);
    return split.map((s) => _buildDay(s, input)).toList();
  }

  int _getDayCount(WorkoutDays d) {
    switch (d) {
      case WorkoutDays.three:
        return 3;
      case WorkoutDays.four:
        return 4;
      case WorkoutDays.five:
        return 5;
    }
  }

  // ── Split selection based on goal + days ─────────────────
  List<_DaySpec> _getSplit(FitnessGoal goal, int days) {
    if (days == 3) {
      // Full body 3x
      return [
        _DaySpec('Day 1', 'Full Body A', ['Chest', 'Back', 'Legs']),
        _DaySpec('Day 2', 'Full Body B', ['Shoulders', 'Arms', 'Core']),
        _DaySpec('Day 3', 'Full Body C', ['Chest', 'Back', 'Legs']),
      ];
    }
    if (days == 4) {
      // Upper / Lower split
      return [
        _DaySpec('Day 1', 'Upper Body', ['Chest', 'Back', 'Shoulders']),
        _DaySpec('Day 2', 'Lower Body', ['Legs', 'Core']),
        _DaySpec('Day 3', 'Upper Body', ['Arms', 'Chest', 'Back']),
        _DaySpec('Day 4', 'Lower Body', ['Legs', 'Shoulders', 'Core']),
      ];
    }
    // 5 days — Push / Pull / Legs / Upper / Core
    return [
      _DaySpec('Day 1', 'Push', ['Chest', 'Shoulders', 'Arms']),
      _DaySpec('Day 2', 'Pull', ['Back', 'Arms']),
      _DaySpec('Day 3', 'Legs', ['Legs']),
      _DaySpec('Day 4', 'Upper', ['Chest', 'Back', 'Shoulders']),
      _DaySpec('Day 5', 'Core & Cardio', ['Core', 'Cardio']),
    ];
  }

  // ── Build a single day ────────────────────────────────────
  GeneratedWorkoutDay _buildDay(_DaySpec spec, GeneratorInput input) {
    final exercises = <GeneratedExercise>[];

    for (final group in spec.muscleGroups) {
      final pool = _exercisePool[group] ?? [];
      final count = _exercisesPerGroup(input.level);
      exercises.addAll(
        pool.take(count).map((name) => GeneratedExercise(
          name: name,
          muscleGroup: group,
          sets: _sets(input),
          reps: _reps(input),
          rest: _rest(input),
        )),
      );
    }

    return GeneratedWorkoutDay(
      dayName: spec.dayName,
      focus: spec.focus,
      exercises: exercises,
    );
  }

  // ── Parameters by level & goal ────────────────────────────
  int _exercisesPerGroup(FitnessLevel level) {
    switch (level) {
      case FitnessLevel.beginner:
        return 2;
      case FitnessLevel.intermediate:
        return 3;
      case FitnessLevel.advanced:
        return 4;
    }
  }

  int _sets(GeneratorInput input) {
    if (input.goal == FitnessGoal.buildMuscle) {
      return input.level == FitnessLevel.beginner ? 3 : 4;
    }
    if (input.goal == FitnessGoal.loseWeight) return 3;
    return 3;
  }

  String _reps(GeneratorInput input) {
    switch (input.goal) {
      case FitnessGoal.buildMuscle:
        return input.level == FitnessLevel.beginner ? '8-10' : '6-12';
      case FitnessGoal.loseWeight:
        return '12-15';
      case FitnessGoal.improveEndurance:
        return '15-20';
      case FitnessGoal.maintainFitness:
        return '10-12';
    }
  }

  String _rest(GeneratorInput input) {
    switch (input.goal) {
      case FitnessGoal.buildMuscle:
        return '90-120s';
      case FitnessGoal.loseWeight:
        return '45-60s';
      case FitnessGoal.improveEndurance:
        return '30-45s';
      case FitnessGoal.maintainFitness:
        return '60-90s';
    }
  }

  // ── Exercise pool per muscle group ────────────────────────
  static const _exercisePool = <String, List<String>>{
    'Chest': [
      'Bench Press', 'Incline Bench Press', 'Dumbbell Fly', 'Push Up', 'Cable Crossover'
    ],
    'Back': [
      'Deadlift', 'Pull Up', 'Barbell Row', 'Lat Pulldown', 'Seated Cable Row'
    ],
    'Legs': [
      'Squat', 'Leg Press', 'Romanian Deadlift', 'Leg Curl', 'Leg Extension', 'Calf Raise', 'Lunge'
    ],
    'Shoulders': [
      'Overhead Press', 'Lateral Raise', 'Front Raise', 'Face Pull', 'Arnold Press'
    ],
    'Arms': [
      'Barbell Curl', 'Hammer Curl', 'Tricep Pushdown', 'Skull Crusher', 'Dips'
    ],
    'Core': [
      'Plank', 'Crunch', 'Leg Raise', 'Russian Twist', 'Ab Wheel Rollout'
    ],
    'Cardio': [
      'Running', 'Cycling', 'Jump Rope', 'Rowing Machine'
    ],
  };
}

class _DaySpec {
  final String dayName;
  final String focus;
  final List<String> muscleGroups;
  _DaySpec(this.dayName, this.focus, this.muscleGroups);
}