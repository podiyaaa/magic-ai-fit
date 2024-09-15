import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/workout/data/datasources/workout_local_data_source.dart';
import 'features/workout/data/repositories/workout_repository_impl.dart';
import 'features/workout/domain/entities/workout.dart';
import 'features/workout/domain/repositories/workout_repository.dart';
import 'features/workout/domain/usecases/add_workout.dart';
import 'features/workout/domain/usecases/delete_workout.dart';
import 'features/workout/domain/usecases/get_workouts.dart';
import 'features/workout/domain/usecases/update_workout.dart';
import 'features/workout/presentation/viewmodels/workout_list_viewmodel.dart';
import 'features/workout/presentation/viewmodels/workout_viewmodel.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ViewModels
  sl.registerFactory(
    () => WorkoutListViewModel(
      getWorkouts: sl(),
      deleteWorkout: sl(),
    ),
  );

  sl.registerFactory(
    () => WorkoutViewModel(
      addWorkout: sl(),
      updateWorkout: sl(),
      exercises: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWorkouts(sl()));
  sl.registerLazySingleton(() => AddWorkout(sl()));
  sl.registerLazySingleton(() => UpdateWorkout(sl()));
  sl.registerLazySingleton(() => DeleteWorkout(sl()));

  // Repository
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WorkoutLocalDataSource>(
    () => WorkoutLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Exercises
  sl.registerLazySingleton<List<Exercise>>(() => Exercise.values);
}
