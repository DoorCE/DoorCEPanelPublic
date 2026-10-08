import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/data_mgmt/view/controllers/c_series_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_series_content_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class VSeriesContentWindow extends StatefulWidget {
  final CSeriesContentWindow _cSeriesContentWindow;
  final MSeriesContentWindow _model;
  const VSeriesContentWindow(GlobalKey? key, this._cSeriesContentWindow, this._model)
      : super(key: key);

  @override
  State<VSeriesContentWindow> createState() => VSeriesContentWindowState();
}

class VSeriesContentWindowState extends State<VSeriesContentWindow> {
  String? selectedMetadataLanguageCode = "en";

  void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
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
            DoorText(AppLocalizations.of(context)!.openSeries,
                DoorTextStyle.titleBlack),
            _buildMainDetailsSection(),
            _buildMetadataDetailsSection(),
            const Divider(),
            _buildOtherDetailsSection(),
            const Divider(),
            _buildContactSection(context),
            const Divider(),
            _buildDatasetSection(),
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
            onTap: () => widget._cSeriesContentWindow.homeSelected(context),
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
                widget._cSeriesContentWindow.dataManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.dataManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(
            widget._model.getSeriesTitle(context), DoorTextStyle.breadcrumb)),
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
                    child: null == widget._model.getSeriesIcon() ?
                      const Icon(Icons.add_photo_alternate_outlined, size: 60,) :
                      Image.memory(widget._model.getSeriesIcon()!),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 75),
        Flexible(
          flex:3,
          child:Row(
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
                      widget._model.getSeriesCatalog(context),
                      DoorTextStyle.norm,
                    ),
                  ),
                ],
              )),
      ],
    );
  }

  Widget _buildMetadataDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                            widget._model.getSeriesTitleByCodeLanguage(
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
                            widget._model.getSeriesIdentifier(),
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
                            widget._model.getSeriesDescriptionByCodeLanguage(
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
    ));
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
                AppLocalizations.of(context)!.series,
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
                    DoorText(AppLocalizations.of(context)!.geographicalCoverage,
                        DoorTextStyle.label),
                    DoorText(
                      widget._model.getSeriesGeographicalCoverage().join(' | '),
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
                    DoorText(widget._model.getSeriesFrequency() ?? "",
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
                    DoorText(widget._model.getSeriesReleaseDate() ?? "",
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
                    DoorText(widget._model.getSeriesAccessRights(context),
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
                        .getSeriesTemporalCoverage()
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
                          widget._model.getSeriesLanguages().map((language) {
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
                          widget._model.getSeriesKeywords().map((keyword) {
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
                      children: widget._model.getSeriesThemes().map((theme) {
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
                          .getSeriesApplicableLegislations()
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
                      children: widget._model.getSeriesLicences().map((theme) {
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
                      widget._model.getSeriesRespPerson() ?? "",
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
                      widget._model.getSeriesRespOrganization() ?? "",
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
                      children: widget._model.getSeriesEditors().map((editor) {
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

  Widget _buildDatasetSection() {
    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DoorText(
              AppLocalizations.of(context)!.datasets,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.addNewDataset,
                Icons.add_circle_outlined,
                () => widget._cSeriesContentWindow.upsertDatasetSelected(
                    context, "")),
            DoorText(
              AppLocalizations.of(context)!.addNewDataset,
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
              widget._model.getDatasetListLenght(),
              (index) {
                final dataset =
                    widget._model.getDatasetResource(index);
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        dataset.identifier,
                        DoorTextStyle.norm,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        widget._model.getDatasetTitle(context, index),
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
                            AppLocalizations.of(context)!.openDataset,
                            Icons.visibility,
                            () {
                              widget._cSeriesContentWindow
                                  .datasetContentSelected(
                                      context, dataset.identifier);
                            },
                          )),
                          Flexible(child: DoorSimpleButtonIcon(
                            AppLocalizations.of(context)!.editDataset,
                            Icons.edit,
                            () {
                              widget._cSeriesContentWindow
                                  .upsertDatasetSelected(
                                      context,
                                      dataset.identifier);
                            },
                            enabled: widget._model.isDatasetEditable(dataset),
                          )),
                          Flexible(child: DoorSimpleButtonIcon(
                            AppLocalizations.of(context)!.deleteDataset,
                            Icons.delete,
                            () {
                              widget._cSeriesContentWindow.deleteDatasetSelected(context, dataset.identifier);
                            },
                            enabled: widget._model.isDatasetDeletable(dataset),
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

class VSeriesContentWindowFactory {
  const VSeriesContentWindowFactory();
  VSeriesContentWindow get(key, model) {
    return VSeriesContentWindow(key, new CSeriesContentWindow(model), model);
  }
}
