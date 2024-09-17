import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/workout_repository.dart';

class DeleteWorkoutParams {
  DeleteWorkoutParams(this.id);
  final String id;
}

class DeleteWorkout implements UseCase<void, DeleteWorkoutParams> {
  DeleteWorkout(this.repository);
  final WorkoutRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteWorkoutParams params) async {
    return await repository.deleteWorkout(params.id);
  }
}
