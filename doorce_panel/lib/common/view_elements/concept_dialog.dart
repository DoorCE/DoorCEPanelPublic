import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/data_upload_request.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

Future<XDataUploadRequest?> showConceptDialog({
  required BuildContext context,
  required List<XConcept> concepts,
  Map<String, String>? conceptUriToTableNameMap,
  Map<String, String>? conceptUriToIdFieldNameMap,
  String? extension,
}) async {
  final Map<String, String> tempConceptMap =
      Map.from(conceptUriToTableNameMap ?? {});
  final Map<String, String> tempIdFieldMap =
      Map.from(conceptUriToIdFieldNameMap ?? {});
  String? tempExtension = extension;

  XDataUploadRequest createDataUploadRequest() {
    final request = XDataUploadRequest();
    request.tableNameToConceptUriMap = Map.fromEntries(
      tempConceptMap.entries.map((e) => MapEntry(e.value, e.key)),
    );
    request.tableNameToIdFieldNameMap = Map.fromEntries(
      tempIdFieldMap.entries.map((e) => MapEntry(tempConceptMap[e.key]!, e.value)),
    );
    request.extension = tempExtension;
    return request;
  }

  final dataUploadRequest = await showDialog<XDataUploadRequest?>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(24),
            backgroundColor: DoorColor.lightEmph,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth =
                    constraints.maxWidth > 1200 ? 1200 : constraints.maxWidth;

                return SizedBox(
                  width: maxWidth,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    children: [
                      // ===== TITLE =====
                      SingleChildScrollView(
                        child:
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: DoorText(
                          AppLocalizations.of(context)!.advancedSettings,
                          DoorTextStyle.center,
                        ),
                      )),

                      const Divider(height: 1),

                      // ===== CONTENT =====
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DoorText(
                                    AppLocalizations.of(context)!.fileExtension,
                                    DoorTextStyle.label,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              DoorMultiDropdown<String>(
                                items: List<DropdownItem<String>>.generate(
                                  ['default', 'csv', 'json', 'xls', 'xlsx', 'xml']
                                      .length,
                                  (index) => DropdownItem<String>(
                                    value: [
                                      'default',
                                      'csv',
                                      'json',
                                      'xls',
                                      'xlsx',
                                      'xml'
                                    ][index],
                                    label: [
                                      AppLocalizations.of(context)!
                                          .defaultValue,
                                      'CSV',
                                      'JSON',
                                      'XLS',
                                      'XLSX',
                                      'XML'
                                    ][index],
                                    selected: (tempExtension == null &&
                                            index == 0) ||
                                        (index > 0 &&
                                            tempExtension ==
                                                [
                                                  'csv',
                                                  'json',
                                                  'xls',
                                                  'xlsx',
                                                  'xml'
                                                ][index - 1]),
                                  ),
                                ),
                                singleSelect: true,
                                onSelectionChange: (selected) {
                                  setState(() {
                                    tempExtension = selected.isNotEmpty &&
                                            selected.first != 'default'
                                        ? selected.first
                                        : null;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DoorText(
                                    AppLocalizations.of(context)!
                                        .tableConceptMapping,
                                    DoorTextStyle.label,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Table(
                                border: TableBorder.all(
                                    color: DoorColor.darkEmph),
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(3),
                                  2: FlexColumnWidth(3),
                                  3: FlexColumnWidth(3),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                        color: DoorColor.lightEmph),
                                    children: [
                                      _headerCell(context,
                                          AppLocalizations.of(context)!
                                              .isIncluded),
                                      _headerCell(context,
                                          AppLocalizations.of(context)!
                                              .conceptUri),
                                      _headerCell(context,
                                          AppLocalizations.of(context)!
                                              .sheetName),
                                      _headerCell(context,
                                          AppLocalizations.of(context)!
                                              .idFieldName),
                                    ],
                                  ),
                                  ...concepts.map((concept) {
                                    final tableName =
                                        tempConceptMap[concept.identifier] ??
                                            concept.name;
                                    final idFieldName =
                                        tempIdFieldMap[concept.identifier] ?? concept.defaultIdentifier?.name ?? "";

                                    return TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Checkbox(
                                            value: tempConceptMap
                                                .containsKey(concept.identifier),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value == true) {
                                                  tempConceptMap[concept.identifier!] =
                                                      tableName;
                                                  tempIdFieldMap[concept.identifier!] =
                                                      idFieldName;
                                                } else {
                                                  tempConceptMap
                                                      .remove(concept.identifier);
                                                  tempIdFieldMap
                                                      .remove(concept.identifier);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: DoorText(
                                              concept.identifier!, DoorTextStyle.norm),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: DoorTextFormField(
                                            enabled: tempConceptMap
                                                .containsKey(concept.identifier),
                                            hintText:
                                                concept.name,
                                            initialValue:
                                                tempConceptMap[concept.identifier],
                                            onChanged: (value) {
                                              setState(() {
                                                tempConceptMap[concept.identifier!] =
                                                    value.isEmpty
                                                        ? concept.name
                                                        : value;
                                              });
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: DoorTextFormField(
                                            enabled: tempConceptMap.containsKey(concept.identifier) 
                                                && (null == concept.defaultIdentifier || concept.defaultIdentifier!.name.isEmpty),
                                            hintText: concept.defaultIdentifier?.name ?? null,
                                            initialValue:
                                                tempIdFieldMap[concept.identifier],
                                            onChanged: (value) {
                                              setState(() {
                                                tempIdFieldMap[concept.identifier!] =
                                                    value.isEmpty
                                                        ? ""
                                                        : value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 1),

                      // ===== ACTIONS =====
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DoorButtonPlain(
                              AppLocalizations.of(context)!.cancel,
                              () => Navigator.of(context).pop(null),
                            ),
                            const SizedBox(width: 12),
                            DoorButtonPlain(
                              AppLocalizations.of(context)!.save,
                              () => Navigator.of(context)
                                  .pop(createDataUploadRequest()),
                              enabled: tempConceptMap.isNotEmpty,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );

  return dataUploadRequest;
}

Widget _headerCell(BuildContext context, String text) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: DoorText(text, DoorTextStyle.label),
  );
}
