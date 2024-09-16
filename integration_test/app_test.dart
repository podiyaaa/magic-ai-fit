import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magic_ai_fit/features/workout/domain/entities/workout.dart';
import 'package:magic_ai_fit/main.dart' as app;

Future<void> setupTestEnvironment() async {
  WidgetsFlutterBinding.ensureInitialized();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await setupTestEnvironment();
  });

  group('end-to-end test', () {
    testWidgets('tap on add workout, fill form, save and verify',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify that we are on the workout list screen
      expect(find.text('Workout List'), findsOneWidget);

      // Tap on the add workout button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify that we are on the new workout screen
      expect(find.text('New Workout'), findsOneWidget);

      // Tap on the add workout set button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Add set'), findsOneWidget);
      // Select exercise type from dropdown
      await tester.tap(find.byKey(const ValueKey('add_set_exercise_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(Exercise.deadlift.value).last);
      await tester.pumpAndSettle();

      expect(find.text(Exercise.deadlift.value), findsOneWidget);

      await tester.enterText(
          find.byKey(const ValueKey('add_set_weight_field')), '50');
      await tester.enterText(
          find.byKey(const ValueKey('add_set_reps_field')), '10');

      // Save the workout
      await tester.tap(find.byKey(const ValueKey('add_set_save_button')));
      await tester.pumpAndSettle();

      // tap on save button
      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Name dialog
      expect(find.text('Edit name'), findsOneWidget);
      await tester.enterText(
          find.byKey(const ValueKey('workout_name_dialog_text_field')), 'W1');
      await tester
          .tap(find.byKey(const ValueKey('workout_name_dialog_save_button')));
      await tester.pumpAndSettle();

      // Verify that we are back on the workout list screen
      expect(find.text('Workout List'), findsOneWidget);

      // Verify that the new workout appears in the list
      expect(find.text('W1'), findsOneWidget);

      // tap on created workout
      await tester.tap(find.text('W1').last);
      await tester.pumpAndSettle();

      // Verify that we are on the edit workout screen
      expect(find.text('W1'), findsOneWidget);

      // Verify that the created sets of workout appears in the list
      expect(find.text(Exercise.deadlift.value), findsOneWidget);
    });
  });
}
