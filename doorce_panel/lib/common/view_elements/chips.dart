import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';

class DoorCheckboxChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final String? tooltip;
  final bool enabled;

  const DoorCheckboxChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.tooltip = null,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final chip = FilterChip(
        label: DoorText(label, DoorTextStyle.norm),
        selected: selected,
        onSelected: enabled ? onSelected : null,
        showCheckmark: true,
        avatar: null,
        // Outlined when unselected:
        side: BorderSide(
          color: DoorColor.darkEmph,
          width: 2.0
        ),
        backgroundColor: DoorColor.reverse, // Unselected fill
        selectedColor: DoorColor.lightEmph, // Selected fill
        checkmarkColor: DoorColor.greyBlur,
      );

    if (tooltip == null || tooltip!.isEmpty) return chip;
    return Tooltip(message: tooltip, child: chip);
  }
}