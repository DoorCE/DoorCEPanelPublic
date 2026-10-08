import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeployApp {
  Future<void> deployAppSelected(BuildContext context, XApp app);
}

class UCDeployApp extends UCShowSchemaManagement implements IUCDeployApp {
  
  UCDeployApp(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  Future<void> deployAppSelected(BuildContext context, XApp app) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await appManagement.deployApp(app.identifier);
      int code = response.statusCode;

      if (200 == code) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.appDeployStarted);
      } else if (403 == code)
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      else
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.appDeployError);
      WaitMessage().dismiss();
    });
  }
}