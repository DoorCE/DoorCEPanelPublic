import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class DialogResult {
  final int selection;
  final bool checked;

  const DialogResult({
    required this.selection,
    this.checked = false,
  });
}

Future<DialogResult> showSelectionDialog(
  BuildContext context,
  String titleText,
  String contentText,
  List<String> selections, {
  bool showCheckbox = false,
  String checkboxLabel = '',
  bool initialCheckboxValue = false,
}) async {
  final result = await showDialog<DialogResult>(
    context: context,
    builder: (BuildContext context) {
      bool isChecked = initialCheckboxValue;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: DoorColor.lightBlue,
            title: SingleChildScrollView(
              child: DoorText(titleText, DoorTextStyle.subtitle),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  child: DoorText(contentText, DoorTextStyle.center),
                ),

                if (showCheckbox) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      activeColor: DoorColor.darkEmph,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: DoorText(checkboxLabel, DoorTextStyle.norm),
                      ),
                    ),
                  ],
                ),
              ],
              ]
            ),
            actions: selections.asMap().entries.map((entry) {
              return DoorButtonPlain(
                entry.value,
                () {
                  Navigator.of(context).pop(
                    DialogResult(
                      selection: entry.key,
                      checked: isChecked,
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      );
    },
  );

  return result ??
      const DialogResult(
        selection: 1,
        checked: false,
      );
}

Future<DialogResult> showDeleteDialog(BuildContext context, String itemName, [bool showCheckbox = false, bool isIndependent = false]) async{
  List<String> items = [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no];
  String checkboxLabel = !isIndependent 
    ? AppLocalizations.of(context)!.unpublish 
    : "${AppLocalizations.of(context)!.unpublish} (${AppLocalizations.of(context)!.warningIndependentDataset})";

  return await showSelectionDialog(context, itemName, AppLocalizations.of(context)!.toDelete, items,
    showCheckbox: showCheckbox, checkboxLabel: checkboxLabel);
}

Future<int> showUnpublishDialog(BuildContext context, String itemName, [bool isIndependent = false]) async{
  List<String> items = [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no];
  String titleText = isIndependent ? "${AppLocalizations.of(context)!.unpublish} $itemName?" : itemName;
  String contentText = isIndependent ? AppLocalizations.of(context)!.warningIndependentDataset : AppLocalizations.of(context)!.toUnpublish;
  DialogResult response = await showSelectionDialog(context, titleText, contentText, items);
  return response.selection;
}

Future<int> showDeleteConceptDialog(BuildContext context, String itemName) async {
  List<String> items = [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no];
  DialogResult response = await showSelectionDialog(context, "${AppLocalizations.of(context)!.delete} $itemName?", AppLocalizations.of(context)!.deleteConceptWarning, items);
  return response.selection;
}

Future<int> showAdvancedModeDialog(BuildContext context) async {
  List<String> items = [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no];
  DialogResult response = await showSelectionDialog(context, "${AppLocalizations.of(context)!.activateAdvancedScenarioEditing}?", AppLocalizations.of(context)!.cannotRevertWarning, items);
  return response.selection;
}

Future<int> showPublishDialog(BuildContext context, String itemName) async {
  List<String> items = [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no];
  DialogResult response = await showSelectionDialog(context, itemName, AppLocalizations.of(context)!.toPublish, items);
  return response.selection;
}

Future<int> showUpdateDialog(BuildContext context, String itemName) async {
  List<String> items = [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no];
  DialogResult response = await showSelectionDialog(context, itemName, AppLocalizations.of(context)!.toUpdate, items);
  return response.selection;
}