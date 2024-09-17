import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magic_ai_fit/features/workout/domain/entities/workout.dart';
import 'package:magic_ai_fit/features/workout/presentation/widgets/choice_chip_picker.dart';
import 'package:magic_ai_fit/injection_container.dart' as di;
import 'package:magic_ai_fit/main.dart' as app;
import 'package:magic_ai_fit/utils/app_configs.dart';

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

      // // Tap on the add workout set button
      // await tester.tap(find.byIcon(Icons.add));
      // await tester.pumpAndSettle();

      expect(find.text('Add set'), findsOneWidget);
      // Select exercise type from dropdown
      await tester.tap(find.byKey(const ValueKey('add_set_exercise_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(Exercise.deadlift.value).last);
      await tester.pumpAndSettle();

      expect(find.text(Exercise.deadlift.value), findsOneWidget);

      // pick weight from choice chip picker

      expect(find.byKey(const ValueKey('add_set_weight_choice_chip_picker')),
          findsOneWidget);
      final scrollViewFinder = find.byKey(
          const ValueKey('add_set_weight_choice_chip_picker_scroll_view'));
      expect(scrollViewFinder, findsOneWidget);

      final weight = di.sl<AppConfigs>().weights[1];
      final chipFinder = find.byKey(
          ValueKey(WeightChoiceChipData(label: '$weight', value: weight)));
      expect(chipFinder, findsOneWidget);
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // pick repetitions from choice chip picker

      expect(find.byKey(const ValueKey('add_set_reps_choice_chip_picker')),
          findsOneWidget);
      final reps = di.sl<AppConfigs>().repetitions[1];
      final repsChipFinder = find.byKey(
          ValueKey(RepetitionChoiceChipData(label: '$reps', value: reps)));
      expect(repsChipFinder, findsOneWidget);
      await tester.tap(repsChipFinder);
      await tester.pumpAndSettle();

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

      // final scrollableFinder = find.descendant(
      //   of: scrollViewFinder,
      //   matching: find.byType(Scrollable).at(0),
      // );
      // Scroll until the item to be found appears.
      // await tester.scrollUntilVisible(
      //   chipFinder,
      //   500.0,
      //   scrollable: scrollableFinder,
      // );

      // expect(chipFinder, findsOneWidget);
    });
  });
}
