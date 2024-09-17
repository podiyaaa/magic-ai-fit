import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/workout.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../widgets/add_set_dialog.dart';
import '../widgets/delete_set_alert.dart';
import '../widgets/edit_set_dialog.dart';
import '../widgets/unsaved_workout_alert.dart';
import '../widgets/workout_name_dialog.dart';
import '../widgets/workout_set_tile.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<WorkoutViewModel>().workout?.sets.isEmpty ?? true) {
        _onNewSet(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<WorkoutViewModel>(
            builder: (context, viewModel, child) {
              return Text(viewModel.workout?.name.isEmpty ?? true
                  ? 'New Workout'
                  : viewModel.workout!.name);
            },
          ),
          leading: BackButton(
            onPressed: () async {
              final canLeave = await _showUnsavedDialog(context);
              if (canLeave) {
                // ignore: use_build_context_synchronously
                context.read<WorkoutViewModel>().reset();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Consumer<WorkoutViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.workout?.sets.length ?? 0,
              itemBuilder: (context, index) {
                final set = viewModel.workout!.sets[index];
                return WorkoutSetTile(
                  id: set.hashCode.toString(),
                  title: set.exercise.value,
                  subtitle: '${set.weight} kg x ${set.repetitions} reps',
                  onEdit: () => _onEditSet(context, set, viewModel, index),
                  onDelete: () => _onDeleteSet(context, index, viewModel),
                );
              },
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              key: const ValueKey('workout_new_set_fab'),
              heroTag: 'workout_new_set_fab',
              onPressed: () => _onNewSet(context),
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              key: const ValueKey('workout_save_fab'),
              heroTag: 'workout_save_fab',
              onPressed: () => _onSave(context),
              child: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }

  void _onNewSet(BuildContext context) async {
    final set = await _showAddDialog(context);
    if (set != null) {
      // ignore: use_build_context_synchronously
      context.read<WorkoutViewModel>().addSet(set);
    }
  }

  void _onSave(BuildContext context) async {
    // check if there is on going save
    if (context.read<WorkoutViewModel>().isLoading) {
      return;
    }
    final workout = context.read<WorkoutViewModel>().workout;
    if (workout == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No workout to save.')),
      );
      return;
    }
    final isEmpty = workout.sets.isEmpty;
    if (isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one set.')),
      );
      return;
    }
    final name = await _showNameEditDialog(context, workout.name);
    if (name == null) {
      return;
    }
    if (name.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      return;
    }
    // ignore: use_build_context_synchronously
    context.read<WorkoutViewModel>().updateName(name);
    // ignore: use_build_context_synchronously
    final success = await context.read<WorkoutViewModel>().saveWorkout();
    if (success) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void _onEditSet(
    BuildContext context,
    WorkoutSet set,
    WorkoutViewModel viewModel,
    int index,
  ) async {
    final updatedSet = await _showEditDialog(context, set);
    if (updatedSet != null) {
      viewModel.updateSet(index, updatedSet);
    }
  }

  void _onDeleteSet(
    BuildContext context,
    int index,
    WorkoutViewModel viewModel,
  ) async {
    final canDelete = await _showDeleteDialog(context);
    if (canDelete ?? false) {
      viewModel.removeSet(index);
    }
  }

  Future<WorkoutSet?> _showAddDialog(BuildContext context) async {
    final appConfigs = context.read<WorkoutViewModel>().appConfigs;
    return await showDialog<WorkoutSet>(
      context: context,
      builder: (context) => AddSetDialog(
        exercises: appConfigs.exercises,
        weights: appConfigs.weights,
        repetitions: appConfigs.repetitions,
      ),
    );
  }

  Future<String?> _showNameEditDialog(
      BuildContext context, String workoutName) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => WorkoutNameDialog(
        workoutName: workoutName,
      ),
    );
  }

  Future<WorkoutSet?> _showEditDialog(
      BuildContext context, WorkoutSet set) async {
    final appConfigs = context.read<WorkoutViewModel>().appConfigs;
    return await showDialog<WorkoutSet>(
      context: context,
      builder: (context) => EditSetDialog(
        set: set,
        weights: appConfigs.weights,
        repetitions: appConfigs.repetitions,
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteSetAlert(),
    );
  }

  Future<bool> _showUnsavedDialog(BuildContext context) async {
    if (context.read<WorkoutViewModel>().workout?.name.isEmpty ?? true) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => const UnsavedWorkoutAlert(),
          ) ??
          false;
    }
    // we need to check updated workouts too. later...
    return true;
  }
}
