import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/source_creation_request.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class NewResourceSelector extends StatefulWidget {
  final List<XAgent> agents;
  final List<XCatalogue> catalogues;
  final void Function(List<XSourceCreationRequest>) onResourceAdded;
  final void Function(String) onCatalogueSelected;
  final XAgent? currentAgent;
  final bool enabled;

  const NewResourceSelector({
    required this.agents,
    required this.catalogues,
    required this.onResourceAdded,
    required this.onCatalogueSelected,
    this.currentAgent,
    this.enabled = true,
    super.key,
  });

  @override
  State<NewResourceSelector> createState() => _NewResourceSelectorState();
}

class _NewResourceSelectorState extends State<NewResourceSelector> {
  late List<XAgent> _agents;
  late List<XCatalogue> _catalogues;
  late List<XSourceCreationRequest> _newResources;
  late XAgent? _currentAgent;
  bool _addingNew = false;

  final TextEditingController _nameController = TextEditingController();
  final List<String> _selectedAgentIds = [];
  String? _saveError;

  @override
  void initState() {
    super.initState();
    _agents = List.from(widget.agents);
    _catalogues = List.from(widget.catalogues);
    _newResources = [];
    if (widget.currentAgent != null) {
      _currentAgent = widget.currentAgent;
    } else {
      _currentAgent = null;
    }
  }

  List<DropdownItem<String>> _createCatalogueItems(BuildContext context) {
    return _catalogues.map((cat) {
      return DropdownItem<String>(
        value: cat.identifier,
        label: cat.title[Localizations.localeOf(context).languageCode] ??
            cat.title["en"] ??
            cat.title.values.first,
      );
    }).toList();
  }

  String _getAgentDisplayName(XAgent agent) {
    if (agent is XPerson) {
      String fullName = "${agent.givenNames.firstOrNull ?? ""} ${agent.familyName}";
      return fullName;
    } else if (agent is XOrganization) {
      return agent.name;
    } else {
      return agent.identifier;
    }
  }

  void _saveNewResource() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _saveError = AppLocalizations.of(context)!.noNameError);
      return;
    }

    if (_selectedAgentIds.isEmpty) {
      setState(() => _saveError = AppLocalizations.of(context)!.noAgentSelected);
      return;
    }

    final newResource = XSourceCreationRequest(name, _selectedAgentIds);

    setState(() {
      _newResources.add(newResource);
      _addingNew = false;
      _nameController.clear();
      _selectedAgentIds.clear();
      _saveError = null;
    });

    widget.onResourceAdded(_newResources);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_newResources.isNotEmpty || _addingNew) ...[
            const SizedBox(height: 8),
            DoorText("${AppLocalizations.of(context)!.selectCatForResources} *", DoorTextStyle.center),
            const SizedBox(height: 10),
            DoorMultiDropdown<String>(
              enabled: widget.enabled,
              singleSelect: true,
              items: _createCatalogueItems(context),
              onSelectionChange: (selected) {
                if (selected.isNotEmpty) {
                  widget.onCatalogueSelected(selected.first);
                }
              },
              validator: (items) {
                if (null == items || items.isEmpty) {
                  return AppLocalizations.of(context)!.required;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
          ],
        if (!_addingNew) ...[
          Row(
            //mainAxisSize: MainAxisSize.min,
            children: [
              DoorButtonPlain(AppLocalizations.of(context)!.addNewResource, () {
                setState(() {
                  _addingNew = true;
                  _saveError = null;
                  if (_currentAgent != null && !_selectedAgentIds.contains(_currentAgent!.identifier)) {
                    _selectedAgentIds.add(_currentAgent!.identifier); 
                  }});
                },
                enabled: widget.enabled),
            ],
          ),
          
        ] else
          _buildAddForm(),
      ],
    );
  }

  Widget _buildAddForm() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DoorColor.lightEmph,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: DoorColor.greyBlur),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoorText(AppLocalizations.of(context)!.addNewResource, DoorTextStyle.emph),
          const SizedBox(height: 10),
          DoorTextFormField(
            controller: _nameController,
            hintText: "${AppLocalizations.of(context)!.titleField} *",
            ),
          const SizedBox(height: 12),
          DoorText("${AppLocalizations.of(context)!.selectEditors} *", DoorTextStyle.center),
          const SizedBox(height: 6),
          Container(
            height: _agents.length <= 5 ? null : 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: DoorColor.greyBlur),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _agents.length,
              itemBuilder: (context, i) {
                final agent = _agents[i];
                final selected = _selectedAgentIds.contains(agent.identifier);
                return CheckboxListTile(
                  dense: true,
                  activeColor: DoorColor.darkEmph,
                  title: DoorText(_getAgentDisplayName(agent), DoorTextStyle.center),
                  value: selected,
                  onChanged: (_) {
                    setState(() {
                      if (selected) {
                        _selectedAgentIds.remove(agent.identifier);
                      } else {
                        _selectedAgentIds.add(agent.identifier);
                      }
                    });
                  },
                );
              },
            ),
          ),
          if (_saveError != null) ...[
            const SizedBox(height: 8),
            DoorText(_saveError!, DoorTextStyle.centerHighlight),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              DoorButtonPlain(
                AppLocalizations.of(context)!.cancel,
                () {
                  setState(() {
                    _addingNew = false;
                    _nameController.clear();
                    _selectedAgentIds.clear();
                  });
                },
              ),
              const SizedBox(width: 8),
              DoorButtonPlain(AppLocalizations.of(context)!.add, _saveNewResource),
            ],
          ),
        ],
      ),
    );
  }
}
