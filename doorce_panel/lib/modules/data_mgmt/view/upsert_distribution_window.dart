import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/text_add.dart';
import 'package:doorce_panel/common/view_elements/text_chips.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/controllers/c_upsert_distribution_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_upsert_distribution_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class VUpsertDistributionWindow extends StatefulWidget {
  final CUpsertDistributionWindow _cUpsertDistributionWindow;
  final MUpsertDistributionWindow _model;
  const VUpsertDistributionWindow(GlobalKey? key, this._cUpsertDistributionWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertDistributionWindow> createState() =>
      VUpsertDistributionWindowState();
}

class VUpsertDistributionWindowState extends State<VUpsertDistributionWindow> {
  final _formKey = GlobalKey<FormState>();

  String? selectedMetadataLanguageCode = "en";

  // Text Fields Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController accessUrlController = TextEditingController();

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
    identifierController.dispose();
    descriptionController.dispose();
    accessUrlController.dispose();
    _metadataLanguageSelectController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  void _dynamicallyUpdateIdentifier() {
    if (widget._model.isDistributionTitlesEmpty()) {
      _updateIdentifier();
    }
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert){
        identifierController.text = model.createDistributionIdentifier(titleController.text);
        widget._model.distribution.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  void updateTitleDescriptionOnLanguageChange() {
    setState(() {
      titleController.text =
          widget._model.distribution.title[selectedMetadataLanguageCode] ?? "";
      descriptionController.text =
          widget._model.distribution.description[selectedMetadataLanguageCode] ?? "";
    });
  }

  String _dateToString(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year.toString()}";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      titleController.text = widget._model.distribution.title[selectedMetadataLanguageCode] ?? "";
      descriptionController.text = widget._model.distribution.description[selectedMetadataLanguageCode] ?? "";
      identifierController.text = widget._model.distribution.identifier;
      
    } else {
      titleController.addListener(_dynamicallyUpdateIdentifier);
      widget._model.updateDistributionReleaseDate();
      widget._model.distribution.datasetUri = widget._model.dataset.identifier;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.addDistribution :
                                                AppLocalizations.of(context)!.editDistribution;
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
              _buildDistributionDetailsSection(),
              _buildDistributionSection(),
              _buildDataSection(),
              _buildFooterButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainDetailsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        // Icona
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
                    child: null == widget._model.distribution.icon ?
                      Image.asset("images/distribution.png") :
                      Image.memory(widget._model.distribution.icon!)
                  ),
                ),
              ],
            ),
          ),
        ),
        // Colonna con due righe
        Flexible(
          flex: 8,
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Prima riga: Dataset e Schema
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        DoorText("${AppLocalizations.of(context)!.dataset} *",
                            DoorTextStyle.label),
                        DoorMultiDropdown<String>(
                          singleSelect: true,
                          items: widget._model.getDatasetOptions(context),
                          onSelectionChange: (values) {
                            setState(() {
                              widget._model.distribution.datasetUri = values.isNotEmpty ? values.first : "";
                            });
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
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        DoorText(AppLocalizations.of(context)!.schema,
                            DoorTextStyle.label),
                        DoorMultiDropdown<XDataSchema>(
                          singleSelect: true,
                          items: widget._model.getSchemaOptions(),
                          onSelectionChange: (values) {
                            setState(() {
                              widget._model.distribution.schemaUri =
                                  values.firstOrNull?.identifier;
                              widget._model.distribution.schemaTitle =
                                  values.firstOrNull?.title;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Seconda riga: DatasetServices e Status
              Row(
                spacing: 8,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        DoorText(AppLocalizations.of(context)!.datasetServices,
                            DoorTextStyle.label),
                        DoorMultiDropdown<String>(
                          singleSelect: true,
                          items: widget._model.getServicesOptions(context),
                          onSelectionChange: (values) {
                            setState(() {
                              widget._model.distribution.dataServiceUri =
                                  values.firstOrNull;
                            });
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
                        DoorText(AppLocalizations.of(context)!.status,
                            DoorTextStyle.label),
                        DoorMultiDropdown<String>(
                          singleSelect: true,
                          items: widget._model.getMaturityStatusOptions(),
                          onSelectionChange: (values) {
                            setState(() {
                              widget._model.distribution.status =
                                  values.firstOrNull;
                            });
                          },
                        ),
                      ],
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

  Widget _buildBreadcrumb(String title) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                widget._cUpsertDistributionWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget._cUpsertDistributionWindow
                .dataManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.dataManagement,
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
            onTap: () => widget._cUpsertDistributionWindow.openDatasetContent(
                context, widget._model.dataset.identifier),
            child: DoorText(widget._model.getDatasetTitle(context),
                DoorTextStyle.breadcrumbActive),
          )),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(title, DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildDistributionDetailsSection() {
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
                              selectedMetadataLanguageCode = values.firstOrNull;
                              updateTitleDescriptionOnLanguageChange();
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
                          children: widget._model.distribution.title.keys.map((lang) {
                            return InputChip(
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
                                      widget._model.distribution.description.remove(lang);
                                      widget._model.distribution.title.remove(lang);
                                      updateTitleDescriptionOnLanguageChange();
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
                            validator: (value) {
                              if (widget._model.isDistributionTitlesEmpty()) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (value!.isNotEmpty && value != widget._model.distribution.title[selectedMetadataLanguageCode]) {
                                return AppLocalizations.of(context)!.unsavedChanges;
                              }
                              return null;
                            },
                          ),
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
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .fieldRequired;
                              }
                              return null;
                            },
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
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
                          DoorText(
                              "${AppLocalizations.of(context)!.description} *",
                              DoorTextStyle.label),
                          DoorTextFormField(
                            controller: descriptionController,
                            validator: (value) {
                              if (widget._model.isDistributionDescriptionsEmpty()) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (value!.isNotEmpty &&
                                  value != widget._model.distribution.description[selectedMetadataLanguageCode]) {
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
                  child: DoorButtonPlain(
                      AppLocalizations.of(context)!.addLanguage, () {
                    if (selectedMetadataLanguageCode != null &&
                        titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      setState(() {
                        widget._model.distribution.title[selectedMetadataLanguageCode!] =
                            titleController.text;
                        widget._model.distribution.description[selectedMetadataLanguageCode!] =
                            descriptionController.text;
                      });
                      _updateIdentifier();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionSection() {
    DateTime? releaseDate = widget._model.distribution.releaseDate;
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText('${AppLocalizations.of(context)!.accessStatus} *',
                      DoorTextStyle.label),
                  DoorMultiDropdown<AccessRightTypes>(
                    singleSelect: true,
                    items: widget._model.getAccessRightOptions(context),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.distribution.accessStatus = values.firstOrNull?.index ?? 0;
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
            Flexible(flex:1, child: SizedBox(width: 20)),
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
          ],
        ),
        // ------------------------------8th ROW---------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.distributionLanguages,
                      DoorTextStyle.label),
                  DoorMultiDropdown(
                    items: widget._model.getLanguageOptions(),
                    onSelectionChange: 
                      (values) {
                        setState(() {
                          widget._model.distribution.languages = values;
                        });
                      },
                  ),
                ],
              ),
            ),
            Flexible(flex: 6, child: Container()),
          ],
        ),
        // ------------------------------ 12th ROW -------------------------------------
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        if (widget._model.hasFile())
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 7,
              child: Column(
                children:[ 
                    InputChip(
                        backgroundColor: DoorColor.lightEmph,
                        side: const BorderSide(color: DoorColor.darkEmph),
                        label: DoorText(widget._model.getDataSelectionLabel(context)!, DoorTextStyle.norm),
                        onDeleted: () {
                          setState(() {
                            widget._model.removeFile();
                          });
                        },
                      ),
                    ]
                    ),
                  ),
                ],
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 100,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.file, DoorTextStyle.label), 
                  DoorButtonLoading(
                    AppLocalizations.of(context)!.selectFile,
                    () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true,);
                      
                      if (null != result){
                        setState(() {
                          widget._model.setFileSelected(result);
                          },
                        );
                    };
                  },
                  enabled: !widget._model.hasFile(),
                )
                ],
              )
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  DoorText(AppLocalizations.of(context)!.byteSize,
                      DoorTextStyle.label),
                  Text(widget._model.distribution.byteSize.toString()),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  DoorText(AppLocalizations.of(context)!.downloadUrl,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithAddButton(
                    enabled: !widget._model.hasFile(),
                    items: widget._model.distribution.downloadUrl != null ? [widget._model.distribution.downloadUrl!] : [],
                    singleAdd: true,
                    onAdded: (newList) {
                      setState(() {
                        widget._model.distribution.downloadUrl = newList.firstOrNull;
                      });
                    },
                  )
                ],
              ),
            ),
          ]
        ),
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
                  DoorText(AppLocalizations.of(context)!.accessUrl,
                      DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    items: widget._model.distribution.accessUrl,
                    onChipAddedOrRemoved: (items) {
                      setState(() {
                        widget._model.distribution.accessUrl = items;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  DoorText('${AppLocalizations.of(context)!.mediaType}',
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    singleSelect: true,
                    items: widget._model.getMediaType(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.distribution.mediaType =
                            values.firstOrNull;
                      });
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
                  DoorText(AppLocalizations.of(context)!.formats,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    singleSelect: true,
                    items: widget._model.getFormatOptions(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.distribution.format =
                            values.firstOrNull;
                      });
                    },
                  ),
                ],
              ),
            ),
            Flexible(flex: 1, child: SizedBox(width: 20))
          ],
        )
      ]
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
              AppLocalizations.of(context)!.save,
              () async {
                if (_formKey.currentState!.validate()) {
                  await widget._cUpsertDistributionWindow.saveSelected(context);
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
                await widget._cUpsertDistributionWindow.cancelSelected(context);
              },
            ),
          ),
          /*SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonPlain(
              AppLocalizations.of(context)!.publish,
              () {
                if (_formKey.currentState!.validate()) {}
              },
            ),
          ),*/
        ],
      ),
    );
  }
}

class VUpsertDistributionWindowFactory {
  const VUpsertDistributionWindowFactory();
  VUpsertDistributionWindow get(key,model) {
    return VUpsertDistributionWindow(key, new CUpsertDistributionWindow(model), model);
  }
}
