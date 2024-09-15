import '../../domain/entities/workout.dart';

// ignore: must_be_immutable
class WorkoutModel extends Workout {
  WorkoutModel({required super.id, required super.sets, required super.name});

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      sets: (json['sets'] as List)
          .map((set) => WorkoutSetModel.fromJson(set))
          .toList(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sets': sets.map((set) => (set as WorkoutSetModel).toJson()).toList(),
      'name': name,
    };
  }

  factory WorkoutModel.fromEntity(Workout workout) {
    return WorkoutModel(
      id: workout.id,
      sets: workout.sets.map((set) => WorkoutSetModel.fromEntity(set)).toList(),
      name: workout.name,
    );
  }

  Workout toEntity() {
    return Workout(
        id: id,
        sets: sets.map((set) => (set as WorkoutSetModel).toEntity()).toList(),
        name: name);
  }
}

class WorkoutSetModel extends WorkoutSet {
  const WorkoutSetModel({
    required super.exercise,
    required super.weight,
    required super.repetitions,
  });

  factory WorkoutSetModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSetModel(
      exercise: Exercise.fromValue(json['exercise']),
      weight: json['weight'],
      repetitions: json['repetitions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.value,
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  factory WorkoutSetModel.fromEntity(WorkoutSet set) {
    return WorkoutSetModel(
      exercise: set.exercise,
      weight: set.weight,
      repetitions: set.repetitions,
    );
  }

  WorkoutSet toEntity() {
    return WorkoutSet(
      exercise: exercise,
      weight: weight,
      repetitions: repetitions,
    );
  }
}
