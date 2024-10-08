import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Workout extends Equatable {
  Workout({
    required this.id,
    required this.sets,
    required this.name,
  });

  factory Workout.newWorkout() {
    return Workout(
      id: '',
      sets: List.empty(growable: true),
      name: '',
    );
  }
  String id;
  final List<WorkoutSet> sets;
  String name = '';

  @override
  List<Object> get props => [id, sets];

  // copyWith

  Workout copyWith({
    String? id,
    List<WorkoutSet>? sets,
    String? name,
  }) {
    return Workout(
      id: id ?? this.id,
      sets: sets ?? this.sets,
      name: name ?? this.name,
    );
  }
}

class WorkoutSet extends Equatable {
  const WorkoutSet(
      {required this.exercise,
      required this.weight,
      required this.repetitions});
  final Exercise exercise;
  final double weight;
  final int repetitions;

  @override
  List<Object> get props => [exercise, weight, repetitions];
}

enum Exercise {
  selectExercise('Select Exercise'),
  barbellRow('Barbell Row'),
  deadlift('Deadlift'),
  benchPress('Bench Press'),
  squats('Squats'),
  shoulderPress('Shoulder Press');

  const Exercise(this._value);
  final String _value;
  String get value => _value;

  static Exercise fromValue(String value) {
    return Exercise.values.firstWhere((exercise) => exercise.value == value,
        orElse: () => barbellRow);
  }
}
