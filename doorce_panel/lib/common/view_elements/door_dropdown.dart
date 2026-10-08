import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class DoorMultiDropdown<T extends Object> extends StatefulWidget {
  final List<DropdownItem<T>> items;
  final MultiSelectController<T>? controller;
  final Function(List<T> selectedItems) onSelectionChange;
  final Function(String)? onSearchChange;
  final String? Function(List<DropdownItem<T>>?)? validator;
  final String? selectHint;
  final bool singleSelect;
  final Key? key;
  final bool enabled;
  final bool searchEnabled;
  final AutovalidateMode autovalidateMode;
  

  const DoorMultiDropdown({required this.items, required this.onSelectionChange, this.onSearchChange,
    this.controller, this.singleSelect=false, this.enabled=true, this.validator, this.selectHint, this.key,
    this.searchEnabled=false, this.autovalidateMode = AutovalidateMode.disabled});

  @override
  _DoorMultiDropdownState<T> createState() => _DoorMultiDropdownState<T>();
}

class _DoorMultiDropdownState<T extends Object> extends State<DoorMultiDropdown<T>> {
  MultiSelectController<T>? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.searchEnabled)
      _controller = MultiSelectController();
  }

  @override
  void dispose() {
    if (widget.searchEnabled) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DoorMultiDropdown<T> oldWidget) {
    if (widget.items != oldWidget.items && true == widget.searchEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller != null) {
          final wasOpen = _controller!.isOpen;
          _controller!.setItems(widget.items);
          if (wasOpen) {
            _controller!.closeDropdown();
            _controller!.openDropdown();
          }
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<T>(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      key: widget.key,
      items: widget.items,
      controller: widget.searchEnabled ? _controller : widget.controller ?? null,
      onSelectionChange: widget.onSelectionChange,
      validator: widget.validator ?? null,
      singleSelect: widget.singleSelect,
      dropdownItemDecoration: const DropdownItemDecoration(
        selectedIcon: Icon(Icons.check_box, color: Colors.green)
        ),
      chipDecoration: ChipDecoration(
        wrap: true,
        labelStyle: TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: DoorColor.lightEmph,
        border: Border(
          top: BorderSide(color: DoorColor.darkEmph, width: 2),
          left: BorderSide(color: DoorColor.darkEmph, width: 2),
          right: BorderSide(color: DoorColor.darkEmph, width: 2),
          bottom: BorderSide(color: DoorColor.darkEmph, width: 2)
          )
          ),
      fieldDecoration: FieldDecoration(
        backgroundColor: widget.enabled ? DoorColor.reverse : null,
        hintText: widget.selectHint ?? AppLocalizations.of(context)!.select,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          ),
        showClearIcon: widget.enabled,
        ),
      selectedItemBuilder: widget.enabled 
        ? null 
        :(item) => Chip(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(12))),
          label: DoorText(item.label, DoorTextStyle.norm),
        ),
      searchDecoration: SearchFieldDecoration(
        hintText: AppLocalizations.of(context)!.search
      ),
      searchEnabled: widget.searchEnabled,
      onSearchChange: widget.searchEnabled 
        ? widget.onSearchChange
        : null,
      );
  }
}