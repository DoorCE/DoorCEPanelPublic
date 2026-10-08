import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteSchemaSeries {
  deleteSchemaSeriesSelected(BuildContext context, String identiier);
}

class UCDeleteSchemaSeries extends UCShowSchemaManagement implements IUCDeleteSchemaSeries {
  
  UCDeleteSchemaSeries(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  deleteSchemaSeriesSelected(BuildContext context, String identifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await schemaManagement.deleteSchemaSeries(identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XSchemaSeries> series = await schemaManagement.getSchemaSeriesList("");
        pSchemaManagementWindow.refreshResources(series);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.schemaSeriesDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.schemaSeriesDeleteError);}
      WaitMessage().dismiss();
    });
  }
}