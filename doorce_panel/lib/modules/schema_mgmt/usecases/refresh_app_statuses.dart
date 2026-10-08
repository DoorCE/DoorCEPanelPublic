import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IUCRefreshAppStatuses {
  Future<void> refreshApps(BuildContext context);
}

class UCRefreshAppStatuses extends UCShowSchemaManagement implements IUCRefreshAppStatuses {
  
  UCRefreshAppStatuses(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  Future<void> refreshApps(BuildContext context) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XApp> apps = await appManagement.getAppList();
      pSchemaManagementWindow.refreshResources(apps);
      SnackMessage().show(context, false, text: AppLocalizations.of(context)!.appStatusesRefreshed);
      WaitMessage().dismiss();
    });
  }
}