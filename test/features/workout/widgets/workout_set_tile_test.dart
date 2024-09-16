import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/features/workout/presentation/widgets/workout_set_tile.dart';

void main() {
  group('WorkoutSetTile', () {
    testWidgets('returns ListTile with correct contentPadding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutSetTile(
              id: 'id',
              onEdit: () {},
              onDelete: () {},
              title: 'title',
              subtitle: 'subtitle',
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
            body: WorkoutSetTile(
              id: 'id',
              onEdit: () {},
              onDelete: () {},
              title: 'title',
              subtitle: 'subtitle',
            ),
          ),
        ),
      );

      expect(find.text('title'), findsOneWidget);
      expect(find.text('subtitle'), findsOneWidget);
    });

    testWidgets(
        'displays edit IconButton with correct icon and onPressed callback',
        (tester) async {
      bool onEditCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutSetTile(
              id: 'id',
              onEdit: () => onEditCalled = true,
              onDelete: () {},
              title: 'title',
              subtitle: 'subtitle',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
      await tester.tap(find.byIcon(Icons.edit));
      expect(onEditCalled, true);
    });

    testWidgets(
        'displays delete IconButton with correct icon and onPressed callback',
        (tester) async {
      bool onDeleteCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkoutSetTile(
              id: 'id',
              onEdit: () {},
              onDelete: () => onDeleteCalled = true,
              title: 'title',
              subtitle: 'subtitle',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete));
      expect(onDeleteCalled, true);
    });
  });
}
