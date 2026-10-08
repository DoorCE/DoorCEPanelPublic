import 'package:flutter/material.dart';

class RadioConditionalSection<T> extends StatefulWidget {
  final T initialValue;
  final List<RadioOption<T>> options;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const RadioConditionalSection({
    super.key,
    required this.initialValue,
    required this.options,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<RadioConditionalSection<T>> createState() =>
      _RadioConditionalSectionState<T>();
}

class _RadioConditionalSectionState<T>
    extends State<RadioConditionalSection<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _handleChange(T newValue) {
    setState(() => _value = newValue);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.options.firstWhere((o) => o.value == _value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioGroup<T>(
          groupValue: _value,
          onChanged: (value) => _handleChange(value!),
          child: Column(
            children: widget.options.map((option) {
              return RadioListTile<T>(
                enabled: widget.enabled,
                value: option.value,
                title: Text(option.label),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        if (selected.builder != null)
          selected.builder!(context),
      ],
    );
  }
}

class RadioOption<T> {
  final T value;
  final String label;
  final WidgetBuilder? builder;

  const RadioOption({
    required this.value,
    required this.label,
    this.builder
  });
}