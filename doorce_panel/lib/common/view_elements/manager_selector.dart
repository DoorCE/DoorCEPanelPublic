import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class ManagerAssignment {
  final XAgent agent;
  List<ManagerRole> roles = [];

  ManagerAssignment({required this.agent, required this.roles});
}

class ManagerRoleAssignmentWidget extends StatefulWidget {
  final List<XAgent> availableAgents;
  final List<XAgent>? disabledAgents;
  final Map<String, List<ManagerRole>>? assignments;
  final void Function(List<ManagerAssignment>) onManagersChanged;
  final void Function(List<ManagerAssignment>) onRolesChanged;
  final bool areRolesRequired;
  final bool adminMode;
  final bool isOrganisation;

  const ManagerRoleAssignmentWidget({
    super.key,
    required this.availableAgents,
    this.disabledAgents,
    required this.assignments,
    required this.onManagersChanged,
    required this.onRolesChanged,
    this.areRolesRequired = false,
    this.adminMode = true,
    this.isOrganisation = false
  });

  @override
  State<ManagerRoleAssignmentWidget> createState() =>
      _ManagerRoleAssignmentWidgetState();
}

class _ManagerRoleAssignmentWidgetState extends State<ManagerRoleAssignmentWidget> {
  late List<ManagerAssignment> _assignments;
  late final List<ManagerRole> _availableRoles;

  MultiSelectController<XAgent> _controller = MultiSelectController<XAgent>();

  @override
  void initState() {
    super.initState();
    _availableRoles = ManagerRole.values;
    _assignments = widget.assignments?.entries.map((entry) {
      return ManagerAssignment(
        agent: widget.availableAgents.firstWhere(
          (e) => e.identifier == entry.key
        ),
        roles: entry.value,
      );
    }).toList() ?? [];
  }

  @override
  void didUpdateWidget(covariant ManagerRoleAssignmentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assignments != widget.assignments) {
      _assignments = widget.assignments?.entries.map((entry) {
      return ManagerAssignment(
        agent: widget.availableAgents.firstWhere(
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
        return ManagerAssignment(
          agent: editor,
          roles: _assignments.firstWhere(
            (e) => e.agent.identifier == editor.identifier,
            orElse: () => ManagerAssignment(agent: editor, roles: []),
          ).roles,
        );
      }).toList();
    });
    widget.onManagersChanged(_assignments);
  }
 
  void _removeEditor(XAgent editor) {
    setState(() {
      _assignments.removeWhere((e) => e.agent.identifier == editor.identifier);
    });
    widget.onManagersChanged(_assignments);
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

  bool _canModifyAgent(XAgent editor) {
    final disabled = widget.disabledAgents;
    if (disabled == null || disabled.isEmpty) return true;
    return !disabled.any((da) => da.identifier == editor.identifier);
  }

  bool _canModifyEntry(XAgent editor) {
    if (!widget.isOrganisation) {
      return _canModifyAgent(editor);
    } else {
      if (widget.adminMode) return true;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and select editor
        MultiDropdown<XAgent>(
          enabled: widget.adminMode,
          items: widget.availableAgents.map((editor) {
            return DropdownItem<XAgent>(
              value: editor,
              label: _getEditorName(editor),
              selected: _assignments.any((e) => e.agent.identifier == editor.identifier),
              disabled: (!_canModifyEntry(editor))
            );
          }).toList(),
          controller: _controller,
          onSelectionChange: (editors) {
            _updateEditors(editors);
          },
          validator: (selectedOptions) {
            if (widget.areRolesRequired && _assignments.any((e) => e.roles.isEmpty)) {
              return AppLocalizations.of(context)!.selectRolesForEditors;
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
            backgroundColor: DoorColor.reverse,
            hintText: AppLocalizations.of(context)!.select,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              ),
            showClearIcon: false
            ),
          selectedItemBuilder: (item) => Chip(
            backgroundColor: _canModifyEntry(item.value)
              ? DoorColor.lightEmph
              : Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            side: const BorderSide(color: DoorColor.darkEmph, width: 2),
            shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(12))),
            label: DoorText(item.label, DoorTextStyle.norm),
                )),

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
                leading: Icon(_getEditorIcon(assignment.agent), color: DoorColor.darkEmph
                ),
                title: DoorText(_getEditorName(assignment.agent),DoorTextStyle.label),
                subtitle: DoorText(
                  assignment.roles.isEmpty
                      ? "${AppLocalizations.of(context)!.noRolesAssigned} · ${AppLocalizations.of(context)!.clickToExpand}"
                      : "${AppLocalizations.of(context)!.roles}: ${assignment.roles.map((r) => r.getText(context)).join(', ')}",
                  DoorTextStyle.norm,
                ),
                children: _availableRoles.map((role) {
                  final isSelected = assignment.roles.contains(role);
                  return CheckboxListTile(
                    enabled: _canModifyEntry(assignment.agent),
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
                  tooltip: AppLocalizations.of(context)!.removeAgent,
                  icon: const Icon(Icons.delete, color: DoorColor.greyBlur),
                  onPressed: _canModifyEntry(assignment.agent) 
                    ? () {
                      _removeEditor(assignment.agent);
                      setState(() {
                        _controller.unselectWhere((element) => element.value.identifier == assignment.agent.identifier);
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
