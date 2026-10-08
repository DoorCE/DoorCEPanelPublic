import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/text_add.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DoorTextFormFieldWithChips extends StatefulWidget {
  final List<String> items;
  final bool enabled;
  final bool isRequired;
  final void Function(List<String>) onChipAddedOrRemoved;
  final Type typeValidated;
  

  const DoorTextFormFieldWithChips({
    super.key,
    required this.items,
    required this.onChipAddedOrRemoved,
    this.enabled = true,
    this.isRequired = false,
    this.typeValidated = String
  });

  @override
  DoorTextFormFieldWithChipsState createState() => DoorTextFormFieldWithChipsState();
}

class DoorTextFormFieldWithChipsState extends State<DoorTextFormFieldWithChips> {
  late List<String> _itemList;

  @override
  void initState() {
    super.initState();
    _itemList = List.from(widget.items);
  }
  
  void didUpdateWidget(covariant DoorTextFormFieldWithChips oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (!listEquals(oldWidget.items, widget.items)) {
      setState(() {
        _itemList = List.from(widget.items);
      });
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
              DoorTextFormFieldWithAddButton(
                items: _itemList,
                onAdded: (newList) {
                  setState(() {
                    _itemList = List.from(newList);
                  });
                  widget.onChipAddedOrRemoved(List.from(_itemList));
                },
                enabled: widget.enabled,
                isRequired: widget.isRequired,
                typeValidated: widget.typeValidated,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        /// Display of existing chips
        Flexible(
          flex: 8,
          child: Column(
            children: [
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _itemList.map((item) {
                  return InputChip(
                    isEnabled: widget.enabled,
                    backgroundColor: DoorColor.lightEmph,
                    side: const BorderSide(color: DoorColor.darkEmph),
                    label: DoorText(item, DoorTextStyle.norm),
                    onDeleted: () {
                          setState(() {
                            _itemList.remove(item);
                          });
                          widget.onChipAddedOrRemoved(List.from(_itemList));
                        } 
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}