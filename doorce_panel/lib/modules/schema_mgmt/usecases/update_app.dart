import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

abstract interface class IUCUpdateApp {
   updateAppFlagsSelected(BuildContext context, String identifier, bool isEnabled, bool isVisible);
}

class UCUpdateApp extends UCShowSchemaManagement implements IUCUpdateApp {
  
  UCUpdateApp(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  updateAppFlagsSelected(BuildContext context, String identifier, bool isEnabled, bool isVisible) async {
    if (0 != await showUpdateDialog(context, identifier))
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XApp app = await appManagement.getApp(identifier);
      Logger.root.config("Updating app flags for ${app.identifier}: ${app.toJson()}");
      app.isEnabled = isEnabled;
      app.isVisible = isVisible;
      Response response = await appManagement.upsertApp(app, [], null);
      Logger.root.config("Update app flags response: ${response.body}");
      int code = response.statusCode;

      if (code == 200) {
        List<XApp> apps = await appManagement.getAppList();
        pSchemaManagementWindow.refreshResources(apps);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.appUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.appError);}
      WaitMessage().dismiss();
    });
  }
}