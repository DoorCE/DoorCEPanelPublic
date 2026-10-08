import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteApp {
  void deleteAppSelected(BuildContext context, XApp app);
}

class UCDeleteApp extends UCShowSchemaManagement implements IUCDeleteApp {
  
  UCDeleteApp(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  void deleteAppSelected(BuildContext context, XApp app) async {
    DialogResult response = await showDeleteDialog(context, app.identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await appManagement.deleteApp(app.identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XApp> apps = await appManagement.getAppList();
        pSchemaManagementWindow.refreshResources(apps);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.appDeleted);
      } else if (403 == code)
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      else
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.appDeleteError);
      WaitMessage().dismiss();
    });
  }
}