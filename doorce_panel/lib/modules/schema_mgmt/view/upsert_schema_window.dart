import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/namespace.dart';
import 'package:doorce_panel/dtos/property.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/controllers/c_upsert_schema_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_schema_window.dart';

import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertSchemaWindow extends StatefulWidget {
  final MUpsertSchemaWindow _model;
  final CUpsertSchemaWindow _cUpsertSchemaWindow;
  const VUpsertSchemaWindow(GlobalKey? key, this._cUpsertSchemaWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertSchemaWindow> createState() => VUpsertSchemaWindowState();
}

class VUpsertSchemaWindowState extends State<VUpsertSchemaWindow> {
  final _formKey = GlobalKey<FormState>();

  String? _conceptsError;

  // Text Fields Controllers
  final TextEditingController schemaTitleController = TextEditingController();
  final TextEditingController schemaDescriptionController = TextEditingController();
  final TextEditingController schemaIdentifierController = TextEditingController();
  final TextEditingController namespacePrefixController = TextEditingController();
  final TextEditingController namespaceIriController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    schemaTitleController.dispose();
    schemaIdentifierController.dispose();
    schemaDescriptionController.dispose();
    namespacePrefixController.dispose();
    namespaceIriController.dispose();
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
        schemaIdentifierController.text = model.createSchemaIdentifier(schemaTitleController.text);
        widget._model.schema.identifier = schemaIdentifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  bool _validateCustomNamespaceBeforeAdding(String iri, String prefix) {
    bool isNew = widget._model.isNamespaceNew(prefix);
    bool isPrefixNotEmpty = prefix.isNotEmpty;
    bool isIriNotEmpty = iri.isNotEmpty;
    bool isNonStandard = widget._model.isNamespaceUnique(iri, prefix);
    return isNew && isPrefixNotEmpty && isIriNotEmpty && isNonStandard;
  }

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      schemaTitleController.text = widget._model.schema.title;
      schemaDescriptionController.text = widget._model.schema.description;
      schemaIdentifierController.text = widget._model.schema.identifier;
    } else {
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
      });
    });
  }

  String _usedNamespacesKey() =>
    '${widget._model.getCustomNamespaces().map((e)
       => e.prefix).join(",")}_${widget._model.getCustomNamespaces().length}';

  String _namespaceKey() =>
    '${widget._model.schema.defaultNamespacePrefix ?? ""}_${widget._model.schema.namespaces.map((e)
       => e.prefix).join(",")}_${widget._model.schema.namespaces.length}';

  String _conceptKey() =>
    '${widget._model.schema.concepts.map((c) => c.name).join(",")}';
  
  String _typeKey() =>
    '${widget._model.schema.concepts.map((c) => c.name).join(",")}_${widget._model.schema.concepts.length}';

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.addSchema :
                                                AppLocalizations.of(context)!.editSchema;
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
              //const SizedBox(height: 24),
              DoorText(title, DoorTextStyle.titleBlack),
              //const SizedBox(height: 24),
              Card(
                margin: const EdgeInsets.only(bottom: 32),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainDetailsSection(),
                      const SizedBox(height: 24),
                      _buildNamespaceSection(),
                      const SizedBox(height: 24),
                      _buildConceptsSection(),
                    ],
                  ),
                ),
              ),
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
            onTap: () => widget._cUpsertSchemaWindow.homeSelected(context),
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
            onTap: () => widget._cUpsertSchemaWindow
                .showSchemaManagementSelected(context),
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

  Widget _buildMainDetailsSection() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText("${AppLocalizations.of(context)!.schemaTitle} *", DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      enabled: !widget._model.isPreview,
                      controller: schemaTitleController,
                      onChanged: (value) {
                        setState(() {
                          widget._model.schema.title = value;
                          _updateIdentifier();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                      }
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText("${AppLocalizations.of(context)!.identifier} *", DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      controller: schemaIdentifierController,
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
            ),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoorText("${AppLocalizations.of(context)!.schemaSeries} *", DoorTextStyle.label),
                  const SizedBox(height: 8),
                  DoorMultiDropdown<XSchemaSeries>(
                    enabled: !widget._model.isPreview,
                    singleSelect: true,
                    items: widget._model.getSchemaSeriesOptions(context),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.schema.seriesTitle = values.firstOrNull?.title ?? "";
                        widget._model.schema.seriesIdentifier = values.firstOrNull?.identifier ?? "";
                      });
                    },
                    validator: (values) {
                      if (values == null || values.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Flexible(
              flex: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoorText("${AppLocalizations.of(context)!.description} *", DoorTextStyle.label),
                  const SizedBox(height: 8),
                  DoorTextFormField(
                    enabled: !widget._model.isPreview,
                    controller: schemaDescriptionController,
                    onChanged: (value) { 
                      setState((){
                      widget._model.schema.description = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                    rows:2,                                    
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNamespaceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.namespaces,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoorText("${AppLocalizations.of(context)!.usedNamespaces} *", DoorTextStyle.label),
                  const SizedBox(height: 8),
                  DoorMultiDropdown<XNamespace>(
                    enabled: !widget._model.isPreview,
                    key:ValueKey('selected-namespaces-dropdown-${_usedNamespacesKey()}'),
                    items: widget._model.getSchemaNamespaceOptions(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.schema.namespaces = values;
                      });
                    },
                    validator: (values) {
                      if (values == null || values.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Default Namespace Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.defaultNamespace,
              DoorTextStyle.label,
            ),
            ]),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Flexible(child:
              DoorMultiDropdown<XNamespace>(
                enabled: !widget._model.isPreview,
                key: ValueKey('default-namespace-dropdown-${_usedNamespacesKey()}'),
                items: widget._model.getDefaultNamespaceOptions(),
                onSelectionChange: (value) {
                  setState(() {
                    widget._model.schema.defaultNamespaceIri = value.firstOrNull?.iri ?? null;
                    widget._model.schema.defaultNamespacePrefix = value.firstOrNull?.prefix ?? null;
                  });},
                singleSelect: true,
              )
            )
          ],
        ),
      ],
    ),
    const SizedBox(height: 30),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.newNamespaces,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
      ]),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(AppLocalizations.of(context)!.namespacePrefix, DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      enabled: !widget._model.isPreview,
                      controller: namespacePrefixController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (values) {
                        if (!widget._model.isCustomPrefixUnique(values)) {
                          return AppLocalizations.of(context)!.customPrefixNotUnique;
                        }
                        if (values!.isNotEmpty) {
                          return AppLocalizations.of(context)!.unsavedChanges;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(AppLocalizations.of(context)!.namespaceIri, DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      enabled: !widget._model.isPreview,
                      controller: namespaceIriController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (values) {
                        if (!widget._model.isCustomIriUnique(values)) {
                          return AppLocalizations.of(context)!.customIriNotUnique;
                        }
                        if (values!.isNotEmpty) {
                          return AppLocalizations.of(context)!.unsavedChanges;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 34),
              DoorSimpleButtonIcon(
                enabled: !widget._model.isPreview,
                AppLocalizations.of(context)!.add,
                Icons.add_circle_outlined,
                () {
                  final prefix = namespacePrefixController.text.trim();
                  final iri = namespaceIriController.text.trim();
                  setState(() {
                    if (_validateCustomNamespaceBeforeAdding(iri, prefix)) {
                      widget._model.addCustomNamespace(iri, prefix);
                      namespacePrefixController.clear();
                      namespaceIriController.clear();
                    }
                  });
                })
          ],
        ),
          ]
        ),
        
      ],
    );
  }

  Widget _buildConceptsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText("${AppLocalizations.of(context)!.concepts} *", DoorTextStyle.titleBlack),
            const Spacer(),
            ],
        ),
        if (_conceptsError != null)
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 2.0),
          child: Text(
            _conceptsError!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
        const SizedBox(height: 20),

        // Main Concept MultiDropdown (below title)
        if (!widget._model.isConceptsEmpty()) 
        Row(
              children: [
                DoorText(
                  "${AppLocalizations.of(context)!.mainConcept} *",
                  DoorTextStyle.label,
                ),]),
        const SizedBox(height: 8),
        if (!widget._model.isConceptsEmpty())
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: DoorMultiDropdown<XConcept>(
                  key: ValueKey('main-concept-${_conceptKey()}'),
                  items: widget._model.getMainConceptOptions(context),
                  singleSelect: true,
                  enabled: widget._model.isSchemaEditable(),
                  onSelectionChange: (concept) {
                    setState(() {
                      widget._model.schema.mainConcept = concept.firstOrNull;
                    });
                  },
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return AppLocalizations.of(context)!.fieldRequired;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
      
        const SizedBox(height: 8),
        ...widget._model.schema.concepts.map((concept) {
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
                              initialValue: concept.name,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              enabled: widget._model.isSchemaEditable(),
                              onChanged: (val) {
                                if (widget._model.schema.concepts.any((c) => c.name == val)) {
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
                                if (widget._model.schema.concepts.any((c) => c.name == value && c.name != concept.name)) {
                                  return AppLocalizations.of(context)!.valueAlreadyUsed;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DoorText("${AppLocalizations.of(context)!.namespace} *", DoorTextStyle.label),
                          const SizedBox(height: 8),
                          DoorMultiDropdown(
                            key: ValueKey('concept-namespace-${_namespaceKey()}-${concept.uid}'),
                            items: widget._model.getNamespaceDropdownItems(context, concept.namespacePrefix),
                            enabled: widget._model.isSchemaEditable(),
                            onSelectionChange: (val) {
                              setState (() {
                                concept.namespacePrefix = val.firstOrNull;
                              });
                            },
                            singleSelect: true,
                            validator: (values) {
                              if (values!.isEmpty) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (values.first.value.isEmpty && widget._model.isDefaultNamespaceNull()) {
                                return AppLocalizations.of(context)!.defaultNotSet;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    // Delete concept button
                    Column(
                      children: [ 
                        const SizedBox(height: 34),
                        IconButton(
                      tooltip: AppLocalizations.of(context)!.deleteConcept,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: widget._model.isSchemaEditable()
                      ? () async {
                        if (0 == await showDeleteConceptDialog(context, concept.name)) {
                        setState(() {
                            widget._model.removeConcept(concept);
                        });
                      }
                      }
                      : null,
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
                              onChanged: (val) {
                                setState(() {
                                  concept.description = val;
                                });
                              },
                              initialValue: concept.description,
                              enabled: widget._model.isSchemaEditable(),
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
                    DoorText(AppLocalizations.of(context)!.idProperty, DoorTextStyle.label),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8,),
                DoorMultiDropdown<XProperty>(
                  key: Key("concept-defaultId-${concept.uid}-${concept.properties.map((p) => p.name).join("-")}"),
                  items: widget._model.getConceptDefaultIdOptions(context, concept),
                  singleSelect: true,
                  enabled: widget._model.isSchemaEditable(),
                  onSelectionChange: (values) {
                    setState(() {
                      concept.defaultIdentifier = values.firstOrNull;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    
                    if (!concept.unique.any((p) => p.uid == value.first.value.uid) || !concept.required.any((r) => r.uid == value.first.value.uid)) {
                      return AppLocalizations.of(context)!.idMustBeUniqueAndRequired;
                    }
                    return null;
                  },),
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
                                  key: ValueKey("property-name-${concept.uid}-${prop.uid}"),
                                  initialValue: propName,
                                  enabled: widget._model.isSchemaEditable(),
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
                                    if (widget._model.doesPropertyNameMatchKeywords(value)) {
                                      // TODO - add custom localized message
                                      return AppLocalizations.of(context)!.invalidIdentifier;
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
                                  key: ValueKey("property-type-${_typeKey()}-${concept.uid}-${prop.uid}"),
                                  items: widget._model.getTypeDropdownItems(context,propType),
                                  onSelectionChange: (val) {
                                    setState(() {
                                      widget._model.updatePropertyType(prop, val.firstOrNull);
                                    });
                                  },
                                  enabled: widget._model.isSchemaEditable(),
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
                            // Namespace
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DoorText(
                                      "${AppLocalizations.of(context)!.namespace} *",
                                      DoorTextStyle.label,
                                    ),
                                    const SizedBox(height: 8),
                                    DoorMultiDropdown(
                                      enabled: widget._model.isSchemaEditable(),
                                      key: ValueKey('property-namespace-${_namespaceKey()}-${concept.uid}-${prop.uid}'),
                                      items: widget._model.getNamespaceDropdownItems(context, propType.namespacePrefix),
                                      onSelectionChange: (val) {
                                        setState(() {
                                          prop.type.namespacePrefix = val.firstOrNull;
                                        });
                                      },
                                      singleSelect: true,
                                      validator: (values) {
                                        if (values!.isEmpty) {
                                          return AppLocalizations.of(context)!.fieldRequired;
                                        } else if (values.first.value.isEmpty && widget._model.isDefaultNamespaceNull()) {
                                          return AppLocalizations.of(context)!.defaultNotSet;
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
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
                                enabled: widget._model.isSchemaEditable(),
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
                                  rows:2,
                                  hintText: AppLocalizations.of(context)!.description,
                                  onChanged: (val) {
                                    setState(() {
                                      prop.type.description = val;
                                    });
                                  },
                                  initialValue: propType.description ?? "",
                                  enabled: widget._model.isSchemaEditable(),
                                ),
                              ),
                            ),
                            // Array
                            Flexible(
                              flex: 1,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.only(left: 16.0),
                                title: Text(AppLocalizations.of(context)!.array, style: TextStyle(fontSize: 12)),
                                value: propType.isArray,
                                enabled: widget._model.isSchemaEditable(),
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
                                contentPadding: EdgeInsets.zero,
                                title: Text(AppLocalizations.of(context)!.required, style: TextStyle(fontSize: 12)),
                                value: concept.required.any((r) => r.uid == prop.uid),
                                enabled: widget._model.isSchemaEditable(),
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
                                contentPadding: EdgeInsets.zero,
                                title: Text(AppLocalizations.of(context)!.unique, style: TextStyle(fontSize: 12)),
                                value: concept.unique.any((r) => r.uid == prop.uid),
                                enabled: widget._model.isSchemaEditable(),
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
                      enabled: widget._model.isSchemaEditable(),
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
              enabled: widget._model.isSchemaEditable(),
            ),
          ],
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
                _conceptsError = widget._model.isConceptsEmpty()
                    ? AppLocalizations.of(context)!.fieldRequired
                    : null;
                });
                if (_formKey.currentState!.validate() && !widget._model.isConceptsEmpty()) {
                  await widget._cUpsertSchemaWindow.saveSelected(context);
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
                await widget._cUpsertSchemaWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertSchemaWindowFactory {
  const VUpsertSchemaWindowFactory();
  VUpsertSchemaWindow get(key, model) {
      return VUpsertSchemaWindow(key, new CUpsertSchemaWindow(model), model);
  }
}