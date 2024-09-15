import 'package:flutter/material.dart';

class WorkoutSetTile extends StatelessWidget {
  final String id;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String title;
  final String subtitle;

  const WorkoutSetTile({
    super.key,
    required this.id,
    required this.onEdit,
    required this.onDelete,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24.0, right: 8.0),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Wrap(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(),
          ),
        ],
      ),
    );
  }
}
