import 'package:flutter/material.dart';

class ChoiceChipData {
  const ChoiceChipData({
    required this.label,
  });

  final String label;

  @override
  bool operator ==(Object other) =>
      other is ChoiceChipData && other.label == label;

  @override
  int get hashCode => Object.hashAll([label]);
}

class WeightChoiceChipData extends ChoiceChipData {
  const WeightChoiceChipData({
    required super.label,
    required this.value,
  });

  final double value;

  @override
  bool operator ==(Object other) =>
      other is WeightChoiceChipData && other.value == value;

  @override
  int get hashCode => Object.hashAll([value]);
}

class RepetitionChoiceChipData extends ChoiceChipData {
  const RepetitionChoiceChipData({
    required super.label,
    required this.value,
  });

  final int value;

  @override
  bool operator ==(Object other) =>
      other is RepetitionChoiceChipData && other.value == value;

  @override
  int get hashCode => Object.hashAll([value]);
}

class ChoiceChipPicker<T extends ChoiceChipData> extends StatefulWidget {
  const ChoiceChipPicker({
    required this.choices,
    this.selectedChoice,
    this.onSelected,
    required this.valueKey,
  }) : super(key: valueKey);

  final ValueKey<String> valueKey;
  final List<T> choices;
  final T? selectedChoice;
  final ValueChanged<T>? onSelected;

  @override
  State<ChoiceChipPicker<T>> createState() => _ChoiceChipPickerState<T>();
}

class _ChoiceChipPickerState<T extends ChoiceChipData>
    extends State<ChoiceChipPicker<T>> {
  late T? selectedChoice = widget.selectedChoice;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ValueKey('${widget.valueKey.value}_scroll_view'),
      child: Wrap(
          children: widget.choices.map((T choice) {
        return Container(
          margin: const EdgeInsets.only(right: 4.0),
          child: ChoiceChip(
            key: ValueKey(choice),
            visualDensity: VisualDensity.compact,
            label: Text(choice.label),
            selected: selectedChoice == choice,
            onSelected: (bool selected) {
              selectedChoice = choice;
              if (selectedChoice != null) {
                widget.onSelected?.call(selectedChoice!);
              }
              setState(() {});
            },
          ),
        );
      }).toList()),
    );
  }
}
