import 'package:flutter/material.dart';

class DeleteSetAlert extends StatelessWidget {
  const DeleteSetAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Set'),
      content: const Text('Are you sure you want to delete this set?'),
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
