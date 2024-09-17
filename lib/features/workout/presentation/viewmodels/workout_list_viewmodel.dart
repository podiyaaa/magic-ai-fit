import 'package:flutter/foundation.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/delete_workout.dart';
import '../../domain/usecases/get_workouts.dart';

class WorkoutListViewModel extends ChangeNotifier {
  WorkoutListViewModel(
      {required this.getWorkouts, required this.deleteWorkout});
  final GetWorkouts getWorkouts;
  final DeleteWorkout deleteWorkout;

  List<Workout> _workouts = [];
  List<Workout> get workouts => _workouts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getWorkouts(NoParams());
    result.fold(
      (failure) {
        _error = 'Failed to load workouts';
      },
      (workouts) {
        _workouts = workouts;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeWorkout(String id) async {
    final result = await deleteWorkout(DeleteWorkoutParams(id));
    result.fold(
      (failure) {
        _error = 'Failed to delete workout';
      },
      (_) {
        _workouts.removeWhere((workout) => workout.id == id);
      },
    );
    notifyListeners();
  }
}
