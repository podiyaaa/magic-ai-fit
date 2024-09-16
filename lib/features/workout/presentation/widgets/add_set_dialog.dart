import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/workout.dart';

class AddSetDialog extends StatefulWidget {
  const AddSetDialog({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  State<AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends State<AddSetDialog> {
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
      title: const Text('Add set'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField(
                  key: const ValueKey('add_set_exercise_dropdown'),
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
                key: const ValueKey('add_set_weight_field'),
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
                key: const ValueKey('add_set_reps_field'),
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
          key: const ValueKey('add_set_save_button'),
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
