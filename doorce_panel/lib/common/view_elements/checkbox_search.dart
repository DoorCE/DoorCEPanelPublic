import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class CheckboxWithSearchableDropdown<T extends Object> extends StatefulWidget {
  final String? warningMessage;
  final String? selectHintText;
  final String checkboxLabel;
  final List<DropdownItem<T>> items;
  final Function(List<T>) onSelectionChange;
  final Function(String) onSearchChange;
  final bool enabled;
  final bool showWarning;

  const CheckboxWithSearchableDropdown({
    Key? key,
    required this.checkboxLabel,
    required this.onSearchChange,
    required this.onSelectionChange,
    required this.items,
    this.warningMessage,
    this.selectHintText,
    this.enabled=true,
    this.showWarning = false
  }) : super(key: key);

  @override
  _CheckboxWithSearchableDropdownState<T> createState() => _CheckboxWithSearchableDropdownState<T>();
}

class _CheckboxWithSearchableDropdownState<T extends Object> extends State<CheckboxWithSearchableDropdown<T>> {
  bool _isChecked = false;
  MultiSelectController<T> _controller = MultiSelectController<T>();

  void _setIsChecked() {
    _isChecked = widget.items.any((i) => i.selected == true);
  }

  @override
  void initState() {
    super.initState();
    _setIsChecked();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CheckboxWithSearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
       if (mounted) {
        final wasOpen = _controller.isOpen;
        _controller.setItems(widget.items);
        if (wasOpen) {
          _controller.closeDropdown();
          _controller.openDropdown();
        }
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Checkbox(
              activeColor: DoorColor.darkEmph,
              value: _isChecked,
              onChanged: (widget.enabled)
              ? (value) {
                setState(() {
                  _isChecked = value ?? false;
                });
                if (false == _isChecked) {
                  _controller.unselectWhere((item) => item.selected == true);
                }
              }
              : null
            ),
            DoorText(widget.checkboxLabel, DoorTextStyle.label)
          ]
        ),
        if (widget.showWarning)
          DoorText(widget.warningMessage!, DoorTextStyle.norm),
        if (_isChecked)
            DoorMultiDropdown<T>(
              selectHint: widget.selectHintText,
              controller: _controller,
              enabled: widget.enabled,
              items: widget.items,
              searchEnabled: true,
              singleSelect: true,
              onSelectionChange: widget.onSelectionChange,
              onSearchChange: widget.onSearchChange,
              validator: (value) {
                if (_isChecked && _controller.selectedItems.isEmpty) {
                  return AppLocalizations.of(context)!.fieldRequired;
                }
                return null;
              },
            ),
      ],
    );
  }
}
