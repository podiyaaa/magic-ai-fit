import 'package:flutter/material.dart';

class WorkoutNameDialog extends StatefulWidget {
  const WorkoutNameDialog({super.key, required this.workoutName});
  final String workoutName;

  @override
  State<WorkoutNameDialog> createState() => _WorkoutNameDialogState();
}

class _WorkoutNameDialogState extends State<WorkoutNameDialog> {
  late final _nameController = TextEditingController(text: widget.workoutName);
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit name'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: const ValueKey('workout_name_dialog_text_field'),
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('workout_name_dialog_cancel_button'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const ValueKey('workout_name_dialog_save_button'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_nameController.text);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
