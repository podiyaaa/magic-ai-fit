import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_ai_fit/features/workout/presentation/widgets/choice_chip_picker.dart';

void main() {
  group('ChoiceChipPicker Widget Tests', () {
    testWidgets('renders correctly with choices', (WidgetTester tester) async {
      final choices = [
        const ChoiceChipData(label: 'Option 1'),
        const ChoiceChipData(label: 'Option 2'),
        const ChoiceChipData(label: 'Option 3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceChipPicker<ChoiceChipData>(
              valueKey: const ValueKey('choice_chip_picker'),
              choices: choices,
            ),
          ),
        ),
      );

      // Verify that all choices are rendered
      for (var choice in choices) {
        expect(find.text(choice.label), findsOneWidget);
      }
    });

    testWidgets('selects correct choice when tapped',
        (WidgetTester tester) async {
      final choices = [
        const WeightChoiceChipData(label: '50kg', value: 50),
        const WeightChoiceChipData(label: '60kg', value: 60),
        const WeightChoiceChipData(label: '70kg', value: 70),
      ];

      WeightChoiceChipData? selectedChoice;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceChipPicker<WeightChoiceChipData>(
              valueKey: const ValueKey('test'),
              choices: choices,
              onSelected: (choice) {
                selectedChoice = choice;
              },
            ),
          ),
        ),
      );

      // Tap on the second choice
      await tester.tap(find.text('60kg'));
      await tester.pump();

      // Verify that the correct choice is selected
      expect(selectedChoice, choices[1]);
    });

    testWidgets('displays initially selected choice',
        (WidgetTester tester) async {
      final choices = [
        const RepetitionChoiceChipData(label: '5 reps', value: 5),
        const RepetitionChoiceChipData(label: '10 reps', value: 10),
        const RepetitionChoiceChipData(label: '15 reps', value: 15),
      ];

      final initialChoice = choices[1];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceChipPicker<RepetitionChoiceChipData>(
              valueKey: const ValueKey('test'),
              choices: choices,
              selectedChoice: initialChoice,
            ),
          ),
        ),
      );

      // Verify that the initial choice is selected
      expect(
        tester.widget<ChoiceChip>(find.byType(ChoiceChip).at(1)).selected,
        isTrue,
      );
    });

    testWidgets('scrolls horizontally when choices overflow',
        (WidgetTester tester) async {
      final choices = List.generate(
        20,
        (index) => ChoiceChipData(label: 'Option ${index + 1}'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChoiceChipPicker<ChoiceChipData>(
              valueKey: const ValueKey('test'),
              choices: choices,
            ),
          ),
        ),
      );

      // Verify that the first choice is visible
      expect(find.text('Option 1'), findsOneWidget);

      // Scroll to the right
      await tester.dragFrom(
        tester.getTopRight(find.byType(SingleChildScrollView)),
        const Offset(-500, 0),
      );
      await tester.pump();

      // Verify that the last choice is now visible
      expect(find.text('Option 20'), findsOneWidget);
    });
  });

  group('selectedChoice and onSelected Tests', () {
    testWidgets('updates selectedChoice when a new choice is tapped',
        (WidgetTester tester) async {
      final choices = [
        const WeightChoiceChipData(label: '50kg', value: 50),
        const WeightChoiceChipData(label: '60kg', value: 60),
        const WeightChoiceChipData(label: '70kg', value: 70),
      ];

      WeightChoiceChipData? selectedChoice = choices[0];

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                body: ChoiceChipPicker<WeightChoiceChipData>(
                  valueKey: const ValueKey('test'),
                  choices: choices,
                  selectedChoice: selectedChoice,
                  onSelected: (choice) {
                    setState(() {
                      selectedChoice = choice;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Verify initial selection
      expect(
        tester.widget<ChoiceChip>(find.byType(ChoiceChip).first).selected,
        isTrue,
      );

      // Tap on the second choice
      await tester.tap(find.text('60kg'));
      await tester.pump();

      // Verify that the second choice is now selected
      expect(
        tester.widget<ChoiceChip>(find.byType(ChoiceChip).at(1)).selected,
        isTrue,
      );
      expect(selectedChoice, choices[1]);

      // Tap on the third choice
      await tester.tap(find.text('70kg'));
      await tester.pump();

      // Verify that the third choice is now selected
      expect(
        tester.widget<ChoiceChip>(find.byType(ChoiceChip).at(2)).selected,
        isTrue,
      );
      expect(selectedChoice, choices[2]);
    });

    testWidgets(
        'onSelected is called with correct choice when selection changes',
        (WidgetTester tester) async {
      final choices = [
        const ChoiceChipData(label: 'Option 1'),
        const ChoiceChipData(label: 'Option 2'),
        const ChoiceChipData(label: 'Option 3'),
      ];

      ChoiceChipData? selectedChoice;
      ChoiceChipData? lastSelectedChoice;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                body: ChoiceChipPicker<ChoiceChipData>(
                  valueKey: const ValueKey('choice_chip_picker'),
                  choices: choices,
                  selectedChoice: selectedChoice,
                  onSelected: (choice) {
                    setState(() {
                      selectedChoice = choice;
                      lastSelectedChoice = choice;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Tap on the first choice
      await tester.tap(find.text('Option 1'));
      await tester.pump();

      expect(lastSelectedChoice, choices[0]);

      // Tap on the third choice
      await tester.tap(find.text('Option 3'));
      await tester.pump();

      expect(lastSelectedChoice, choices[2]);
    });
  });
}
