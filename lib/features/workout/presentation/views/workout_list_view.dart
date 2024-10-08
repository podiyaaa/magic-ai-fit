import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/workout_list_viewmodel.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../widgets/delete_workout_alert.dart';
import '../widgets/workout_list_tile.dart';
import 'workout_view.dart';

class WorkoutListView extends StatelessWidget {
  const WorkoutListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout List')),
      body: Consumer<WorkoutListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.error != null) {
            return Center(child: Text(viewModel.error!));
          } else {
            if (viewModel.workouts.isEmpty) {
              return const Center(child: Text('No Workouts'));
            }
            return ListView.builder(
              itemCount: viewModel.workouts.length,
              itemBuilder: (context, index) {
                final workout = viewModel.workouts[index];
                return WorkoutListTile(
                    key: ValueKey(workout.id),
                    title: workout.name,
                    subtitle: '${workout.sets.length} sets',
                    workout: workout,
                    onTap: () async {
                      context.read<WorkoutViewModel>().setWorkout(workout);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutView(),
                        ),
                      );
                      context.read<WorkoutListViewModel>().loadWorkouts();
                    },
                    onDelete: () async {
                      final canDelete = await _showDeleteDialog(context);
                      if (canDelete ?? false) {
                        viewModel.removeWorkout(workout.id);
                      }
                    });
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutView()),
          );
          context.read<WorkoutListViewModel>().loadWorkouts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(
    BuildContext context,
  ) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return const DeleteWorkoutAlert();
      },
    );
  }
}
