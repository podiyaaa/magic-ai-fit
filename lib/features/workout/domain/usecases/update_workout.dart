import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class UpdateWorkoutParams {
  UpdateWorkoutParams(this.workout);
  final Workout workout;
}

class UpdateWorkout implements UseCase<void, UpdateWorkoutParams> {
  UpdateWorkout(this.repository);
  final WorkoutRepository repository;

  @override
  Future<Either<Failure, void>> call(UpdateWorkoutParams params) async {
    return await repository.updateWorkout(params.workout);
  }
}
