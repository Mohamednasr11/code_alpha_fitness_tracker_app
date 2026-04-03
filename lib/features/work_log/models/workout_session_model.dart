
import '../domain/entities/workout_session.dart';
import '../domain/entities/workout_set.dart';

class WorkoutSessionModel extends WorkoutSession {
  const WorkoutSessionModel({
    super.id,
    required super.name,
    required super.date,
    super.notes,
    super.durationMinutes,
    super.sets,
  });

  factory WorkoutSessionModel.fromMap(
      Map<String, dynamic> map, {
        List<WorkoutSet> sets = const [],
      }) =>
      WorkoutSessionModel(
        id: map['id'] as int,
        name: map['name'] as String,
        date: DateTime.parse(map['date'] as String),
        notes: map['notes'] as String? ?? '',
        durationMinutes: map['duration_minutes'] as int? ?? 0,
        sets: sets,
      );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'date': date.toIso8601String(),
    'notes': notes,
    'duration_minutes': durationMinutes,
  };
}