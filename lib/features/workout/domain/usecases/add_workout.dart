import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class AddWorkoutParams {
  AddWorkoutParams(this.workout);
  final Workout workout;
}

class AddWorkout implements UseCase<void, AddWorkoutParams> {
  AddWorkout(this.repository);
  final WorkoutRepository repository;

  @override
  Future<Either<Failure, void>> call(AddWorkoutParams params) async {
    return await repository.addWorkout(params.workout);
  }
}
