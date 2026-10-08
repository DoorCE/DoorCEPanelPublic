import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Future<String?> showChoiceDialog(
  BuildContext context,
  String selectText,
  String applyText,
  Map<String, String> uriTitleMap,
) async {
  String idSelected = "";

  await showDialog(
    context: context,
    builder: (context) {
      
      return StatefulBuilder(
        builder: (context, setState){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DoorText(
                  selectText,
                  DoorTextStyle.titleBlack,
                ),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.3,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: uriTitleMap.length,
                  itemBuilder: (context, index) {
                    final uri = uriTitleMap.keys.toList()[index];
                    final title = uriTitleMap[uri]!;
                    final isSelected = idSelected == uri;
                    return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child:GestureDetector(
                      onTap: () {
                        setState(() => idSelected = uri);
                      },
                      child: Container(
                        //width: 32,
                        //height: 32,
                        decoration: BoxDecoration(
                          color: isSelected ? DoorColor.lightBlue : DoorColor.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: isSelected ? DoorColor.darkEmph : Colors.transparent,
                              width: 2,
                            ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible( child:
                            Image.asset("images/dataset.png",
                              height: 32,
                              fit: BoxFit.contain)),
                            const SizedBox(height: 8),
                            Flexible(
                              child:
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? DoorColor.black : DoorColor.greyBlur,
                              ),
                            ),)
                          ],
                        ),
                      ),
                    ));
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        DoorButtonPlain(
                AppLocalizations.of(context)!.cancel,
                () {
                  setState(() => idSelected = "");
                  Navigator.of(context).pop();
                },
              ),
              DoorButtonPlain(
                applyText,
                () { 
                  Navigator.of(context).pop();
                }
              )
      ],
      );
        }
      );

    },
  );
  return idSelected;
}