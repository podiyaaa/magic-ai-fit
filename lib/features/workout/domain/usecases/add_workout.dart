import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class AddWorkoutParams {
  final Workout workout;

  AddWorkoutParams(this.workout);
}

class AddWorkout implements UseCase<void, AddWorkoutParams> {
  final WorkoutRepository repository;

  AddWorkout(this.repository);

  @override
  Future<Either<Failure, void>> call(AddWorkoutParams params) async {
    return await repository.addWorkout(params.workout);
  }
}
