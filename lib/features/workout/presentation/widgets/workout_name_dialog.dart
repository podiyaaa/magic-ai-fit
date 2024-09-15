import 'package:flutter/material.dart';

class WorkoutNameDialog extends StatefulWidget {
  const WorkoutNameDialog({super.key, required this.workoutName});
  final String workoutName;

  @override
  State<WorkoutNameDialog> createState() => _WorkoutNameDialogState();
}

class _WorkoutNameDialogState extends State<WorkoutNameDialog> {
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
