import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_data_source.dart';
import '../models/workout_model.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;

  WorkoutRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Workout>>> getWorkouts() async {
    try {
      final localWorkouts = await localDataSource.getWorkouts();
      return Right(localWorkouts.map((model) => model.toEntity()).toList());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addWorkout(Workout workout) async {
    try {
      final workoutModel = WorkoutModel.fromEntity(workout);
      await localDataSource.cacheWorkout(workoutModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkout(Workout workout) async {
    try {
      final workoutModel = WorkoutModel.fromEntity(workout);
      await localDataSource.updateWorkout(workoutModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkout(String id) async {
    try {
      await localDataSource.deleteWorkout(id);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
