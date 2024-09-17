import 'package:flutter/material.dart';

import '../../domain/entities/workout.dart';
import 'choice_chip_picker.dart';

class AddSetDialog extends StatefulWidget {
  const AddSetDialog({
    super.key,
    required this.exercises,
    required this.weights,
    required this.repetitions,
  });

  final List<Exercise> exercises;
  final List<double> weights;
  final List<int> repetitions;

  @override
  State<AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends State<AddSetDialog> {
  WeightChoiceChipData? _selectedWeightChoice;
  RepetitionChoiceChipData? _selectedRepsChoice;
  late final List<Exercise> _exercises = widget.exercises;
  late Exercise? _exercise = _exercises.first;
  final ValueNotifier<bool> _showWeightNotFound = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showRepsNotFound = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _showWeightNotFound.dispose();
    _showRepsNotFound.dispose();
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
                items: _exercises
                    .map((exercise) => DropdownMenuItem<Exercise>(
                          value: exercise,
                          child: Text(exercise.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  _exercise = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an exercise';
                  } else if (value == Exercise.selectExercise) {
                    return 'Please select an exercise';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Weight (kg)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChipPicker<WeightChoiceChipData>(
                  valueKey: const ValueKey('add_set_weight_choice_chip_picker'),
                  choices: widget.weights
                      .map(
                        (weight) => WeightChoiceChipData(
                          label: '$weight',
                          value: weight,
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    _selectedWeightChoice = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _showWeightNotFound,
                      builder: (context, value, child) {
                        if (value) {
                          return Text(
                            'Weight not found',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text('Repetitions',
                        style: Theme.of(context).textTheme.titleMedium)
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.11,
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChipPicker<RepetitionChoiceChipData>(
                  valueKey: const ValueKey('add_set_reps_choice_chip_picker'),
                  choices: widget.repetitions
                      .map(
                        (weight) => RepetitionChoiceChipData(
                          label: '$weight',
                          value: weight,
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    _selectedRepsChoice = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _showRepsNotFound,
                      builder: (context, value, child) {
                        if (value) {
                          return Text(
                            'Repetitions not found',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                  ],
                ),
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
            if (_exercise == null ||
                _formKey.currentState!.validate() == false ||
                _selectedWeightChoice == null ||
                _selectedRepsChoice == null) {
              _showWeightNotFound.value = _selectedWeightChoice == null;
              _showRepsNotFound.value = _selectedRepsChoice == null;
              return;
            }
            final newSet = WorkoutSet(
              exercise: _exercise!,
              weight: _selectedWeightChoice!.value,
              repetitions: _selectedRepsChoice!.value,
            );
            Navigator.of(context).pop(newSet);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
