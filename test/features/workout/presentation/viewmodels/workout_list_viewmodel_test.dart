import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/core/error/failures.dart';
import 'package:magic_ai_fit/core/usecases/usecase.dart';
import 'package:magic_ai_fit/features/workout/domain/entities/workout.dart';
import 'package:magic_ai_fit/features/workout/domain/usecases/delete_workout.dart';
import 'package:magic_ai_fit/features/workout/domain/usecases/get_workouts.dart';
import 'package:magic_ai_fit/features/workout/presentation/viewmodels/workout_list_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetWorkouts, DeleteWorkout])
import 'workout_list_viewmodel_test.mocks.dart';

void main() {
  late WorkoutListViewModel viewModel;
  late MockGetWorkouts mockGetWorkouts;
  late MockDeleteWorkout mockDeleteWorkout;

  setUp(() {
    mockGetWorkouts = MockGetWorkouts();
    mockDeleteWorkout = MockDeleteWorkout();
    viewModel = WorkoutListViewModel(
      getWorkouts: mockGetWorkouts,
      deleteWorkout: mockDeleteWorkout,
    );
  });

  group('loadWorkouts', () {
    final tWorkouts = [
      Workout(id: '1', name: 'Workout 1', sets: const []),
      Workout(id: '2', name: 'Workout 2', sets: const []),
    ];

    test('should update workouts when GetWorkouts returns success', () async {
      // Arrange
      when(mockGetWorkouts(any)).thenAnswer((_) async => Right(tWorkouts));

      // Act
      await viewModel.loadWorkouts();

      // Assert
      expect(viewModel.workouts, equals(tWorkouts));
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNull);
      verify(mockGetWorkouts(NoParams()));
    });

    test('should set error when GetWorkouts returns failure', () async {
      // Arrange
      when(mockGetWorkouts(any)).thenAnswer((_) async => Left(ServerFailure()));

      // Act
      await viewModel.loadWorkouts();

      // Assert
      expect(viewModel.workouts, isEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, equals('Failed to load workouts'));
      verify(mockGetWorkouts(NoParams()));
    });
  });

  group('removeWorkout', () {
    final tWorkouts = [
      Workout(id: '1', name: 'Workout 1', sets: const []),
      Workout(id: '2', name: 'Workout 2', sets: const []),
    ];
    const tWorkoutId = '1';

    test('should remove workout when DeleteWorkout returns success', () async {
      // Arrange
      when(mockGetWorkouts(any)).thenAnswer((_) async => Right(tWorkouts));
      when(mockDeleteWorkout(any)).thenAnswer((_) async => const Right(null));

      // Act
      await viewModel.loadWorkouts(); // Load initial workouts
      await viewModel.removeWorkout(tWorkoutId);

      // Assert
      expect(viewModel.workouts.length, equals(1));
      expect(viewModel.workouts.first.id, equals('2'));
      expect(viewModel.error, isNull);
      verifyNever(mockDeleteWorkout(DeleteWorkoutParams(tWorkoutId)));
    });

    test('should set error when DeleteWorkout returns failure', () async {
      // Arrange
      when(mockGetWorkouts(any)).thenAnswer((_) async => Right(tWorkouts));
      when(mockDeleteWorkout(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      await viewModel.loadWorkouts(); // Load initial workouts
      await viewModel.removeWorkout(tWorkoutId);

      // Assert
      expect(viewModel.workouts, equals(tWorkouts));
      expect(viewModel.error, equals('Failed to delete workout'));
      verifyNever(mockDeleteWorkout(DeleteWorkoutParams(tWorkoutId)));
    });
  });
}
