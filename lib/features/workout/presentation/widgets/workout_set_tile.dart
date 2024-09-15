import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/workout.dart';

class WorkoutSetTile extends StatelessWidget {
  final WorkoutSet set;
  final Function(WorkoutSet) onEdit;
  final Function() onDelete;

  const WorkoutSetTile({
    super.key,
    required this.set,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(set.hashCode.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      child: ListTile(
        title: Text(set.exercise.value),
        subtitle: Text('${set.weight} kg x ${set.repetitions} reps'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(context),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EditSetDialog(
        set: set,
        onSave: onEdit,
      ),
    );
  }
}

class _EditSetDialog extends StatefulWidget {
  final WorkoutSet set;
  final Function(WorkoutSet) onSave;

  const _EditSetDialog({
    required this.set,
    required this.onSave,
  });

  @override
  __EditSetDialogState createState() => __EditSetDialogState();
}

class __EditSetDialogState extends State<_EditSetDialog> {
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
            widget.onSave(updatedSet);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
