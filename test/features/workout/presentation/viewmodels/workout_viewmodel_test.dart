import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/core/error/failures.dart';
import 'package:magic_ai_fit/features/workout/domain/entities/workout.dart';
import 'package:magic_ai_fit/features/workout/domain/usecases/add_workout.dart';
import 'package:magic_ai_fit/features/workout/domain/usecases/update_workout.dart';
import 'package:magic_ai_fit/features/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AddWorkout, UpdateWorkout])
import 'workout_viewmodel_test.mocks.dart';

void main() {
  late WorkoutViewModel viewModel;
  late MockAddWorkout mockAddWorkout;
  late MockUpdateWorkout mockUpdateWorkout;
  late List<Exercise> testExercises;

  setUp(() {
    mockAddWorkout = MockAddWorkout();
    mockUpdateWorkout = MockUpdateWorkout();
    testExercises = [Exercise.barbellRow, Exercise.benchPress];
    viewModel = WorkoutViewModel(
      addWorkout: mockAddWorkout,
      updateWorkout: mockUpdateWorkout,
      exercises: testExercises,
    );
  });

  group('WorkoutViewModel', () {
    test('initial state', () {
      expect(viewModel.workout, isNull);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.error, isNull);
    });

    test('setWorkout updates workout and notifies listeners', () {
      final testWorkout =
          Workout(id: '1', name: 'Test Workout', sets: const []);
      viewModel.setWorkout(testWorkout);
      expect(viewModel.workout, equals(testWorkout));
    });

    test('addSet creates new workout if null and adds set', () {
      const testSet = WorkoutSet(
          exercise: Exercise.barbellRow, weight: 50, repetitions: 10);
      viewModel.addSet(testSet);
      expect(viewModel.workout, isNotNull);
      expect(viewModel.workout!.sets.length, equals(1));
      expect(viewModel.workout!.sets.first, equals(testSet));
    });

    test('updateSet modifies existing set', () {
      const initialSet = WorkoutSet(
          exercise: Exercise.barbellRow, weight: 50, repetitions: 10);
      const updatedSet = WorkoutSet(
          exercise: Exercise.benchPress, weight: 100, repetitions: 20);
      viewModel.setWorkout(Workout(
          id: '1',
          name: 'Test Workout',
          sets: List.from([initialSet], growable: true)));
      viewModel.updateSet(0, updatedSet);
      expect(viewModel.workout!.sets.first, equals(updatedSet));
    });

    test('removeSet removes set at given index', () {
      const testSet = WorkoutSet(
          exercise: Exercise.barbellRow, weight: 50, repetitions: 10);
      viewModel.setWorkout(Workout(
          id: '1',
          name: 'Test Workout',
          sets: List.from([testSet], growable: true)));
      viewModel.removeSet(0);
      expect(viewModel.workout!.sets, isEmpty);
    });

    test('updateName changes workout name', () {
      viewModel.setWorkout(Workout(id: '1', name: 'Old Name', sets: const []));
      viewModel.updateName('New Name');
      expect(viewModel.workout!.name, equals('New Name'));
    });

    group('saveWorkout', () {
      test('calls addWorkout for new workout', () async {
        final newWorkout = Workout.newWorkout();
        viewModel.setWorkout(newWorkout);
        when(mockAddWorkout(any)).thenAnswer((_) async => const Right(null));

        final result = await viewModel.saveWorkout();

        verifyNever(mockAddWorkout(AddWorkoutParams(newWorkout)));
        expect(result, isTrue);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, isNull);
      });

      test('calls updateWorkout for existing workout', () async {
        final existingWorkout =
            Workout(id: '1', name: 'Existing Workout', sets: const []);
        viewModel.setWorkout(existingWorkout);
        when(mockUpdateWorkout(any)).thenAnswer((_) async => const Right(null));

        final result = await viewModel.saveWorkout();

        verifyNever(mockUpdateWorkout(UpdateWorkoutParams(existingWorkout)));
        expect(result, isTrue);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, isNull);
      });

      test('handles failure for addWorkout', () async {
        final newWorkout = Workout(id: '', name: 'New Workout', sets: const []);
        viewModel.setWorkout(newWorkout);
        when(mockAddWorkout(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final result = await viewModel.saveWorkout();

        verify(mockAddWorkout(any));
        expect(result, isFalse);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, equals('Failed to save workout'));
      });

      test('handles failure for updateWorkout', () async {
        final existingWorkout =
            Workout(id: '1', name: 'Existing Workout', sets: const []);
        viewModel.setWorkout(existingWorkout);
        when(mockUpdateWorkout(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final result = await viewModel.saveWorkout();

        verify(mockUpdateWorkout(any));
        expect(result, isFalse);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, equals('Failed to save workout'));
      });
    });

    test('reset clears workout', () {
      viewModel
          .setWorkout(Workout(id: '1', name: 'Test Workout', sets: const []));
      viewModel.reset();
      expect(viewModel.workout, isNull);
    });
  });
}
