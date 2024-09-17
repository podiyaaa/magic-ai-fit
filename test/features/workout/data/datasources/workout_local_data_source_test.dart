import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/core/error/exceptions.dart';
import 'package:magic_ai_fit/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:magic_ai_fit/features/workout/data/models/workout_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([SharedPreferences])
import 'workout_local_data_source_test.mocks.dart';

void main() {
  late WorkoutLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        WorkoutLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getWorkouts', () {
    final tWorkoutList = [
      WorkoutModel(id: '1', name: 'Workout 1', sets: const []),
      WorkoutModel(id: '2', name: 'Workout 2', sets: const []),
    ];
    final tWorkoutsJson =
        json.encode(tWorkoutList.map((w) => w.toJson()).toList());

    test('should return List<WorkoutModel> when there is data in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(tWorkoutsJson);
      // act
      final result = await dataSource.getWorkouts();
      // assert
      verify(mockSharedPreferences.getString(cachedWorkouts));
      expect(result, equals(tWorkoutList));
    });

    test('should return an empty list when there is no data in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final result = await dataSource.getWorkouts();
      // assert
      verify(mockSharedPreferences.getString(cachedWorkouts));
      expect(result, equals([]));
    });

    test(
        'should throw a CacheException when there is an error decoding the JSON',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('invalid json');
      // act
      final call = dataSource.getWorkouts;
      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheWorkout', () {
    final tWorkoutModel =
        WorkoutModel(id: '1', name: 'New Workout', sets: const []);

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('[]');
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      await dataSource.cacheWorkout(tWorkoutModel);
      // assert
      final expectedJsonString = json.encode([tWorkoutModel.toJson()]);
      verify(
          mockSharedPreferences.setString(cachedWorkouts, expectedJsonString));
    });

    test(
        'should throw a CacheException when there is an error caching the data',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('[]');
      when(mockSharedPreferences.setString(any, any)).thenThrow(Exception());
      // act
      final call = dataSource.cacheWorkout;
      // assert
      expect(() => call(tWorkoutModel), throwsA(isA<CacheException>()));
    });
  });

  group('updateWorkout', () {
    final tWorkoutModel =
        WorkoutModel(id: '1', name: 'Updated Workout', sets: const []);
    final tWorkoutList = [
      WorkoutModel(id: '1', name: 'Old Workout', sets: const [])
    ];
    final tWorkoutsJson =
        json.encode(tWorkoutList.map((w) => w.toJson()).toList());

    test('should update an existing workout', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(tWorkoutsJson);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      await dataSource.updateWorkout(tWorkoutModel);
      // assert
      final expectedJsonString = json.encode([tWorkoutModel.toJson()]);
      verify(
          mockSharedPreferences.setString(cachedWorkouts, expectedJsonString));
    });

    test('should throw a CacheException when the workout does not exist',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('[]');
      // act
      final call = dataSource.updateWorkout;
      // assert
      expect(() => call(tWorkoutModel), throwsA(isA<CacheException>()));
    });
  });

  group('deleteWorkout', () {
    final tWorkoutList = [
      WorkoutModel(id: '1', name: 'Workout to Delete', sets: const [])
    ];
    final tWorkoutsJson =
        json.encode(tWorkoutList.map((w) => w.toJson()).toList());

    test('should remove an existing workout', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(tWorkoutsJson);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      await dataSource.deleteWorkout('1');
      // assert
      final expectedJsonString = json.encode([]);
      verify(
          mockSharedPreferences.setString(cachedWorkouts, expectedJsonString));
    });

    test(
        'should not throw an exception when trying to delete a non-existent workout',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn('[]');
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act & assert
      expect(() => dataSource.deleteWorkout('1'), returnsNormally);
    });
  });
}
