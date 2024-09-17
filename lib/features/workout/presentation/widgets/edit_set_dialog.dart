import 'package:flutter/material.dart';

import '../../domain/entities/workout.dart';
import 'choice_chip_picker.dart';

class EditSetDialog extends StatefulWidget {
  const EditSetDialog({
    super.key,
    required this.set,
    required this.weights,
    required this.repetitions,
  });

  final List<double> weights;
  final List<int> repetitions;
  final WorkoutSet set;

  @override
  State<EditSetDialog> createState() => _EditSetDialogState();
}

class _EditSetDialogState extends State<EditSetDialog> {
  late WeightChoiceChipData _selectedWeightChoice = WeightChoiceChipData(
      label: widget.set.weight.toString(), value: widget.set.weight);
  late RepetitionChoiceChipData _selectedRepsChoice = RepetitionChoiceChipData(
      label: widget.set.repetitions.toString(), value: widget.set.repetitions);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.set.exercise.value),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                selectedChoice: _selectedWeightChoice,
                onSelected: (value) {
                  _selectedWeightChoice = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text('Repetitions',
                      style: Theme.of(context).textTheme.titleMedium),
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
                selectedChoice: _selectedRepsChoice,
                onSelected: (value) {
                  _selectedRepsChoice = value;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedSet = WorkoutSet(
              exercise: widget.set.exercise,
              weight: _selectedWeightChoice.value,
              repetitions: _selectedRepsChoice.value,
            );
            Navigator.of(context).pop(updatedSet);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
