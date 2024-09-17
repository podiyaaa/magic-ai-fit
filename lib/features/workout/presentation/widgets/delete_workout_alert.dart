import 'package:flutter/material.dart';

class DeleteWorkoutAlert extends StatelessWidget {
  const DeleteWorkoutAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Workout'),
      content: const Text('Are you sure you want to delete this workout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
