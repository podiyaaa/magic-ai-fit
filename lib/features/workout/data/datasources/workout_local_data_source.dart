import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/workout_model.dart';

abstract class WorkoutLocalDataSource {
  Future<List<WorkoutModel>> getWorkouts();
  Future<void> cacheWorkout(WorkoutModel workoutToCache);
  Future<void> updateWorkout(WorkoutModel workout);
  Future<void> deleteWorkout(String id);
}

const cachedWorkouts = 'CACHED_WORKOUTS';

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  WorkoutLocalDataSourceImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Future<List<WorkoutModel>> getWorkouts() {
    final jsonString = sharedPreferences.getString(cachedWorkouts);
    if (jsonString != null) {
      try {
        return Future.value(json
            .decode(jsonString)
            .map<WorkoutModel>((json) => WorkoutModel.fromJson(json))
            .toList());
      } catch (e) {
        throw CacheException();
      }
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> cacheWorkout(WorkoutModel workoutToCache) async {
    try {
      final workouts = await getWorkouts();
      workouts.add(workoutToCache);
      return _cacheWorkouts(workouts);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      final workouts = await getWorkouts();
      final index = workouts.indexWhere((w) => w.id == workout.id);
      if (index != -1) {
        workouts[index] = workout;
        return _cacheWorkouts(workouts);
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteWorkout(String id) async {
    try {
      final workouts = await getWorkouts();
      workouts.removeWhere((w) => w.id == id);
      return _cacheWorkouts(workouts);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _cacheWorkouts(List<WorkoutModel> workoutsToCache) {
    try {
      return sharedPreferences.setString(
        cachedWorkouts,
        json.encode(
            workoutsToCache.map((workout) => workout.toJson()).toList()),
      );
    } catch (e) {
      throw CacheException();
    }
  }
}
