import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/view_elements/chips.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/common/view_elements/scenarios_form.dart';
import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/controllers/c_upsert_template_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_template_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertTemplateWindow extends StatefulWidget {
  final MUpsertTemplateWindow _model;
  final CUpsertTemplateWindow _cUpsertTemplateWindow;
  const VUpsertTemplateWindow(GlobalKey? key, this._cUpsertTemplateWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertTemplateWindow> createState() => VUpsertTemplateWindowState();
}

class VUpsertTemplateWindowState extends State<VUpsertTemplateWindow> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();

  String? _scenariosError;

  bool _validateScenarios() {
    return widget._model.validateScenarios();
  }

  @override
  void initState() {
    super.initState();
    widget._model.isInsert = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      titleController.text = widget._model.template.title;
      identifierController.text = widget._model.template.identifier;
    } else {
      widget._model.setCurrentAgentAsEditor();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    identifierController.dispose();
    super.dispose();
  }

   void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
        if (model.isInsert){
          identifierController.text = model.createAppIdentifier(titleController.text);
          widget._model.template.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  void _onSchemaOrConceptChanged() {
    if (!widget._model.isAdvancedMode)
      widget._cUpsertTemplateWindow.refreshDefaultItems(context);
  }

  String _typeKey() =>
    '${widget._model.template.auxiliaryConcepts.map((c) => c.name).join(",")}_${widget._model.template.auxiliaryConcepts.length}';

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.createTemplate :
                                                AppLocalizations.of(context)!.editTemplate;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBreadcrumb(title),
              DoorText(title, DoorTextStyle.titleBlack),
              _buildMetadataSection(),
              _buildDropdownSection(),
              _buildUsecaseScenariosSection(),
              _buildConceptsSection(),
              _buildEditorsSection(),
              _buildFooterButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(String title) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget._cUpsertTemplateWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                widget._cUpsertTemplateWindow.showSchemaManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.schemaManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(title, DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildMetadataSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.data,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        // ------------------------------ 1th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.titleField} *", DoorTextStyle.label),
                  DoorTextFormField(
                    enabled: widget._model.isMetadataEditable(),
                    controller: titleController,
                    onChanged: (v) {
                      setState(() {
                        widget._model.template.title = v;
                        _updateIdentifier();
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty) ? AppLocalizations.of(context)!.fieldRequired : null,
                  ),
                ]
              )
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.description} *", DoorTextStyle.label),
                  DoorTextFormField(
                    enabled: widget._model.isMetadataEditable(),
                    initialValue: widget._model.template.description,
                    rows: 2,
                    onChanged: (values) {
                      setState(() {
                        widget._model.template.description = values;
                      });
                    },
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                    })
                  ],
                ),
              ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.identifier} *",
                      DoorTextStyle.label),
                  DoorTextFormField(
                    controller: identifierController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                    enabled: false,
                  ),
                ],
              ),
            ),
            
            Flexible(flex: 3, child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownSection() {

    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.dataLanguage} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getLanguageItems(), 
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.template.language = values.firstOrNull ?? "";
                      });
                    },
                    validator: (items) {
                      if (null == items || items.isEmpty) {
                        return AppLocalizations.of(context)!.required;
                      }
                      return null;
                    },
                  )
                ]
              )
            )
          ],
        ),
        // ------------------------------ 3rd ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.schema} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable() && widget._model.isInsert,
                    singleSelect: true,
                    items: widget._model.getSchemaItems(),
                    onSelectionChange: (values) {
                      widget._model.template.schemaUri = values.firstOrNull ?? "";
                        _onSchemaOrConceptChanged();
                    },
                    validator: (items) {
                      if (null == items || items.isEmpty) {
                        return AppLocalizations.of(context)!.required;
                      }
                      return null;
                    },
                  )
                ]
              )
            ),
          ],
        ),
        if (!widget._model.isAdvancedMode)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.conceptName} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    key: ValueKey(widget._model.template.schemaUri),
                    enabled: widget._model.isConceptDropdownEnabled(),
                    singleSelect: true,
                    items: widget._model.getSchemaConceptItems(),
                    onSelectionChange: (values) {
                      widget._model.conceptNameForDefaultScenarios = values.firstOrNull ?? null;
                        _onSchemaOrConceptChanged();
                    },
                    validator: (items) {
                      if (widget._model.isAdvancedMode && (null == items || items.isEmpty)) {
                        return AppLocalizations.of(context)!.required;
                      }
                      return null;
                    },
                  )
                ]
              )
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.versionOf,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getTemplateItems(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.template.versionOfUri = values.firstOrNull ?? "";
                      });
                    },
                  )
                ]
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget  _buildUsecaseScenariosSection() {

    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        if (_scenariosError != null)
        Row (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 2.0),
              child: Text(
                _scenariosError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],),
          Align(
            alignment: AlignmentGeometry.centerLeft, 
            child: DoorCheckboxChip(
              enabled: !widget._model.isAdvancedMode,
              label: AppLocalizations.of(context)!.activateAdvancedScenarioEditing, 
              selected: widget._model.isAdvancedMode,
              onSelected: (value) async {
                if (0 == await showAdvancedModeDialog(context)) {
                  setState(() {
                    widget._model.isAdvancedMode = value;
                  });
                }
              }
            )
          ),
        UsecaseScenariosTabs(
          key: ValueKey("${widget._model.template.schemaUri}-${widget._model.conceptNameForDefaultScenarios}"),
          enabled: widget._model.isUsecaseScenariosEnabled(),
          initialScenarios: widget._model.template.useCaseScenarios,
          onChanged: (scenarios) {
            setState(() {
              widget._model.template.useCaseScenarios = scenarios;
            });
          },
        )
      ],
    );
  }

  Widget _buildConceptsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: Align(
            alignment: Alignment.centerLeft,
            child: DoorText("${AppLocalizations.of(context)!.concepts} *", DoorTextStyle.titleBlack)),
          subtitle: DoorText(AppLocalizations.of(context)!.clickToExpand, DoorTextStyle.norm),
          initiallyExpanded: widget._model.areConceptsEnabled(),
          controlAffinity: ListTileControlAffinity.leading,
          children: [
      
        ...widget._model.template.auxiliaryConcepts.map((concept) {
          return Container(
            key: ValueKey("concept-${concept.uid}"),
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DoorColor.lightEmph,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoorText('${AppLocalizations.of(context)!.conceptName} *', DoorTextStyle.label),
                            const SizedBox(height: 8),
                            DoorTextFormField(
                              enabled: widget._model.areConceptsEnabled(),
                              initialValue: concept.name,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (val) {
                                if (widget._model.template.auxiliaryConcepts.any((c) => c.name == val)) {
                                  return;
                                } else {
                                  setState(() {
                                    concept.name = val;
                                });
                                }
                              },
                              //controller: TextEditingController(text: concept.name)
                              //  ..selection = TextSelection.collapsed(offset: concept.name.length),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.fieldRequired;
                                }
                                if (widget._model.template.auxiliaryConcepts.any((c) => c.name == value && c.name != concept.name)) {
                                  return AppLocalizations.of(context)!.valueAlreadyUsed;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Delete concept button
                    Column(
                      children: [ 
                        const SizedBox(height: 34),
                        IconButton(
                      tooltip: AppLocalizations.of(context)!.deleteConcept,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (widget._model.areConceptsEnabled()) {
                          setState(() {
                            widget._model.removeConcept(concept);
                          });
                        }
                        return null;
                      },
                    ),]
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoorText(AppLocalizations.of(context)!.description, DoorTextStyle.label),
                            const SizedBox(height: 8),
                            DoorTextFormField(
                              enabled: widget._model.areConceptsEnabled(),
                              onChanged: (val) {
                                setState(() {
                                  concept.description = val;
                                });
                              },
                              initialValue: concept.description,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
                
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(AppLocalizations.of(context)!.properties, DoorTextStyle.label),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                ...concept.properties.map((prop) {
                  final propName = prop.name;
                  final propType = prop.type;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: DoorColor.reverse.withAlpha(204),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: DoorColor.greyBlur.withAlpha(51)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First row: Name, Type, Namespace, Remove button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Name
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: DoorTextFormField(
                                  enabled: widget._model.areConceptsEnabled(),
                                  key: ValueKey("property-name-${concept.uid}-${prop.uid}"),
                                  initialValue: propName,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  hintText: "${AppLocalizations.of(context)!.propertyName} *",
                                  onChanged: (val) {
                                    if (concept.properties.any((p) => p.name == val) && val != propName) {
                                      return;
                                    } else {
                                    setState(() {
                                      widget._model.updatePropertyName(concept, prop, val);
                                    });
                                    }
                                  },
                                  //controller: TextEditingController(text: propName)
                                  //  ..selection = TextSelection.collapsed(offset: propName.length),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.fieldRequired;
                                    }
                                    if (concept.properties.any((p) => p.name == value) && value != propName) {
                                      return AppLocalizations.of(context)!.valueAlreadyUsed;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            // Type
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: DoorMultiDropdown(
                                  enabled: widget._model.areConceptsEnabled(),
                                  key: ValueKey("property-type-${_typeKey()}-${concept.uid}-${prop.uid}"),
                                  items: widget._model.getTypeDropdownItems(context,propType),
                                  onSelectionChange: (val) {
                                    setState(() {
                                      widget._model.updatePropertyType(prop, val.firstOrNull);
                                    });
                                  },
                                  singleSelect: true,
                                  selectHint: "${AppLocalizations.of(context)!.type} *",
                                  validator: (values) {
                                    if (values == null || values.isEmpty) {
                                      return AppLocalizations.of(context)!.fieldRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                           
                            // Remove property button
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                              child: DoorSimpleButtonIcon(
                                AppLocalizations.of(context)!.deleteProperty,
                                Icons.delete,
                                () {
                                  setState((){
                                    widget._model.removeProperty(concept, prop);
                                  });
                                },
                                enabled: widget._model.areConceptsEnabled(), 
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Second row: Description, Array, Required, Unique
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description (longer, multiline)
                            Flexible(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: DoorTextFormField(
                                  enabled: widget._model.areConceptsEnabled(),
                                  rows:2,
                                  hintText: AppLocalizations.of(context)!.description,
                                  onChanged: (val) {
                                    setState(() {
                                      prop.type.description = val;
                                    });
                                  },
                                  initialValue: propType.description ?? "",
                                ),
                              ),
                            ),
                            // Array
                            Flexible(
                              flex: 1,
                              child: CheckboxListTile(
                                enabled: widget._model.areConceptsEnabled(),
                                contentPadding: EdgeInsets.only(left: 16.0),
                                title: Text(AppLocalizations.of(context)!.array, style: TextStyle(fontSize: 12)),
                                value: propType.isArray,
                                onChanged: (val) {
                                  setState((){
                                    prop.type.isArray = val ?? false;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),
                            // Required
                            Flexible(
                              flex: 1,
                              child: CheckboxListTile(
                                enabled: widget._model.areConceptsEnabled(),
                                contentPadding: EdgeInsets.zero,
                                title: Text(AppLocalizations.of(context)!.required, style: TextStyle(fontSize: 12)),
                                value: concept.required.any((r) => r.uid == prop.uid),
                                onChanged: (val){
                                  setState(() {
                                     widget._model.updatePropertyRequired(concept, prop, val ?? false);
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),
                            // Unique
                            Flexible(
                              flex: 1,
                              child: CheckboxListTile(
                                enabled: widget._model.areConceptsEnabled(),
                                contentPadding: EdgeInsets.zero,
                                title: Text(AppLocalizations.of(context)!.unique, style: TextStyle(fontSize: 12)),
                                value: concept.unique.any((r) => r.uid == prop.uid),
                                onChanged: (val) {
                                  setState(() {
                                    widget._model.updatePropertyUnique(concept, prop, val ?? false);
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                Row(
                  children: [
                    DoorButtonPlain(
                      '+ ${AppLocalizations.of(context)!.addProperty}',
                      () {
                        setState(() {
                          widget._model.addEmptyProperty(concept);
                        });
                      },
                      enabled: widget._model.areConceptsEnabled(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        Row(
          children: [
            DoorButtonPlain(
              '+ ${AppLocalizations.of(context)!.addConcept}',
              () {
                setState(() {
                  widget._model.addEmptyConcept();
                });
              },
              enabled: widget._model.areConceptsEnabled(),
            ),
          ],
        ),
      ],
    )]);
  }


  Widget _buildEditorsSection() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.editors,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        EditorRoleAssignmentWidget(
          isEditable: widget._model.isEditorsEditable(),
          availableEditors: widget._model.agents,
          availableRoles: [EditorRole.MetadataEditor, EditorRole.OwnershipEditor],
          assignments: widget._model.getRoleAssignments(),
          isAdmin: widget._model.isUserDataAdmin(),
          onEditorsChanged: 
          (values) {
            setState(() {
              widget._model.updateEditorUris(values);
              widget._model.updateRoles(values);
            });
          },
          onRolesChanged: (values) {
            setState(() {
              widget._model.updateRoles(values);
            });
          },
        ),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return Center(
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              enabled: !widget._model.isPreview,
              AppLocalizations.of(context)!.save,
              () async {
                setState(() {
                _scenariosError = !_validateScenarios()
                    ? AppLocalizations.of(context)!.fillTitlesAndDescriptions
                    : null;
                });
                if (_formKey.currentState!.validate() && _scenariosError == null) {
                  await widget._cUpsertTemplateWindow.saveSelected(context);
                } else {
                  SnackMessage().show(context, true, text: AppLocalizations.of(context)!.formError);
                }
              },
            ),
          ),
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              AppLocalizations.of(context)!.cancel,
                  () async {
                await widget._cUpsertTemplateWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertTemplateWindowFactory {
  const VUpsertTemplateWindowFactory();
  VUpsertTemplateWindow get(key, model) {
      return VUpsertTemplateWindow(key, new CUpsertTemplateWindow(model), model);
  }
}
