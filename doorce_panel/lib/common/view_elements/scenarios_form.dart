import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Scenario {
  String title;
  String description;

  Scenario({this.title = '', this.description = ''});
}

class UsecaseScenariosTabs extends StatefulWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String>? initialScenarios;
  final bool enabled;

  const UsecaseScenariosTabs({
    required this.onChanged,
    this.initialScenarios,
    this.enabled = true,
    super.key});

  @override
  State<UsecaseScenariosTabs> createState() => _UsecaseScenariosTabsState();
}

class _UsecaseScenariosTabsState extends State<UsecaseScenariosTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Scenario> _scenarios = [];

  @override
  void initState() {
    super.initState();

    _createInitialScenarios();
    _tabController = TabController(length: _scenarios.length + 1, vsync: this);
  }

  void _createInitialScenarios() {
    if (widget.initialScenarios != null && widget.initialScenarios!.isNotEmpty) {
      widget.initialScenarios!.forEach((title, description) {
        _scenarios.add(Scenario(title: title, description: description));
      });
    } else {
      _scenarios.add(Scenario());
    }
  }

  void _addScenario() {
    setState(() {
      _scenarios.add(Scenario());
      _updateTabController();
      _tabController.animateTo(_scenarios.length - 1); // go to new tab
    });
  }

  void _removeScenario(int index) {
    if (_scenarios.isEmpty) return;
    setState(() {
      _scenarios.removeAt(index);
      _updateTabController();
    });
  }

  void _updateTabController() {
    _tabController.dispose();
    _tabController = TabController(length: _scenarios.length + 1, vsync: this);
  }

  Map<String, String> _getScenariosAsMap() {
    Map<String, String> scenariosMap = {};
    for (var scenario in _scenarios) {
      scenariosMap[scenario.title] = scenario.description;
    }
    return scenariosMap;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionTile(
          title: Align(
            alignment: Alignment.centerLeft,
            child: DoorText("${AppLocalizations.of(context)!.usecaseScenarios} *", DoorTextStyle.titleBlack)),
          subtitle: DoorText(AppLocalizations.of(context)!.clickToExpand, DoorTextStyle.norm),
          initiallyExpanded: widget.enabled,
          controlAffinity: ListTileControlAffinity.leading,
          children: [
        // Tabs
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            ..._scenarios.map((entry) {
              final index = _scenarios.indexOf(entry);
              final title = entry.title.isEmpty
                  ? '${AppLocalizations.of(context)!.useCase} ${index + 1}'
                  : entry.title;
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.enabled ?
                          () { 
                            _removeScenario(index);
                            widget.onChanged(_getScenariosAsMap());
                          }
                        : null,
                      child: const Icon(Icons.close, size: 16, color: DoorColor.red),
                    ),
                  ],
                ),
              );
            }),
            const Tab(icon: Icon(Icons.add)),
          ],
          onTap: (index) {
            if (index == _scenarios.length && widget.enabled) {
              _addScenario();
              widget.onChanged(_getScenariosAsMap());
            }
          },
        ),

        // Tab views
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              ..._scenarios.map((scenario) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DoorTextFormField(
                        readOnly: !widget.enabled,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: scenario.title,
                        hintText: AppLocalizations.of(context)!.titleField,
                        onChanged: (value) {
                          setState(() {
                            scenario.title = value;
                          }); // update tab label
                          widget.onChanged(_getScenariosAsMap());
                        },
                        validator: (value) {
                          if (_scenarios.any((s) => s.title == value && s != scenario)) {
                              return AppLocalizations.of(context)!.titleNotUnique;
                            }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DoorTextFormField(
                        readOnly: !widget.enabled,
                        initialValue: scenario.description,
                        hintText: AppLocalizations.of(context)!.scenarios,
                        rows: 15,
                        onChanged: (value) {
                          setState(() {
                            scenario.description = value;
                          });
                          widget.onChanged(_getScenariosAsMap());
                        },
                      ),
                    ],
                  ),
                );
              }),
              SizedBox.shrink(), // Empty view for the add tab
            ],
          ),
        )])
      ],
    );
  }
}
