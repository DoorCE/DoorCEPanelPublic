import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';

class DoorTextFormFieldWithAddButton extends StatefulWidget {
  final List<String> items;
  final bool singleAdd;
  final bool enabled;
  final bool isRequired;
  final void Function(List<String>) onAdded;
  final Type typeValidated;
  

  const DoorTextFormFieldWithAddButton({
    super.key,
    required this.items,
    required this.onAdded,
    this.singleAdd = false,
    this.enabled = true,
    this.isRequired = false,
    this.typeValidated = String
  });

  @override
  DoorTextFormFieldWithAddButtonState createState() => DoorTextFormFieldWithAddButtonState();
}

class DoorTextFormFieldWithAddButtonState extends State<DoorTextFormFieldWithAddButton> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isValidType(String value, Type type) {
  switch (type) {
    case const (int):
      return int.tryParse(value) != null;
    case const (double):
      return double.tryParse(value) != null;
    case const (DateTime):
      return DateTime.tryParse(value) != null;
    case const (bool):
      final v = value.toLowerCase();
      return v == 'true' || v == 'false';
    default:
      return true;
  }
}

  @override
  Widget build(BuildContext context) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Left column with text field
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoorTextFormField(
                controller: _controller,
                enabled: widget.enabled,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return "Unsaved changes. Please click the add button to save.";
                  }
                  if (widget.isRequired && widget.items.isEmpty) {
                    return "This field is required.";
                  } 
                  for (var item in widget.items) {
                    if (!isValidType(item, widget.typeValidated)) {
                      return "Invalid type of item: '$item'. Expected ${widget.typeValidated}.";
                    }
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        /// Add button
        Column(
          children: [
            const SizedBox(height: 4),
            DoorSimpleButtonIcon(
              enabled: widget.enabled,
              "Add",
              Icons.add_circle_outlined,
              () {
                final doc = _controller.text;
                if ((!widget.singleAdd || widget.items.isEmpty) &&
                  doc.isNotEmpty &&
                  !widget.items.contains(doc)) {

                final updatedList = [...widget.items, doc];

                _controller.clear();

                widget.onAdded(updatedList);
              }
              },
            ),
          ],
        ),
      ],
    );
  }
}