import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/workout_repository.dart';

class DeleteWorkoutParams {
  final String id;

  DeleteWorkoutParams(this.id);
}

class DeleteWorkout implements UseCase<void, DeleteWorkoutParams> {
  final WorkoutRepository repository;

  DeleteWorkout(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteWorkoutParams params) async {
    return await repository.deleteWorkout(params.id);
  }
}
