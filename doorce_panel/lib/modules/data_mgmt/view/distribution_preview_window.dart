import 'dart:typed_data';

import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/data_mgmt/view/controllers/c_distribution_preview_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_distribution_preview_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';

class VDistributionPreviewWindow extends StatefulWidget {
  final CDistributionPreviewWindow _cDistributionContentWindow;
  final MDistributionPreviewWindow _model;
  const VDistributionPreviewWindow(GlobalKey? key, this._cDistributionContentWindow, this._model)
      : super(key: key);

  @override
  State<VDistributionPreviewWindow> createState() =>
      VDistributionPreviewWindowState();
}

class VDistributionPreviewWindowState
    extends State<VDistributionPreviewWindow> {
  String? selectedMetadataLanguageCode = "en";
  Uint8List? fileContent;

  @override
  void initState() {
    super.initState();
    fileContent = widget._model.getDistributionFileContent() ?? null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            DoorText(AppLocalizations.of(context)!.openDistribution,
                DoorTextStyle.titleBlack),
            _buildMainDetailsSection(),
            _buildMetadataDetailsSection(),
            const Divider(),
            _buildOtherDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {

    Widget parentResource = widget._model.pathFromMetadataMgmt 
      ? GestureDetector(
        onTap: () =>
            widget._cDistributionContentWindow.openServiceContent(context),
        child: DoorText(widget._model.getServiceTitle(context),
            DoorTextStyle.breadcrumbActive),)
      : GestureDetector(
            onTap: () => widget._cDistributionContentWindow.openDatasetContent(context),
            child: DoorText(widget._model.getDatasetTitle(context),
                DoorTextStyle.breadcrumbActive),
          );

    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                widget._cDistributionContentWindow.homeSelected(context),
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
            onTap: () => widget._cDistributionContentWindow
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
          child: parentResource),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(widget._model.getDistributionTitle(context),
            DoorTextStyle.breadcrumb)),
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
                    child: null == widget._model.getDistributionIcon() ?
                      Image.asset("images/distribution.png") :
                      Image.memory(widget._model.getDistributionIcon()!)
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
                    child: DoorText(widget._model.getDistributionSchema() ?? "",
                        DoorTextStyle.norm),
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
                    child: DoorText(
                        widget._model.getDistributionMaturityStatus() ?? "",
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
                          children: [Flexible(child:
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
                            widget._model.getDistributionTitleByCodeLanguage(
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
                            widget._model.getDistributionIdentifier(),
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
                            widget._model
                                .getDistibutionDescriptionByCodeLanguage(
                                    context,
                                    selectedMetadataLanguageCode ?? "en"),
                            DoorTextStyle.norm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText(AppLocalizations.of(context)!.datasetTitle,
                              DoorTextStyle.label),
                          DoorText(
                            widget._model.getDatasetTitleByCodeLanguage(
                                context, selectedMetadataLanguageCode ?? "en"),
                            DoorTextStyle.norm,
                          ),
                        ],
                      ),
                    ),
                    Flexible(flex: 2, child: Container()),
                    Flexible(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText(AppLocalizations.of(context)!.dataServiceTitle,
                              DoorTextStyle.label),
                          DoorText(
                            widget._model.getServiceTitleByCodeLanguage(
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
        spacing: 20,
        children: [
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoorText(
                AppLocalizations.of(context)!.distribution,
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
                    DoorText(AppLocalizations.of(context)!.accessUrl,
                        DoorTextStyle.label),
                    ...widget._model.getDistributionAccessUrls().map((url) {
                      return InkWell(
                        onTap: () => launchUrl(
                          Uri.parse(url),
                          webOnlyWindowName: '_blank',
                        ),
                        child: DoorText(
                          url,
                          DoorTextStyle.hyperlink,
                        )
                      );
                    }),
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
                      DoorText(AppLocalizations.of(context)!.file,
                          DoorTextStyle.label),
                      DoorText(widget._model.getDistributionFileName() ?? "",
                          DoorTextStyle.norm),
                    ]
                  )),
                  if (null != fileContent)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        DoorSimpleButtonIcon(
                          AppLocalizations.of(context)!.download,
                          Icons.download,
                          () async {
                                String? fileName = widget._model.getDistributionFileName();
                                await FilePicker.platform.saveFile(fileName: fileName, bytes: fileContent);  
                              }
                        )
                      ]
                    ),
                  Flexible(flex: 1, child: Container()),
                  Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.downloadUrl,
                        DoorTextStyle.label),
                    InkWell(
                        onTap: () => launchUrl(
                          Uri.parse(widget._model.getDistributionDownloadUrl()),
                          webOnlyWindowName: '_blank',
                        ),
                        child: DoorText(
                          widget._model.getDistributionDownloadUrl(),
                          DoorTextStyle.hyperlink,
                        )
                      ),
                    ],
                  ),
                ),
              ]
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 5,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.formats,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDistributionFormat() ?? "",
                        DoorTextStyle.norm),
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
                    DoorText(AppLocalizations.of(context)!.mediaType,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDistributionMediaType() ?? "",
                        DoorTextStyle.norm),
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
                    DoorText(AppLocalizations.of(context)!.byteSize,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDistributionByteSize(),
                        DoorTextStyle.norm),
                  ],
                ),
              ),
              Flexible(flex: 2, child: Container()),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 8,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    DoorText(AppLocalizations.of(context)!.releaseDate,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDistributionReleaseDate() ?? "",
                        DoorTextStyle.norm),
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
                    DoorText(AppLocalizations.of(context)!.accessRights,
                        DoorTextStyle.label),
                    DoorText(widget._model.getDistributionAccessRights(context),
                        DoorTextStyle.norm),
                  ],
                ),
              ),
              Flexible(flex: 5, child: Container()),
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
                      children: widget._model
                          .getDistributionLanguages()
                          .map((language) {
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
        ]
      )
    );
  }
}

class VDistributionPreviewWindowFactory {
  const VDistributionPreviewWindowFactory();
  VDistributionPreviewWindow get(key, model) =>
      VDistributionPreviewWindow(key, new CDistributionPreviewWindow(model), model);
}