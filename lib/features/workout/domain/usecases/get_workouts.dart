import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class GetWorkouts implements UseCase<List<Workout>, NoParams> {
  GetWorkouts(this.repository);
  final WorkoutRepository repository;

  @override
  Future<Either<Failure, List<Workout>>> call(NoParams params) async {
    return await repository.getWorkouts();
  }
}
