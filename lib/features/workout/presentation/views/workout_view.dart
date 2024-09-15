import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/workout.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../widgets/add_set_dialog.dart';
import '../widgets/delete_set_alert.dart';
import '../widgets/edit_set_dialog.dart';
import '../widgets/workout_name_dialog.dart';
import '../widgets/workout_set_tile.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          context.read<WorkoutViewModel>().reset();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<WorkoutViewModel>(
            builder: (context, viewModel, child) {
              return Text(viewModel.workout?.name.isEmpty ?? true
                  ? 'New Workout'
                  : viewModel.workout!.name);
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
                  onEdit: () async {
                    final updatedSet = await _showEditDialog(context, set);
                    if (updatedSet != null) {
                      viewModel.updateSet(index, updatedSet);
                    }
                  },
                  onDelete: () async {
                    final canDelete = await _showDeleteDialog(context, set);
                    if (canDelete ?? false) {
                      viewModel.removeSet(index);
                    }
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'addSet',
              onPressed: () async {
                final set = await _showAddDialog(context);
                if (set != null) {
                  context.read<WorkoutViewModel>().addSet(set);
                }
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'saveWorkout',
              onPressed: () async {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty.')),
                  );
                  return;
                }
                context.read<WorkoutViewModel>().updateName(name);
                final success =
                    await context.read<WorkoutViewModel>().saveWorkout();
                if (success) {
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<WorkoutSet?> _showAddDialog(BuildContext context) async {
    return await showDialog<WorkoutSet>(
      context: context,
      builder: (context) => AddSetDialog(
        exercises: context.read<WorkoutViewModel>().exercises,
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
    return await showDialog<WorkoutSet>(
      context: context,
      builder: (context) => EditSetDialog(
        set: set,
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context, WorkoutSet set) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteSetAlert(),
    );
  }
}
