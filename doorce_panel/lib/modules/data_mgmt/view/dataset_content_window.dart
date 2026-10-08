import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/concept_summary.dart';
import 'package:doorce_panel/common/view_elements/errors_widget.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/text_add.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/controllers/c_dataset_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_dataset_content_widow.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class VDatasetContentWindow extends StatefulWidget {
  final CDatasetContentWindow _cDatasetContentWindow;
  final MDatasetContentWindow _model;
  const VDatasetContentWindow(GlobalKey? key, this._cDatasetContentWindow, this._model)
      : super(key: key);

  @override
  State<VDatasetContentWindow> createState() => VDatasetContentWindowState();
}

class VDatasetContentWindowState extends State<VDatasetContentWindow> {
  String? selectedMetadataLanguageCode = "en";

  void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  dynamic pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true,);
    if (result == null || result.files.isEmpty) {
      // user cancelled or nothing selected
      return;
    }

    if (result.files.first.bytes == null) {
      SnackMessage().show(context, true, text: AppLocalizations.of(context)!.couldNotReadFile);
      return;
    }
                      
    setState(() {
      widget._model.setFileSelected(result);
      },
    );
  }

  Widget _buildViewAppButton(BuildContext context) {
    ViewAppButtonState? viewAppButtonState = widget._model.getViewAppButtonState();
    switch (viewAppButtonState) {
      case ViewAppButtonState.defaultApp:
        return SizedBox(
          width: 280,
          height: 48,
          child: DoorButtonPlain(
            AppLocalizations.of(context)!.viewAndEditWithDefaultApp,
            () {
              widget._cDatasetContentWindow.viewDefaultApp(context);
            },
          enabled: widget._model.isViewAppButtonEnabled(),
          )
        );
      case ViewAppButtonState.selectedApp:
        return SizedBox(
          width: 280,
          height: 48,
          child: DoorButtonPlain(
            AppLocalizations.of(context)!.viewWithSelectedApp,
            () {
              widget._cDatasetContentWindow.viewAppSelected(context);
            },
          enabled: widget._model.isViewAppButtonEnabled(),
          )
        );
      case ViewAppButtonState.split:
        return DoorSplitButton<String>(
          width: 280,
          height: 48,
          items: [AppLocalizations.of(context)!.viewWithSelectedApp], 
          mainValue: AppLocalizations.of(context)!.viewAndEditWithDefaultApp, 
          onPressed: () async {
            Logger.root.info("[VDatasetContentWindow DoorSplitButton] main button was pressed, calling _cDatasetContentWindow.viewDefaultApp...");
            await widget._cDatasetContentWindow.viewDefaultApp(context);
          },
          onItemSelected: (value) async {
            Logger.root.info("[VDatasetContentWindow DoorSplitButton] dropdown item was selected, calling _cDatasetContentWindow.viewAppSelected...");
            await widget._cDatasetContentWindow.viewAppSelected(context);
          },
          enabled: widget._model.isViewAppButtonEnabled(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumb(context),
            DoorText(AppLocalizations.of(context)!.openDataset,
                DoorTextStyle.titleBlack),
            _buildMainDetailsSection(),
            _buildMetadataDetailsSection(),
            const Divider(),
            _buildOtherDetailsSection(),
            const Divider(),
            _buildContactSection(context),
            const Divider(),
            _buildDataSection(),
            const Divider(),
            _buildDistrbutionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget._cDatasetContentWindow.homeSelected(context),
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
            onTap: () =>
                widget._cDatasetContentWindow.dataManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.dataManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(
            widget._model.getDatasetTitle(context), DoorTextStyle.breadcrumb)),
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
                    child: null == widget._model.getDatasetIcon() ?
                      const Icon(Icons.add_photo_alternate_outlined, size: 60,) :
                      Image.memory(widget._model.getDatasetIcon()!),
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
            spacing: 25,
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
                    child: DoorText(
                        widget._model.getDatasetSchema() ?? "", DoorTextStyle.norm),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
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
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget._model
                          .getDatasetSeries(context)
                          .map((title) => Chip(
                                label: DoorText(
                                  title,
                                  DoorTextStyle.norm,
                                ),
                                backgroundColor: DoorColor.lightEmph,
                                side: const BorderSide(
                                  color: DoorColor.darkEmph,
                                  width: 1,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: DoorText(
                        AppLocalizations.of(context)!.catalog,
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorText(
                      widget._model.getDatasetCatalog(context),
                      DoorTextStyle.norm,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  SizedBox(
                    width: 80,
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
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget._model
                          .getDatasetTypes(context)
                          .map((type) => Chip(
                                label: DoorText(
                                  type,
                                  DoorTextStyle.norm,
                                ),
                                backgroundColor: DoorColor.lightEmph,
                                side: const BorderSide(
                                  color: DoorColor.darkEmph,
                                  width: 1,
                                ),
                              ))
                          .toList(),
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
                    child: Align(
                      alignment: Alignment.center,
                      child: DoorText(
                        AppLocalizations.of(context)!.statusField,
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: DoorText(widget._model.getDatasetStatus(context),
                        DoorTextStyle.norm),
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
                        MultiDropdown<String>(
                          singleSelect: true,
                          items: widget._model.getLanguageOptions(selectedMetadataLanguageCode),
                          onSelectionChange: (values) {
                            setState(() {
                              selectedMetadataLanguageCode =
                                  values.isNotEmpty ? values.first : null;
                            });
                          },
                          dropdownItemDecoration: const DropdownItemDecoration(
                            selectedIcon:
                                Icon(Icons.check_box, color: Colors.green),
                          ),
                          fieldDecoration: FieldDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(flex: 7, child: Container()),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 8,
                          children: [
                            Flexible(child:
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: DoorText(
                                selectedMetadataLanguageCode?.toUpperCase() ??
                                    "EN",
                                DoorTextStyle.label,
                              ),
                            ),)
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          DoorText(AppLocalizations.of(context)!.titleField,
                              DoorTextStyle.label),
                          DoorText(
                            widget._model.getDatasetTitleByCodeLanguage(
                                context, selectedMetadataLanguageCode ?? "en"),
                            DoorTextStyle.norm,
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
                          DoorText(AppLocalizations.of(context)!.identifier,
                              DoorTextStyle.label),
                          DoorText(
                            widget._model.getDatasetIdentifier(),
                            DoorTextStyle.norm,
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
                          DoorText(AppLocalizations.of(context)!.version,
                              DoorTextStyle.label),
                          DoorText(
                            widget._model.getDatasetVersion(),
                            DoorTextStyle.norm,
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
                          DoorText(AppLocalizations.of(context)!.description,
                              DoorTextStyle.label),
                          DoorText(
                            widget._model.getDatasetDescriptionByCodeLanguage(
                                context, selectedMetadataLanguageCode ?? "en"),
                            DoorTextStyle.norm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                    DoorText(AppLocalizations.of(context)!.documentation,
                        DoorTextStyle.label),
                    DoorText(
                      widget._model.getDatasetDocumentation().join(' | '),
                      DoorTextStyle.norm,
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.provenance,
                        DoorTextStyle.label),
                    DoorText(
                      widget._model.getDatasetProvenance().join(' | '),
                      DoorTextStyle.norm,
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.versionNotes,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDatasetVersionNotes() ?? "",
                        DoorTextStyle.norm),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.geographicalCoverage,
                        DoorTextStyle.label),
                    DoorText(
                      widget._model.getDatasetGeographicalCoverage().join(' | '),
                      DoorTextStyle.norm,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.frequency,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDatasetFrequency() ?? "",
                        DoorTextStyle.norm),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.releaseDate,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDataseReleaseDate() ?? "",
                        DoorTextStyle.norm),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.accessRights,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDatasetAccessRights(context),
                        DoorTextStyle.norm),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.temporalCoverage,
                        DoorTextStyle.label),
                    ...widget._model
                        .getDatasetTemporalCoverage()
                        .map((coverage) {
                      return DoorText(
                        coverage,
                        DoorTextStyle.norm,
                      );
                    }),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.dataLanguage,
                        DoorTextStyle.label),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget._model.getDatasetLanguages().map((language) {
                        return Chip(
                          label: DoorText(
                            language,
                            DoorTextStyle.norm,
                          ),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(
                            color: DoorColor.darkEmph,
                            width: 1,
                          ),
                        );
                      }).toList(),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.keywords,
                        DoorTextStyle.label),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget._model.getDatasetKeywords().map((keyword) {
                        return Chip(
                          label: DoorText(
                            keyword,
                            DoorTextStyle.norm,
                          ),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(
                            color: DoorColor.darkEmph,
                            width: 1,
                          ),
                        );
                      }).toList(),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.themes,
                        DoorTextStyle.label),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget._model.getDatasetThemes().map((theme) {
                        return Chip(
                          label: DoorText(
                            theme,
                            DoorTextStyle.norm,
                          ),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(
                            color: DoorColor.darkEmph,
                            width: 1,
                          ),
                        );
                      }).toList(),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(
                        AppLocalizations.of(context)!.applicableLegislation,
                        DoorTextStyle.label),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget._model
                          .getDatasetApplicableLegislations()
                          .map((theme) {
                        return Chip(
                          label: DoorText(
                            theme,
                            DoorTextStyle.norm,
                          ),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(
                            color: DoorColor.darkEmph,
                            width: 1,
                          ),
                        );
                      }).toList(),
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
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.licence,
                        DoorTextStyle.label),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget._model.getDatasetLicences().map((theme) {
                        return Chip(
                          label: DoorText(
                            theme,
                            DoorTextStyle.norm,
                          ),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(
                            color: DoorColor.darkEmph,
                            width: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.responsiblePerson,
                        DoorTextStyle.label),
                    DoorText(
                      widget._model.getDatasetRespPerson() ?? "",
                      DoorTextStyle.norm,
                    ),
                  ],
                ),
              ),
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(
                        AppLocalizations.of(context)!.responsibleOrganization,
                        DoorTextStyle.label),
                    DoorText(
                      widget._model.getDatasetRespOrganization() ?? "",
                      DoorTextStyle.norm,
                    ),
                  ],
                ),
              ),
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.editors,
                        DoorTextStyle.label),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget._model.getDatasetEditors().map((editor) {
                        return Chip(
                          label: DoorText(
                            editor,
                            DoorTextStyle.norm,
                          ),
                          backgroundColor: DoorColor.lightEmph,
                          side: const BorderSide(
                            color: DoorColor.darkEmph,
                            width: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            DoorText(AppLocalizations.of(context)!.contacts,
                DoorTextStyle.titleBlack),
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(3),
          },
          border: TableBorder.all(color: DoorColor.darkEmph, width: 1),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: DoorColor.lightEmph),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.agent,
                    DoorTextStyle.label,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.contactName,
                    DoorTextStyle.label,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.contacts,
                    DoorTextStyle.label,
                  ),
                ),
              ],
            ),
            ...List.generate(
              widget._model.getContactDataListLenght(),
              (index) {
                final contactData =
                    widget._model.getContactDataResource(index);
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        contactData.agentName ?? "[---]",
                        DoorTextStyle.norm,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        contactData.name,
                        DoorTextStyle.norm,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        contactData.contents,
                        DoorTextStyle.norm,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DoorText(
              AppLocalizations.of(context)!.structuredData,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.clearData,
                Icons.delete,
                () async {
                  await widget._cDatasetContentWindow.clearData(context);
                },
                enabled: widget._model.canUserClearDataItems()),
            //const SizedBox(width: 8),
          ],
        ),
        if (widget._model.conceptSummaries.isNotEmpty)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: ConceptSummaryWidget(summaries: widget._model.conceptSummaries)),
        ],),
        SizedBox(height: 12),
        if (widget._model.hasFileToLoad())
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 7,
              child: Column(
                children:[ 
                  Row(
                    children: [
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
                      ],),
                      SizedBox(height: 8),
                      if (widget._model.isFileError())
                        DataFileErrorsWidget(key: Key(widget._model.fileErrorString),
                          errorString: widget._model.fileErrorString),
                        SizedBox(height: 8),
                      Row(children: [
                          DoorButtonPlain(AppLocalizations.of(context)!.loadData,
                        () async {
                            await widget._cDatasetContentWindow.loadData(context);
                            setState(() {
                            });
                        })
                        ],)
                      ]
                    ),
                  ),
                ],
              ),
        if (widget._model.dataset.schemaID != null && widget._model.dataset.schemaID!.isNotEmpty)
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
                    pickFile,
                  enabled: !widget._model.hasFileToLoad() && widget._model.canUploadData(),
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
                  Text(widget._model.fileData?.byteSize.toString() ?? "-"),
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
                    enabled: !widget._model.hasFileToLoad() && widget._model.canUploadData(),
                    items: widget._model.fileData?.downloadUrl != null ? [widget._model.fileData!.downloadUrl!] : [],
                    singleAdd: true,
                    onAdded: (newList) {
                      setState(() {
                        widget._model.setFileFromUrl(newList.first);
                      });
                    },
                  )
                ],
              ),
            ),
            if (widget._model.areAppsAvailable())
            Flexible(
              flex: 2,
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    SizedBox(height: 48),
                    _buildViewAppButton(context)
                  ]
                )
            )
          ]
        ),
      ],
    );
  }

  Widget _buildDistrbutionSection() {
    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DoorText(
              AppLocalizations.of(context)!.distribution,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.addDistribution,
                Icons.add_circle_outlined,
                () => widget._cDatasetContentWindow.upsertDistributionSelected(
                    context, null),
                enabled: widget._model.canUserCreateDistributions()),
            DoorText(
              AppLocalizations.of(context)!.addDistribution,
              DoorTextStyle.norm,
            ),
            const SizedBox(width: 8),
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(2),
          },
          border: TableBorder.all(color: DoorColor.darkEmph, width: 1),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: DoorColor.lightEmph),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.identifier,
                    DoorTextStyle.label,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.titleField,
                    DoorTextStyle.label,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.actions,
                    DoorTextStyle.label,
                  ),
                ),
              ],
            ),
            ...List.generate(
              widget._model.getDistributionListLenght(),
              (index) {
                final distribution =
                    widget._model.getDistributionResource(index);
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        distribution.identifier,
                        DoorTextStyle.norm,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        widget._model.getDistributionTitle(context, index),
                        DoorTextStyle.norm,
                      ),
                    ),
                    // Colonna Azioni
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: DoorSimpleButtonIcon(
                            AppLocalizations.of(context)!.openDistribution,
                            Icons.visibility,
                            () {
                              widget._cDatasetContentWindow
                                  .distributionContentSelected(
                                      context, distribution.identifier);
                            },
                          )),
                          Flexible(child: DoorSimpleButtonIcon(
                            AppLocalizations.of(context)!.editDistribution,
                            Icons.edit,
                            () {
                              widget._cDatasetContentWindow
                                  .upsertDistributionSelected(
                                      context,
                                      distribution.identifier,);
                            },
                            enabled: widget._model.isDistributionEditable(index),
                          )),
                          Flexible(child: DoorSimpleButtonIcon(
                            AppLocalizations.of(context)!.deleteDistribution,
                            Icons.delete,
                            () {
                              widget._cDatasetContentWindow.deleteDistributionSelected(context, distribution.identifier);
                            },
                            enabled: widget._model.isDistributionEditable(index),
                          )),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class VDatasetContentWindowFactory {
  const VDatasetContentWindowFactory();
  VDatasetContentWindow get(key, model) {
    return VDatasetContentWindow(key, new CDatasetContentWindow(model), model);
  }
}
