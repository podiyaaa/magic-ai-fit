import 'package:flutter/material.dart';
import 'package:magic_ai_fit/features/workout/presentation/viewmodels/workout_viewmodel.dart';
import 'package:provider/provider.dart';
import '../viewmodels/workout_list_viewmodel.dart';
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
            return ListView.builder(
              itemCount: viewModel.workouts.length,
              itemBuilder: (context, index) {
                final workout = viewModel.workouts[index];
                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text('${workout.sets.length} sets'),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => viewModel.removeWorkout(workout.id),
                  ),
                );
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
}
