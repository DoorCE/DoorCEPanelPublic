import 'dart:typed_data';

import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/icon_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

Future<void> showIconPickerDialog(
  BuildContext context,
  List<(XIconData, Uint8List?)> iconList,
  void Function({
    required XIconData icon,
    Uint8List? iconBytes,
  }) onIconPicked,
) async {
  final TextEditingController nameController = TextEditingController();
  Uint8List? selectedFileBytes;
  String view = 'list';
  bool isNameValid = true;

  final existingNames = iconList.map((e) => e.$1.iconName?.toLowerCase()).toSet();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        Widget? preview;
        if (view == 'custom' && selectedFileBytes != null) {
            preview = Image.memory(selectedFileBytes!, height: 48);
        }
        final showError = !isNameValid && view == 'custom';
        
        return AlertDialog(
          backgroundColor: DoorColor.lightBlue,
          title: SingleChildScrollView(child: DoorText(AppLocalizations.of(context)!.selectIcon, DoorTextStyle.center)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DoorButtonCard(AppLocalizations.of(context)!.fromList, () {
                      setState(() {
                        view = 'list';
                      });
                    }, 'left', view == 'list'),
                    DoorButtonCard(AppLocalizations.of(context)!.own, () {
                      setState(() {
                        view = 'custom';
                        isNameValid = true;
                      });
                    }, 'right', view == 'custom'),
                  ],
                ),
                const SizedBox(height: 12),

                if (view == 'list') ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: iconList.map((option) {
                      return DoorSimpleButtonImageFile(
                        option.$1.iconName,
                        option.$2!,
                        () {
                          onIconPicked(
                            icon: option.$1,
                            iconBytes: option.$2,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                ],

                if (view == 'custom') ...[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.iconName,
                      errorText: showError ? AppLocalizations.of(context)!.wrongName : null,
                    ),
                    onChanged: (_) {
                      final inputName = nameController.text.trim().toLowerCase();
                      setState(() {
                        isNameValid = !existingNames.contains(inputName) && inputName.isNotEmpty;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DoorButtonPlain(AppLocalizations.of(context)!.selectFile, () async {
                    final result = await FilePicker.platform.pickFiles(type: FileType.image);
                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        selectedFileBytes = result.files.single.bytes;
                      });
                    }
                  }),
                  const SizedBox(height: 10),
                  if (selectedFileBytes != null && preview != null)
                    ...[
                    DoorText(AppLocalizations.of(context)!.preview, DoorTextStyle.center),
                    const SizedBox(height: 8),
                    preview,
                ],
              ],]
            ),
          ),
          actions: [
            DoorButtonPlain(AppLocalizations.of(context)!.cancel, () {
              Navigator.of(context).pop();
            }),
            if (view == 'custom')
              DoorButtonPlain(AppLocalizations.of(context)!.add, () {
                final trimmedName = nameController.text.trim();
                if (trimmedName.isNotEmpty &&
                    !existingNames.contains(trimmedName.toLowerCase())) {
                  XIconData icon = XIconData();
                  icon.iconName = trimmedName; icon.iconUri = null;
                  onIconPicked(icon: icon, iconBytes: selectedFileBytes);
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    isNameValid = false;
                  });
                }
              }),
          ],
        );
      });
    },
  );
}
