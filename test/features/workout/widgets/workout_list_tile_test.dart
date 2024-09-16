import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/features/workout/domain/entities/workout.dart';
import 'package:magic_ai_fit/features/workout/presentation/widgets/workout_list_tile.dart';

void main() {
  group('WorkoutListTile', () {
    testWidgets('returns ListTile with correct content padding',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutListTile(
              workout: Workout.newWorkout(),
              onTap: () {},
              onDelete: () {},
              title: 'Title',
              subtitle: 'Subtitle',
            ),
          ),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      ListTile listTile = tester.firstWidget(find.byType(ListTile));
      expect(listTile.contentPadding,
          const EdgeInsets.only(left: 24.0, right: 8.0));
    });

    testWidgets('displays title and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutListTile(
              workout: Workout.newWorkout(),
              onTap: () {},
              onDelete: () {},
              title: 'Title',
              subtitle: 'Subtitle',
            ),
          ),
        ),
      );

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });

    testWidgets('calls onTap callback when ListTile is tapped', (tester) async {
      bool onTapCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutListTile(
              workout: Workout.newWorkout(),
              onTap: () => onTapCalled = true,
              onDelete: () {},
              title: 'Title',
              subtitle: 'Subtitle',
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(onTapCalled, true);
    });

    testWidgets('calls onDelete callback when delete button is pressed',
        (tester) async {
      bool onDeleteCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutListTile(
              workout: Workout.newWorkout(),
              onTap: () {},
              onDelete: () => onDeleteCalled = true,
              title: 'Title',
              subtitle: 'Subtitle',
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      expect(onDeleteCalled, true);
    });
  });
}
