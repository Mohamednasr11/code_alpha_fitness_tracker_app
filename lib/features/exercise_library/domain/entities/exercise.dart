import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int id;
  final String name;
  final String muscleGroup;
  final String description;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, muscleGroup, description];
}
