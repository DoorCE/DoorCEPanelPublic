import 'dart:typed_data';

import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';

enum DoorButtonStyle { main, emph, norm }

class DoorButtonPlain extends StatelessWidget {
  final String _text;
  final Function()? _onPressed;
  final bool enabled;

  const DoorButtonPlain(this._text, this._onPressed, {this.enabled = true, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: enabled ? _onPressed : null,
        style: ElevatedButton.styleFrom(backgroundColor: DoorColor.darkEmph),
        child: DoorText(_text, DoorTextStyle.reverse));
  }
}

class DoorSimpleButtonIcon extends StatelessWidget {
  final String _tooltip;
  final IconData _icon;
  final Function()? _onPressed;
  final bool enabled;

  const DoorSimpleButtonIcon(this._tooltip, this._icon, this._onPressed,
      {this.enabled = true, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      disabledColor: DoorColor.grey,
      tooltip: _tooltip,
      icon: Icon(_icon, color: DoorColor.black, weight: 10, size: 20),
      onPressed: this.enabled ? _onPressed : null,
    );
  }
}

class DoorSimpleButtonImageFile extends StatelessWidget {
  final String? _tooltip;
  final Uint8List _iconFile;
  final Function() _onPressed;

  const DoorSimpleButtonImageFile(this._tooltip, this._iconFile, this._onPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Image icon = Image.memory(_iconFile, height: 32);
    return IconButton(
      tooltip: _tooltip,
      icon: icon,
      onPressed: _onPressed,
    );
  }
}

class DoorButtonText extends StatelessWidget {
  final String _text;
  final Function() _onPressed;
  final bool isActive;

  const DoorButtonText(this._text, this._onPressed, this.isActive, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onPressed,
      child: DoorText(
        _text,
        isActive ? DoorTextStyle.centerHighlight : DoorTextStyle.center,
      ),
    );
  }
}

class DoorButtonIcon extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final Function() _onPressed;
  final bool enabled;

  const DoorButtonIcon(this._text, this._icon, this._onPressed, {this.enabled = true, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: Icon(_icon, color: DoorColor.reverse),
        label: DoorText(_text, DoorTextStyle.reverse),
        onPressed: this.enabled ? _onPressed : null,
        style: ElevatedButton.styleFrom(backgroundColor: DoorColor.darkEmph));
  }
}

class DoorButtonColumn extends StatelessWidget {
  final List<(String, IconData, Function(), bool)> _buttons;

  const DoorButtonColumn(this._buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    for (var i = 0; i < _buttons.length; i++) {
      widgets
          .add(DoorButtonIcon(_buttons[i].$1, _buttons[i].$2, _buttons[i].$3, enabled: _buttons[i].$4));
      if (i != _buttons.length - 1) {
        widgets.add(const SizedBox(height: 3));
      }
    }
    return IntrinsicWidth(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets));
  }
}

class DoorToggleButtonColumn extends StatelessWidget {
  final List<(List<String>, Set<String>, Function(String), bool)> _buttons;

  const DoorToggleButtonColumn(this._buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    for (var i = 0; i < _buttons.length; i++) {
      widgets
          .add(DoorToggleButtons(options: _buttons[i].$1, initialSelection:  _buttons[i].$2, onSelectionChanged:  _buttons[i].$3, enabled: _buttons[i].$4));
      if (i != _buttons.length - 1) {
        widgets.add(const SizedBox(height: 3));
      }
    }
    return IntrinsicWidth(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: widgets));
  }
}

class DoorButtonRow extends StatelessWidget {
  final List<(String, IconData, Function())> _buttons;

  const DoorButtonRow(this._buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    for (var i = 0; i < _buttons.length; i++) {
      widgets
          .add(DoorButtonIcon(_buttons[i].$1, _buttons[i].$2, _buttons[i].$3));
      if (i != _buttons.length - 1) {
        widgets.add(const SizedBox(width: 3));
      }
    }
    return Row(children: widgets);
  }
}

class DoorButtonCard extends StatelessWidget {
  final String _text;
  final Function()? _onPressed;
  final String leftRight;
  final bool? isSelected;

  const DoorButtonCard(
      this._text, this._onPressed, this.leftRight, this.isSelected,
      {super.key});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (leftRight == 'left') {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(8.0),
      );
    } else if (leftRight == 'right') {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      );
    } else {
      // middle or any other value: no rounded corners
      borderRadius = BorderRadius.zero;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: isSelected == true
              ? const BorderSide(width: 3, color: Colors.grey)
              : BorderSide.none,
          left: isSelected == true ? BorderSide.none : BorderSide.none,
          right: isSelected == true
              ? const BorderSide(width: 2, color: Colors.grey)
              : BorderSide.none,
          bottom: isSelected == true
              ? BorderSide.none
              : const BorderSide(width: 3, color: Colors.grey),
        ),
        color: isSelected == true ? DoorColor.lightBlue : DoorColor.darkEmph,
        borderRadius: borderRadius,
        boxShadow: [
          if (isSelected == true)
            const BoxShadow(
              color: Colors.black,
            ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 5,
            spreadRadius: -5.0,
          ),
          if (isSelected != true)
            const BoxShadow(
              color: Colors.white,
            ),
          const BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            spreadRadius: -5.0,
          ),
        ],
      ),
      child: TextButton(
        onPressed: _onPressed,
        style: TextButton.styleFrom(
          backgroundColor: DoorColor.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: DoorText(_text, DoorTextStyle.emph),
      ),
    );
  }
}

class DoorButtonTextRow extends StatelessWidget {
  final List<(String, Function(), bool)> _buttons;

  const DoorButtonTextRow(this._buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    for (var i = 0; i < _buttons.length; i++) {
      widgets
          .add(DoorButtonText(_buttons[i].$1, _buttons[i].$2, _buttons[i].$3));
      if (i != _buttons.length - 1) {
        widgets.add(const SizedBox(width: 3));
      }
    }
    return Wrap(children: widgets);
  }
}

class DoorSimpleButtonIconRow extends StatelessWidget {
  final List<(String, IconData, Function()?)> _buttons;

  const DoorSimpleButtonIconRow(this._buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.empty(growable: true);

    for (var i = 0; i < _buttons.length; i++) {
      widgets.add(
          DoorSimpleButtonIcon(_buttons[i].$1, _buttons[i].$2,_buttons[i].$3, enabled: (null != _buttons[i].$3)));
      if (i != _buttons.length - 1) {
        widgets.add(const SizedBox(width: 3));
      }
    }
    return Wrap(children: widgets);
  }
}

class DoorButtonLoading extends StatefulWidget {
  final String _text;
  final Function()? _onPressed;
  final bool isLoading;
  final bool enabled;

  const DoorButtonLoading(this._text, this._onPressed,{this.isLoading = false, this.enabled=true, super.key});

  @override
  _DoorButtonLoadingState createState() => _DoorButtonLoadingState();
}

class _DoorButtonLoadingState extends State<DoorButtonLoading> {
  bool isLoading = false;

  _onPressed() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      await widget._onPressed!();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: DoorColor.darkEmph),
          child: isLoading
            ? CircularProgressIndicator(color: DoorColor.reverse)
            : DoorText(widget._text, DoorTextStyle.reverse),
          onPressed: widget.enabled ? _onPressed : null
        );
  }
}

class DoorSegmentedButton extends StatefulWidget {
  final List<String> options;
  final String initialSelection;
  final Function(String) onSelectionChanged;

  const DoorSegmentedButton({
    required this.options,
    required this.initialSelection,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  _DoorSegmentedButtonState createState() => _DoorSegmentedButtonState();
}

class _DoorSegmentedButtonState extends State<DoorSegmentedButton> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(DoorColor.lightBlue),
        overlayColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.blue.withAlpha(30);
          }
          return null;
        }),
        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: DoorColor.greyBlur),
          ),
        ),
      ),
      segments: widget.options.map((option) {
        bool isSelected = option == selectedOption;
        return ButtonSegment(
          value: option,
          label: Container(
            decoration: BoxDecoration(
              boxShadow: [
                if (isSelected)
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    spreadRadius: 1.0,
                  )
                else
                  const BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    spreadRadius: 1.0,
                  )
              ],
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(option),
          ),
        );
      }).toList(),
      selected: {selectedOption},
      onSelectionChanged: (newSelection) {
        setState(() {
          selectedOption = newSelection.first;
        });
        widget.onSelectionChanged(selectedOption);
      },
    );
  }
}

class DoorToggleButtons extends StatefulWidget {
  final List<String> options;
  final Set<String> initialSelection;
  final bool enabled;
  final bool multiSelect;
  final Function(String) onSelectionChanged;

  const DoorToggleButtons({
    required this.options,
    required this.initialSelection,
    required this.onSelectionChanged,
    this.enabled = true,
    this.multiSelect = false,
    super.key,
  });

  @override
  State<DoorToggleButtons> createState() => _DoorToggleButtonsState();
}

class _DoorToggleButtonsState extends State<DoorToggleButtons> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.initialSelection);
  }

  void _toggleSelection(String value) {
    setState(() {
      if (widget.multiSelect) {
        if (_selected.contains(value)) {
          _selected.remove(value);
        } else {
          _selected.add(value);
        }
      //} else {
       // _selected = {value};
      }
    });
    widget.onSelectionChanged(value);
  }

  BorderRadius _borderRadiusForIndex(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      );
    } else if (index == widget.options.length - 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    } else {
      return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.options.length; i++)
            _DoorToggleButton(
              text: widget.options[i],
              isSelected: _selected.contains(widget.options[i]),
              onPressed: widget.enabled == true ? () => _toggleSelection(widget.options[i]) : () {},
              borderRadius: _borderRadiusForIndex(i),
              isEdgeLeft: i == 0,
              isEdgeRight: i == widget.options.length - 1,
            ),
        ],
      ),
    );
  }
}

class _DoorToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final BorderRadius borderRadius;
  final bool isEdgeLeft;
  final bool isEdgeRight;

  const _DoorToggleButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    required this.borderRadius,
    required this.isEdgeLeft,
    required this.isEdgeRight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? DoorColor.darkEmph : Colors.grey.shade300,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            backgroundColor: Colors.transparent,
            foregroundColor: isSelected ? DoorColor.reverse : DoorColor.reverse.withOpacity(0.8),
          ),
          child: DoorText(
            text,
            isSelected ? DoorTextStyle.reverse : DoorTextStyle.reverse,
          ),
        ),
      ),
    );
  }
}

class SplitButtonItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SplitButtonItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class DoorSplitButton<T> extends StatefulWidget {
  const DoorSplitButton({
    super.key,
    required this.items,
    required this.mainValue,
    required this.onPressed,
    required this.onItemSelected,
    this.enabled = true,
    this.height = 48,
    this.width = 196
  });

  final List<String> items;
  final String mainValue;
  final Function() onPressed;
  final double height;
  final Function(String) onItemSelected;
  final double width;
  final bool enabled;

  @override
  State<DoorSplitButton<T>> createState() => _DoorSplitButtonState<T>();
}

class _DoorSplitButtonState<T> extends State<DoorSplitButton<T>> {
  bool isLoading = false;

  _onPressed () async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      setState(() => isLoading = false);
    }
  }

  _onItemSelected(String item) async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      await widget.onItemSelected(item);
    } finally {
      setState(() => isLoading = false);
    }
  }

 @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final resolvedWidth = constraints.maxWidth.isFinite
          ? (constraints.maxWidth < widget.width
              ? constraints.maxWidth
              : widget.width)
          : widget.width;

      return SizedBox(
        height: widget.height,
        width: resolvedWidth,
        child: Material(
          elevation: 1,
          color: widget.enabled
              ? DoorColor.darkEmph
              : const Color.fromARGB(255, 229, 224, 231),
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    onTap: (widget.enabled && !isLoading) ? () => _onPressed() : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: widget.height,
                        width: double.infinity,
                        child: Center(
                          child: isLoading
                              ? CircularProgressIndicator(color: DoorColor.reverse)
                              : DoorText(
                                  widget.mainValue,
                                  DoorTextStyle.reverse,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: widget.height,
                color: Colors.white24,
              ),
              MenuAnchor(
                menuChildren: widget.items.map((item) {
                  return MenuItemButton(
                    onPressed: () {
                      _onItemSelected(item);
                    },
                    style: MenuItemButton.styleFrom(
                      backgroundColor: DoorColor.darkEmph,
                      foregroundColor: DoorColor.reverse,
                    ),
                    child: DoorText(
                      item,
                      DoorTextStyle.reverse,
                    ),
                  );
                }).toList(),
                builder: (context, controller, child) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: widget.enabled && !isLoading
                          ? () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            }
                          : null,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: SizedBox(
                        width: 48,
                        height: widget.height,
                        child: Icon(
                          controller.isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: DoorColor.reverse,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
  }
}