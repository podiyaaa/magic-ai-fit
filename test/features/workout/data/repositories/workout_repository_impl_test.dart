import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/core/error/exceptions.dart';
import 'package:magic_ai_fit/core/error/failures.dart';
import 'package:magic_ai_fit/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:magic_ai_fit/features/workout/data/models/workout_model.dart';
import 'package:magic_ai_fit/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:magic_ai_fit/features/workout/domain/entities/workout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([WorkoutLocalDataSource])
import 'workout_repository_impl_test.mocks.dart';

void main() {
  late WorkoutRepositoryImpl repository;
  late MockWorkoutLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockWorkoutLocalDataSource();
    repository = WorkoutRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('getWorkouts', () {
    final tWorkoutModels = [
      WorkoutModel(id: '1', name: 'Workout 1', sets: const []),
      WorkoutModel(id: '2', name: 'Workout 2', sets: const []),
    ];
    final tWorkouts = tWorkoutModels.map((model) => model.toEntity()).toList();

    test(
        'should return list of Workouts when call to local data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.getWorkouts())
          .thenAnswer((_) async => tWorkoutModels);
      // act
      final result = await repository.getWorkouts();
      // assert
      expect(result.runtimeType,
          equals(Right<Failure, List<Workout>>(tWorkouts).runtimeType));

      verify(mockLocalDataSource.getWorkouts());
    });

    test(
        'should return CacheFailure when call to local data source throws CacheException',
        () async {
      // arrange
      when(mockLocalDataSource.getWorkouts()).thenThrow(CacheException());
      // act
      final result = await repository.getWorkouts();
      // assert
      expect(result, Left<Failure, List<Workout>>(CacheFailure()));
      verify(mockLocalDataSource.getWorkouts());
    });
  });

  group('addWorkout', () {
    final tWorkout = Workout(id: '1', name: 'New Workout', sets: const []);
    final tWorkoutModel = WorkoutModel.fromEntity(tWorkout);

    test(
        'should return Right(null) when call to local data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.cacheWorkout(any)).thenAnswer((_) async => {});
      // act
      final result = await repository.addWorkout(tWorkout);
      // assert
      expect(result, const Right<Failure, void>(null));
      verify(mockLocalDataSource.cacheWorkout(tWorkoutModel));
    });

    test(
        'should return CacheFailure when call to local data source throws CacheException',
        () async {
      // arrange
      when(mockLocalDataSource.cacheWorkout(any)).thenThrow(CacheException());
      // act
      final result = await repository.addWorkout(tWorkout);
      // assert
      expect(result, Left<Failure, void>(CacheFailure()));
      verify(mockLocalDataSource.cacheWorkout(tWorkoutModel));
    });
  });

  group('updateWorkout', () {
    final tWorkout = Workout(id: '1', name: 'Updated Workout', sets: const []);
    final tWorkoutModel = WorkoutModel.fromEntity(tWorkout);

    test(
        'should return Right(null) when call to local data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.updateWorkout(any)).thenAnswer((_) async => {});
      // act
      final result = await repository.updateWorkout(tWorkout);
      // assert
      expect(result, const Right<Failure, void>(null));
      verify(mockLocalDataSource.updateWorkout(tWorkoutModel));
    });

    test(
        'should return CacheFailure when call to local data source throws CacheException',
        () async {
      // arrange
      when(mockLocalDataSource.updateWorkout(any)).thenThrow(CacheException());
      // act
      final result = await repository.updateWorkout(tWorkout);
      // assert
      expect(result, Left<Failure, void>(CacheFailure()));
      verify(mockLocalDataSource.updateWorkout(tWorkoutModel));
    });
  });

  group('deleteWorkout', () {
    const tWorkoutId = '1';

    test(
        'should return Right(null) when call to local data source is successful',
        () async {
      // arrange
      when(mockLocalDataSource.deleteWorkout(any)).thenAnswer((_) async => {});
      // act
      final result = await repository.deleteWorkout(tWorkoutId);
      // assert
      expect(result, const Right<Failure, void>(null));
      verify(mockLocalDataSource.deleteWorkout(tWorkoutId));
    });

    test(
        'should return CacheFailure when call to local data source throws CacheException',
        () async {
      // arrange
      when(mockLocalDataSource.deleteWorkout(any)).thenThrow(CacheException());
      // act
      final result = await repository.deleteWorkout(tWorkoutId);
      // assert
      expect(result, Left<Failure, void>(CacheFailure()));
      verify(mockLocalDataSource.deleteWorkout(tWorkoutId));
    });
  });
}
