import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/add_workout.dart';
import '../../domain/usecases/update_workout.dart';

class WorkoutViewModel extends ChangeNotifier {
  final AddWorkout addWorkout;
  final UpdateWorkout updateWorkout;
  final List<Exercise> exercises;

  WorkoutViewModel({
    required this.addWorkout,
    required this.updateWorkout,
    required this.exercises,
  });

  Workout? _workout;
  Workout? get workout => _workout;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void setWorkout(Workout? workout) {
    _workout = workout;
    notifyListeners();
  }

  void addSet(WorkoutSet set) {
    _workout ??= Workout.newWorkout();
    _workout!.sets.add(set);
    notifyListeners();
  }

  void updateSet(int index, WorkoutSet updatedSet) {
    if (_workout != null && index < _workout!.sets.length) {
      _workout!.sets[index] = updatedSet;
      notifyListeners();
    }
  }

  void removeSet(int index) {
    if (_workout != null && index < _workout!.sets.length) {
      _workout!.sets.removeAt(index);
      notifyListeners();
    }
  }

  void updateName(String name) {
    if (_workout != null) {
      _workout!.name = name;
      notifyListeners();
    }
  }

  Future<bool> saveWorkout() async {
    if (_workout == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    Either<Failure, void> result;
    if (_workout!.id.isEmpty) {
      _workout!.id = DateTime.now().toString();
      result = await addWorkout(AddWorkoutParams(_workout!));
    } else {
      result = await updateWorkout(UpdateWorkoutParams(_workout!));
    }

    _isLoading = false;

    return result.fold(
      (failure) {
        _error = 'Failed to save workout';
        notifyListeners();
        return false;
      },
      (_) {
        notifyListeners();
        return true;
      },
    );
  }

  void reset() {
    _workout = null;
    notifyListeners();
  }
}
