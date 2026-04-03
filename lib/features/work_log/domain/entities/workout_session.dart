import 'package:equatable/equatable.dart';
import 'workout_set.dart';

class WorkoutSession extends Equatable {
  final int? id;
  final String name;
  final DateTime date;
  final String notes;
  final int durationMinutes;
  final List<WorkoutSet> sets;

  const WorkoutSession({
    this.id,
    required this.name,
    required this.date,
    this.notes = '',
    this.durationMinutes = 0,
    this.sets = const [],
  });

  WorkoutSession copyWith({
    int? id,
    String? name,
    DateTime? date,
    String? notes,
    int? durationMinutes,
    List<WorkoutSet>? sets,
  }) =>
      WorkoutSession(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        notes: notes ?? this.notes,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        sets: sets ?? this.sets,
      );

  @override
  List<Object?> get props => [id, name, date, notes, durationMinutes, sets];
}