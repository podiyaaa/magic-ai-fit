// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/workout_set_tile.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/workout.dart';
import '../viewmodels/workout_viewmodel.dart';

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
              return Text(viewModel.workout?.name ?? 'New Workout');
            },
          ),
        ),
        body: Consumer<WorkoutViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.workout?.sets.length ?? 0,
              itemBuilder: (context, index) {
                return WorkoutSetTile(
                  set: viewModel.workout!.sets[index],
                  onEdit: (newSet) => viewModel.updateSet(index, newSet),
                  onDelete: () => viewModel.removeSet(index),
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
      builder: (context) => _AddWorkoutSetDialog(
        exercises: context.read<WorkoutViewModel>().exercises,
      ),
    );
  }

  Future<String?> _showNameEditDialog(
      BuildContext context, String workoutName) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => _WorkoutNameDialog(
        workoutName: workoutName,
      ),
    );
  }
}

class _AddWorkoutSetDialog extends StatefulWidget {
  const _AddWorkoutSetDialog({required this.exercises});

  final List<Exercise> exercises;

  @override
  __AddWorkoutSetDialogState createState() => __AddWorkoutSetDialogState();
}

class __AddWorkoutSetDialogState extends State<_AddWorkoutSetDialog> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  late final List<Exercise> _exercises = widget.exercises;
  late Exercise? _exercise = _exercises.firstOrNull;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: '');
    _repsController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Set'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                  value: _exercise,
                  items: Exercise.values
                      .map((exercise) => DropdownMenuItem<Exercise>(
                            value: exercise,
                            child: Text(exercise.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _exercise = value;
                  }),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repsController,
                decoration: const InputDecoration(labelText: 'Repetitions'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a repetitions';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid repetitions';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            if (_exercise == null) {
              return;
            }
            final newSet = WorkoutSet(
              exercise: _exercise!,
              weight: double.tryParse(_weightController.text) ?? 0,
              repetitions: int.tryParse(_repsController.text) ?? 0,
            );
            Navigator.of(context).pop(newSet);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// workout name dialog

class _WorkoutNameDialog extends StatefulWidget {
  const _WorkoutNameDialog({required this.workoutName});
  final String workoutName;

  @override
  State<_WorkoutNameDialog> createState() => _WorkoutNameDialogState();
}

class _WorkoutNameDialogState extends State<_WorkoutNameDialog> {
  late final _nameController = TextEditingController(text: widget.workoutName);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Name'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_nameController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
