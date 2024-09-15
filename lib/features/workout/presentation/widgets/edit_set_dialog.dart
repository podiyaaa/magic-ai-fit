import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/workout.dart';

class EditSetDialog extends StatefulWidget {
  final WorkoutSet set;

  const EditSetDialog({
    super.key,
    required this.set,
  });

  @override
  State<EditSetDialog> createState() => _EditSetDialogState();
}

class _EditSetDialogState extends State<EditSetDialog> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightController =
        TextEditingController(text: widget.set.weight.toString());
    _repsController =
        TextEditingController(text: widget.set.repetitions.toString());
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
      title: const Text('Edit Set'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
            final updatedSet = WorkoutSet(
              exercise: Exercise.barbellRow,
              weight: double.tryParse(_weightController.text) ?? 0,
              repetitions: int.tryParse(_repsController.text) ?? 0,
            );
            Navigator.of(context).pop(updatedSet);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
