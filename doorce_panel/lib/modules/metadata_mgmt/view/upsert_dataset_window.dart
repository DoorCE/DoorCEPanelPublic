import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/text_chips.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/controllers/c_upsert_dataset_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_dataset_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

enum ExportMode {
  normal,
  withMetadata,
  compressed,
}

class VUpsertDatasetWindow extends StatefulWidget {
  final CUpsertDatasetWindow _cUpsertDatasetWindow;
  final MUpsertDatasetWindow _model;
  const VUpsertDatasetWindow(GlobalKey? key, this._cUpsertDatasetWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertDatasetWindow> createState() => VUpsertDatasetWindowState();
}

class VUpsertDatasetWindowState extends State<VUpsertDatasetWindow> {
  final _formKey = GlobalKey<FormState>();

  // Single Selection Fields
  String? selectedMetadataLanguageCode = "en"; //used as a key in title/descr dicts

  // Date
  DateTime? fromDate;
  DateTime? toDate;

  // Text Fields Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController versionController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactContentsController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  // Dropdown Controllers
  final MultiSelectController<String> _metadataLanguageSelectController =
      MultiSelectController<String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    versionController.dispose();
    identifierController.dispose();
    descriptionController.dispose();
    contactContentsController.dispose();
    contactNameController.dispose();
    _metadataLanguageSelectController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  void _dynamicallyUpdateIdentifier() {
    if (widget._model.isDatasetTitlesEmpty()) {
      _updateIdentifier();
    }
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert){
        identifierController.text = model.createDatasetIdentifier(titleController.text);
        widget._model.dataset.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  void _updateTitleDescriptionOnLanguageChange() {
    setState(() {
      titleController.text = widget._model.dataset.title[selectedMetadataLanguageCode] ?? "";
      descriptionController.text =
          widget._model.dataset.description[selectedMetadataLanguageCode] ?? "";
    });
  }

  void _refreshAgentContactOptions() async {   
    await widget._cUpsertDatasetWindow.contactSourcesChanged(context);
  }

  void _refreshTargetDatasetOptions() async {
    await widget._cUpsertDatasetWindow.statusOrSchemaChanged(context);
  }

  bool _validateContactFieldsBeforeAdding() {
    bool isNew = widget._model.isContactNew(contactNameController.text, contactContentsController.text);
    bool isNameNotEmpty = contactNameController.text.isNotEmpty;
    bool isContentsNotEmpty = contactContentsController.text.isNotEmpty;
    return isNew && isNameNotEmpty && isContentsNotEmpty;
  }

  String _dateToString(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year.toString()}";
  }

  String _contactsSelectKey() =>
    "${widget._model.datasetAgentsContacts.map((e) => e.identifier).join("-")}"
    "${widget._model.getNewContacts().map((e) => e.identifier).join("-")}";

  String _getWindowTitle() {
    if (widget._model.isPreview) return AppLocalizations.of(context)!.previewDataset;

    return widget._model.isInsert ? AppLocalizations.of(context)!.addNewDataset :
                                   AppLocalizations.of(context)!.editDataset;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      selectedMetadataLanguageCode ??= "en";
      titleController.text = widget._model.dataset.title[selectedMetadataLanguageCode] ?? "";
      descriptionController.text = widget._model.dataset.description[selectedMetadataLanguageCode] ?? "";
      identifierController.text = widget._model.dataset.identifier;
      versionController.text = widget._model.dataset.version;
    } else {
      titleController.addListener(_dynamicallyUpdateIdentifier);
      versionController.addListener(_dynamicallyUpdateIdentifier);
      widget._model.updateDatasetReleaseDate();
      widget._model.setCurrentAgentAsEditor();
    }
    _refreshAgentContactOptions();
  }

  @override
  Widget build(BuildContext context) {
    String title = _getWindowTitle();
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
              _buildMainDetailsSection(),
              _buildMetadataDetailsSection(),
              _buildDatasetSection(),
              _buildEditorsSection(),
              _buildContactsSection(),
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
            onTap: () => widget._cUpsertDatasetWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(
            child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget._cUpsertDatasetWindow
                .showCataloguesSelected(context, ""),
            child: DoorText(AppLocalizations.of(context)!.cataloguing,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              children: [
                Container(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    border: Border.all(color: DoorColor.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                      child: null == widget._model.dataset.icon
                          ? const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 60,
                            )
                          : Image.memory(widget._model.dataset.icon!)),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: DoorColor.black, width: 2),
                      color: DoorColor.reverse,
                    ),
                    child: DoorSimpleButtonIcon(
                      AppLocalizations.of(context)!.addIcon,
                      Icons.edit,
                      () {
                        widget._cUpsertDatasetWindow.pickIconSelected(context);
                      },
                      enabled: widget._model.isMetadataEditable(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 75),
        Flexible(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
                    child: DoorText(AppLocalizations.of(context)!.schema,
                        DoorTextStyle.center),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorMultiDropdown<XDataSchema>(
                      key: ValueKey('schema-${widget._model.isMetadataEditable()}-${widget._model.isInsert}-${widget._model.isIndependent()}'),
                      enabled: widget._model.isMetadataEditable() && !widget._model.hasItems() && (!widget._model.isIndependent() || widget._model.isInsert), // TODO - disable when dataset has apps?
                      singleSelect: true,
                      items: widget._model.getSchemaOptions(),
                      onSelectionChange: (values) {
                        setState(() {
                          XDataSchema? schema = values.isNotEmpty ? values.first : null;
                          widget._model.dataset.schemaID = schema?.identifier ?? null;

                          widget._model.refreshCreateDefaultApp();

                          _refreshTargetDatasetOptions();
                        });
                      },
                      validator: (value) {
                        if ((value == null || value.isEmpty) && widget._model.isIndependent()) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              if (widget._model.canCreateDefaultApp())
                Row(
                  spacing: 12,
                  children: [
                    SizedBox(width: 80, height: 45),
                    Checkbox(
                      activeColor: DoorColor.darkEmph,
                      value: widget._model.createDefaultApp, 
                      onChanged: (value) {
                        setState(() {
                          widget._model.createDefaultApp = value ?? false;
                        });
                      }),
                    DoorText(AppLocalizations.of(context)!.createDefaultApp, DoorTextStyle.norm)
                  ],
                ),
              Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
                    height: 45,
                    child: Align(
                      alignment: Alignment.center,
                      child: DoorText(
                        "${AppLocalizations.of(context)!.parentCatalog} *",
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorMultiDropdown<String>(
                      key: ValueKey('catalogue--${widget._model.dataset.catalogueID}-${widget._model.agentCatalogsResources.map((i) => i.identifier).join('-')}'),
                      enabled: widget._model.isMetadataEditable(),
                      singleSelect: true,
                      items: widget._model.getCatalogsOptions(context),
                      onSelectionChange: (values) {
                        setState(() {
                          widget._model.dataset.catalogueID = values.isNotEmpty ? values.first : "";
                          print("Values: $values");
                          print("Catalogue changed: ${widget._model.dataset.catalogueID}");
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
                    height: 45,
                    child: Align(
                      alignment: Alignment.center,
                      child: DoorText(
                        AppLocalizations.of(context)!.series,
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorMultiDropdown(
                      key: ValueKey(
                        'series-${widget._model.dataset.seriesID.join('-')}-${widget._model.agentSeriesResources.map((i) => i.identifier).join('-')}',
                      ),
                      items: widget._model.getSeriesOptions(context),
                      onSelectionChange:
                        (values) {
                          setState(() {
                            widget._model.dataset.seriesID = values;
                          });
                        },
                      enabled: widget._model.isMetadataEditable()
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
                    height: 45,
                    child: Align(
                      alignment: Alignment.center,
                      child: DoorText(
                        AppLocalizations.of(context)!.typesField,
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorMultiDropdown<DatasetType>(
                      enabled: widget._model.isMetadataEditable(),
                      items: widget._model.getDatasetTypeOptions(context),
                      onSelectionChange: (values) {
                        setState(() {
                          widget._model.dataset.type = values.map((e) => e.index).toList();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 45,
                    child: Align(
                      alignment: Alignment.center,
                      child: DoorText(
                        "${AppLocalizations.of(context)!.statusField} *",
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorMultiDropdown<DatasetStatus>(
                      key: ValueKey('status-${widget._model.isInsert}-${widget._model.isStatusEditable()}'),
                      enabled: widget._model.isStatusEditable(),
                      singleSelect: true,
                      items: widget._model.getDatasetStatusOptions(context),
                      onSelectionChange: (values) {
                        setState(() {
                          widget._model.dataset.status = values.isNotEmpty
                              ? values.first
                              : DatasetStatus.draft;

                          widget._model.refreshCreateDefaultApp();

                          _refreshTargetDatasetOptions();
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataDetailsSection() {
    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        DoorText(AppLocalizations.of(context)!.metadataLanguage,
                            DoorTextStyle.label),
                        DoorMultiDropdown<String>(
                          singleSelect: true,
                          items: widget._model.getMetadataLanguageOptions(selectedMetadataLanguageCode),
                          controller: _metadataLanguageSelectController,
                          onSelectionChange: (values) {
                            setState(() {
                              selectedMetadataLanguageCode =
                                  values.isNotEmpty ? values.first : null;
                              _updateTitleDescriptionOnLanguageChange();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        const SizedBox(height: 37),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget._model.getDatasetMetadataLanguages().map((lang) {
                            return InputChip(
                              isEnabled: widget._model.isMetadataEditable(),
                              backgroundColor: DoorColor.lightEmph,
                              side: const BorderSide(color: DoorColor.darkEmph),
                              label: Text(lang.toUpperCase()),
                              onPressed: () {
                                    setState(() {
                                      _metadataLanguageSelectController.clearAll();
                                      selectedMetadataLanguageCode = lang;
                                      _metadataLanguageSelectController.selectWhere((e) => e.value == lang);
                                    });
                                  },
                              onDeleted: () {
                                    setState(() {
                                      widget._model.dataset.description.remove(lang);
                                      widget._model.dataset.title.remove(lang);
                                      _updateTitleDescriptionOnLanguageChange();
                                    });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ------------------------------------- TITLE DESCRIPTION VERSION -------------------------------------
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: DoorColor.lightEmph,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText(
                              "${AppLocalizations.of(context)!.titleField} *",
                              DoorTextStyle.label),
                          DoorTextFormField(
                            controller: titleController,
                            enabled: widget._model.isMetadataEditable(),
                            validator: (value) {
                              if (widget._model.isDatasetTitlesEmpty()) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (value!.isNotEmpty &&
                                  value != widget._model.dataset.title[selectedMetadataLanguageCode]) {
                                return AppLocalizations.of(context)!.unsavedChanges;
                              }
                              return null;
                            }
                          )
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
                          DoorText(
                              "${AppLocalizations.of(context)!.identifier} *",
                              DoorTextStyle.label),
                          DoorTextFormField(
                            controller: identifierController,
                            validator: (value) {
                              // final RegExp identifierRegex = RegExp(
                              //     r'^doorce/[a-z0-9_]+/[0-9]+(\.[0-9]+)*$');
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .fieldRequired;
                              }
                              // if (!identifierRegex.hasMatch(value)) {
                              //   return AppLocalizations.of(context)!
                              //       .invalidIdentifier;
                              // }
                              return null;
                            },
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText("${AppLocalizations.of(context)!.version} *",
                              DoorTextStyle.label),
                          DoorTextFormField(
                            hintText: "X.X",
                            enabled: widget._model.isInsert,
                            controller: versionController,
                            onChanged: (value) {
                              widget._model.dataset.version = value;
                              _updateIdentifier();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .fieldRequired;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ------------------------------------- 1st ROW -------------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText("${AppLocalizations.of(context)!.description} *", DoorTextStyle.label),
                          DoorTextFormField(
                            controller: descriptionController,
                            enabled: widget._model.isMetadataEditable(),
                            validator: (value) {
                              if (widget._model.isDatasetDescriptionsEmpty()) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (value!.isNotEmpty &&
                                  value != widget._model.dataset.description[selectedMetadataLanguageCode]) {
                                return AppLocalizations.of(context)!.unsavedChanges;
                              }
                              return null;
                          }, 
                          rows: 2)
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: DoorButtonPlain(AppLocalizations.of(context)!.addLanguage, () {
                    if (selectedMetadataLanguageCode != null &&
                        titleController.text.isNotEmpty && //TODO: account for the situation when user updates existing title/descr with empty strings
                        descriptionController.text.isNotEmpty) {
                      setState(() {
                        widget._model.dataset.title[selectedMetadataLanguageCode!] = titleController.text;
                        widget._model.dataset.description[selectedMetadataLanguageCode!] = descriptionController.text;
                      });
                      _updateIdentifier();
                    }
                  },
                  enabled: widget._model.isMetadataEditable()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatasetSection() {
    DateTime? releaseDate = widget._model.dataset.releaseDate;
    bool badTimeRange = fromDate != null && toDate != null && toDate!.isBefore(fromDate!);

    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.dataset,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        if (widget._model.dataset.status == DatasetStatus.source)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.targetDataset,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    key: Key("target-dataset-dropdown-${widget._model.targetDatasetResources.map((td) => td.identifier).join("-")}"),
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getTargetDatasetOptions(context),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.dataset.targetDatasetID = values.firstOrNull;
                      });
                    },
                  ),
                ],
              ),
            ),
            Flexible(flex: 8, child: Container()),
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
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.documentation,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.dataset.documentation, 
                    onChipAddedOrRemoved: (values) {
                      setState(() {
                        widget._model.dataset.documentation = values;
                      });
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
                  DoorText(AppLocalizations.of(context)!.provenance,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.dataset.provenance,
                    onChipAddedOrRemoved: (values) {
                      setState(() {
                        widget._model.dataset.provenance = values;
                      });
                    },
                  )
                ]
              )
            ),
          ],
        ),
        // ------------------------------ 4th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.versionNotes,
                      DoorTextStyle.label),
                  DoorTextFormField(
                    initialValue: widget._model.dataset.versionNotes ?? "",
                    enabled: widget._model.isMetadataEditable(),
                    onChanged: (value) {
                      setState(() {
                        widget._model.dataset.versionNotes = value;
                      });
                    } )
                ],
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        // ------------------------------ 5th ROW -------------------------------------
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
                  DoorText(AppLocalizations.of(context)!.geographicalCoverage,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.dataset.geographicalCoverage,
                    onChipAddedOrRemoved: (values) {
                      setState(() {
                        widget._model.dataset.geographicalCoverage = values;
                      });
                    },
                  )
                ],
              )
            ),
          ],
        ),
        // ------------------------------ 6th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.frequency,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getFrequencyOptions(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.dataset.frequency = values.firstOrNull;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 38),
            Flexible(
              flex: 1,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoorText(AppLocalizations.of(context)!.releaseDate,
                      DoorTextStyle.label),
                  DoorTextFormField(
                    hintText: null == releaseDate
                          ? "[---]"
                          : _dateToString(releaseDate),
                      enabled: false,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        // ------------------------------ 7th ROW -------------------------------------
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(AppLocalizations.of(context)!.temporalCoverageFrom,
                        DoorTextStyle.label),
                    TextFormField(
                        enabled: widget._model.isMetadataEditable(),
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: fromDate == null
                              ? "dd/mm/yyyy"
                              : _dateToString(fromDate!),
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null && pickedDate != fromDate) {
                            setState(() {
                              fromDate = pickedDate;
                            });
                          }
                        },
                        validator: (values) {
                          if (null != fromDate) {
                            return AppLocalizations.of(context)!.unsavedChanges;
                          }
                          return null;
                        }),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(AppLocalizations.of(context)!.temporalCoverageTo,
                        DoorTextStyle.label),
                    TextFormField(
                        enabled: widget._model.isMetadataEditable(),
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: toDate == null
                              ? "dd/mm/yyyy"
                              : _dateToString(toDate!),
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                          errorText: badTimeRange ? AppLocalizations.of(context)!.dateInvalid : null,
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          setState(() {
                            toDate = pickedDate;
                          });
                        },
                        validator: (values) {
                          if (toDate != null) {
                            return AppLocalizations.of(context)!.unsavedChanges;
                          }
                          return null;
                        }),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 34),
                  DoorSimpleButtonIcon(
                    enabled: widget._model.isMetadataEditable(),
                    AppLocalizations.of(context)!.add,
                    Icons.add_circle_outlined,
                    () {
                      if (fromDate != null && toDate != null && !badTimeRange) {
                        var temporalCoverage = (fromDate!, toDate!);
                        if (!widget._model.dataset.temporalCoverage.contains(temporalCoverage))
                          setState(() {
                            widget._model.dataset.temporalCoverage.add(temporalCoverage);
                            fromDate = null;
                            toDate = null;
                        });
                      }
                    },
                  )
                ],
              ),
              Flexible(
                flex: 8,
                child: Column(
                  children: [
                    const SizedBox(height: 37),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget._model.dataset.temporalCoverage.map((temporalCoverage) {
                        return InputChip(
                          isEnabled: widget._model.isMetadataEditable(),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(color: DoorColor.darkEmph),
                          label: DoorText(
                              "${_dateToString(temporalCoverage.$1)} - ${_dateToString(temporalCoverage.$2)}",
                              DoorTextStyle.norm),
                          onDeleted: () {
                            setState(() {
                              widget._model.dataset.temporalCoverage.remove(temporalCoverage);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ]),
        // ------------------------------ 7th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.accessRights} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<AccessRightTypes>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getAccessRightOptions(context),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.dataset.accessRights = values.firstOrNull?.index ?? 0;
                      });
                    },
                    validator: (values) {
                      if (values == null || values.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    }
                  ),
                ],
              ),
            ),
            Flexible(flex: 8, child: Container()),
          ],
        ),
        // ------------------------------8th ROW---------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.dataLanguage,
                      DoorTextStyle.label),
                  DoorMultiDropdown(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.getLanguageOptions(),
                    onSelectionChange:
                      (values) {
                        setState(() {
                          widget._model.dataset.languages = values;
                        });
                      },
                  ),
                ],
              ),
            ),
            Flexible(flex: 4, child: Container()),
          ],
        ),
        // ----------------------------9th ROW-----------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.keywords,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.dataset.keywords,
                    onChipAddedOrRemoved: (items) {
                      setState(() {
                        widget._model.dataset.keywords = items;
                      });
                    }
                  )
                ],
              )
            ),
          ]
        ),
        // ------------------------------ 10th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.themes,
                      DoorTextStyle.label),
                  DoorMultiDropdown(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.getThemeOptions(),
                    onSelectionChange:
                      (values) {
                        setState(() {
                          widget._model.dataset.themes = values;
                        });
                      },
                  ),
                ],
              ),
            ),
            Flexible(flex: 2, child: Container())
          ],
        ),
        // ------------------------------ 11th ROW -------------------------------------
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
                  DoorText(AppLocalizations.of(context)!.applicableLegislation,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.dataset.applicableLegislation,
                    onChipAddedOrRemoved: (values) {
                      setState(() {
                        widget._model.dataset.applicableLegislation = values;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        // ------------------------------ 12th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.licence,
                      DoorTextStyle.label),
                  DoorMultiDropdown(
                    enabled: widget._model.isMetadataEditable(),
                    items: widget._model.getLicenceOptions(),
                    onSelectionChange:
                      (values) {
                        setState(() {
                          widget._model.dataset.licence = values;
                        });
                      },
                  ),
                ],
              ),
            ),
            Flexible(flex: 2, child: Container())
          ],
        ),
        // ------------------------------ 13th ROW -------------------------------------
        Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.responsiblePerson,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getPeopleOptions(),
                    onSelectionChange: (values) {
                      widget._model.dataset.responsiblePersonID = values.firstOrNull;
                      _refreshAgentContactOptions();
                    },
                    validator: (values) {
                      if (widget._model.areResponsibleAgentsNullOrEmpty() && !widget._model.isUserDataAdmin()) {
                        return AppLocalizations.of(context)!.respAgentNotAssigned;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(
                      AppLocalizations.of(context)!.responsibleOrganization,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getOrganizationsOptions(),
                    onSelectionChange: (values) {
                      widget._model.dataset.responsibleOrganisationID = values.firstOrNull;
                      _refreshAgentContactOptions();
                    },
                    validator: (values) {
                      if (widget._model.areResponsibleAgentsNullOrEmpty() && !widget._model.isUserDataAdmin()) {
                        return AppLocalizations.of(context)!.respAgentNotAssigned;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.contacts} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    key: ValueKey("contact-dropdown-${_contactsSelectKey()}"),
                    items: widget._model
                        .getContactOptions(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.updateContactsOnSelection(values);
                      });
                    },
                    validator: (values) {
                      if (null == values || values.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    );
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
          availableEditors: widget._model.getAvailableAgents(), 
          assignments: widget._model.getRoleAssignments(),
          isAdmin: widget._model.isUserDataAdmin(),
          onEditorsChanged: 
          (values) {
            setState(() {
              widget._model.updateEditorUris(values);
              widget._model.updateRoles(values);
              _refreshAgentContactOptions();
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

  Widget _buildContactsSection() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.newContacts,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.contactName,
                      DoorTextStyle.label),
                  DoorTextFormField(
                    controller: contactNameController,
                    enabled: widget._model.isMetadataEditable(),
                   validator: (values) {
                    if (values!.isNotEmpty) {
                      return AppLocalizations.of(context)!.unsavedChanges;
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
                  DoorText(AppLocalizations.of(context)!.contents,
                      DoorTextStyle.label),
                  DoorTextFormField(
                    controller: contactContentsController,
                      enabled: widget._model.isMetadataEditable(),
                      validator: (values) {
                    if (values!.isNotEmpty) {
                      return AppLocalizations.of(context)!.unsavedChanges;
                    }
                    return null;
                  })
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 34),
                DoorSimpleButtonIcon(
                  enabled: widget._model.isMetadataEditable(),
                  AppLocalizations.of(context)!.add,
                  Icons.add_circle_outlined,
                  () {
                    if (_validateContactFieldsBeforeAdding()) {
                      setState(() {
                        widget._model.addToNewContacts(
                          contactNameController.text,
                          contactContentsController.text,
                        );
                        contactContentsController.clear();
                        contactNameController.clear();
                      });
                    }
                  },
                )
              ],
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
                if (_formKey.currentState!.validate()) {
                  if (widget._model.createDefaultApp) {
                    widget._cUpsertDatasetWindow.insertAndCreateDefaultAppSelected(context);
                  } else {
                    await widget._cUpsertDatasetWindow.saveSelected(context);
                  }
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
                await widget._cUpsertDatasetWindow.cancelSelected(context);
              },
            ),
          ),
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              enabled: widget._model.isMetadataEditable(),
              AppLocalizations.of(context)!.publishMetadata,
              () async {
                if (_formKey.currentState!.validate()) {
                  await widget._cUpsertDatasetWindow.publishMetadataSelected(context);
                } else {
                  SnackMessage().show(context, true,
                      text: AppLocalizations.of(context)!.formError);
                }
              },
            ),
          ),
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              enabled: widget._model.isMetadataEditable() && !widget._model.isIndependent(),
              AppLocalizations.of(context)!.publishData,
              () async {
                if (_formKey.currentState!.validate()) {
                  await widget._cUpsertDatasetWindow.publishDataSelected(context);
                } else {
                  SnackMessage().show(context, true,
                      text: AppLocalizations.of(context)!.formError);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertDatasetWindowFactory {
  const VUpsertDatasetWindowFactory();
  VUpsertDatasetWindow get(key, model) {
    return VUpsertDatasetWindow(key, new CUpsertDatasetWindow(model), model);
  }
}
