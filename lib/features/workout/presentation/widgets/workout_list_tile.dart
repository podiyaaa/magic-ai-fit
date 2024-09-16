import 'package:flutter/material.dart';

import '../../domain/entities/workout.dart';

class WorkoutListTile extends StatelessWidget {
  const WorkoutListTile({
    super.key,
    required this.workout,
    required this.onTap,
    required this.onDelete,
    required this.title,
    required this.subtitle,
  });

  final Workout workout;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24.0, right: 8.0),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () => onTap(),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => onDelete(),
      ),
    );
  }
}
