import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class EditorAssignment {
  final XAgent editor;
  List<EditorRole> roles = [];

  EditorAssignment({required this.editor, required this.roles});
}

class EditorRoleAssignmentWidget extends StatefulWidget {
  final List<XAgent> availableEditors;
  final Map<String, List<EditorRole>>? assignments;
  final void Function(List<EditorAssignment>) onEditorsChanged;
  final void Function(List<EditorAssignment>) onRolesChanged;
  final List<EditorRole> availableRoles;
  final bool areRolesRequired;
  final bool isEditable;
  final bool isAdmin;

  const EditorRoleAssignmentWidget({
    super.key,
    required this.availableEditors,
    required this.assignments,
    required this.onEditorsChanged,
    required this.onRolesChanged,
    this.availableRoles = EditorRole.values,
    this.areRolesRequired = true,
    this.isEditable = true,
    this.isAdmin = false
  });

  @override
  State<EditorRoleAssignmentWidget> createState() =>
      _EditorRoleAssignmentWidgetState();
}

class _EditorRoleAssignmentWidgetState extends State<EditorRoleAssignmentWidget> {
  late List<EditorAssignment> _assignments;
  late final List<EditorRole> _availableRoles;

  MultiSelectController<XAgent> _controller = MultiSelectController<XAgent>();

  @override
  void initState() {
    super.initState();
    _availableRoles = widget.availableRoles;
    _assignments = widget.assignments?.entries.map((entry) {
      return EditorAssignment(
        editor: widget.availableEditors.firstWhere(
          (e) => e.identifier == entry.key
        ),
        roles: entry.value,
      );
    }).toList() ?? [];
  }

  @override
  void didUpdateWidget(covariant EditorRoleAssignmentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assignments != widget.assignments) {
      _assignments = widget.assignments?.entries.map((entry) {
      return EditorAssignment(
        editor: widget.availableEditors.firstWhere(
          (e) => e.identifier == entry.key
        ),
        roles: entry.value,
      );
    }).toList() ?? [];
    }
  }

  void _updateEditors(List<XAgent> newEditors) {
    setState(() {
      _assignments = newEditors.map((editor) {
        return EditorAssignment(
          editor: editor,
          roles: _assignments.firstWhere(
            (e) => e.editor.identifier == editor.identifier,
            orElse: () => EditorAssignment(editor: editor, roles: []),
          ).roles,
        );
      }).toList();
    });
    widget.onEditorsChanged(_assignments);
  }
 
  void _removeEditor(XAgent editor) {
    setState(() {
      _assignments.removeWhere((e) => e.editor.identifier == editor.identifier);
    });
    widget.onEditorsChanged(_assignments);
  }

  String _getEditorName(XAgent editor) {
    if (editor is XPerson) {
        return '${editor.givenNames.first} ${editor.familyName}';
    } else if (editor is XOrganization) {
        return editor.name;
    } else {
        return editor.identifier; // Fallback for other types of agents
    }
  }

  IconData _getEditorIcon(XAgent editor) {
    if (editor is XPerson) {
      return Icons.person;
    } else if (editor is XOrganization) {
      return Icons.location_city;
    } else {
      return Icons.help; // Fallback icon
    }
  }

  bool _validateRoles() {
    if (widget.isAdmin) {
      return true;
    } else {
      var b = _assignments.any((a) => a.roles.contains(EditorRole.OwnershipEditor));
      return b;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and select editor
        MultiDropdown<XAgent>(
          enabled: widget.isEditable,
          items: widget.availableEditors.map((editor) {
            return DropdownItem<XAgent>(
              value: editor,
              label: _getEditorName(editor),
              selected: _assignments.any((e) => e.editor.identifier == editor.identifier),
            );
          }).toList(),
          controller: _controller,
          onSelectionChange: (editors) {
            _updateEditors(editors);
          },
          validator: (selectedOptions) {
            if (widget.areRolesRequired && _assignments.any((e) => e.roles.isEmpty)) {
              return AppLocalizations.of(context)!.selectRolesForEditors;
            } else if (!_validateRoles()) {
              return AppLocalizations.of(context)!.ownershipEditorError;
            }
            return null;
          },
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
            backgroundColor: widget.isEditable ? DoorColor.reverse : null,
            hintText: AppLocalizations.of(context)!.select,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              ),
            showClearIcon: widget.isEditable,
            ),
          selectedItemBuilder: widget.isEditable 
            ? null
            : (item) => Chip(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(12))),
              label: DoorText(item.label, DoorTextStyle.norm),
                  )
            ),

        const SizedBox(height: 16),

        // List of assignments
        ListView.builder(
          shrinkWrap: true,
          itemCount: _assignments.length,
          itemBuilder: (context, index) {
            final assignment = _assignments[index];
            return Card(
              child: ExpansionTile(
                initiallyExpanded: widget.areRolesRequired ? true : false,
                leading: Icon(_getEditorIcon(assignment.editor), color: DoorColor.darkEmph
                ),
                title: DoorText(_getEditorName(assignment.editor),DoorTextStyle.label),
                subtitle: DoorText(
                  assignment.roles.isEmpty
                      ? "${AppLocalizations.of(context)!.noRolesAssigned} · ${AppLocalizations.of(context)!.clickToExpand}"
                      : "${AppLocalizations.of(context)!.roles}: ${assignment.roles.map((r) => r.getText(context)).join(', ')}",
                  DoorTextStyle.norm,
                ),
                children: _availableRoles.map((role) {
                  final isSelected = assignment.roles.contains(role);
                  return CheckboxListTile(
                    enabled: widget.isEditable,
                    title: DoorText(role.getText(context), DoorTextStyle.emph),
                    activeColor: DoorColor.darkEmph,
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          assignment.roles.add(role);
                        } else {
                          assignment.roles.remove(role);
                        }
                      });
                      widget.onRolesChanged(_assignments);
                    },
                  );
                  }).toList(),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: DoorColor.greyBlur),
                  tooltip: AppLocalizations.of(context)!.removeEditor,
                  onPressed: widget.isEditable 
                    ? () {
                      _removeEditor(assignment.editor);
                      setState(() {
                        _controller.unselectWhere((element) => element.value.identifier == assignment.editor.identifier);
                      });
                    }
                    : null
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
