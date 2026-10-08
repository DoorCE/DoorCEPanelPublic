import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteSchema {
  deleteDataSchemaSelected(BuildContext context, String identiier);
}

class UCDeleteSchema extends UCShowSchemaManagement implements IUCDeleteSchema {
  
  UCDeleteSchema(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  deleteDataSchemaSelected(BuildContext context, String identifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await schemaManagement.deleteDataSchema(identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XDataSchema> schemas = await schemaManagement.getDataSchemaList(null);
        pSchemaManagementWindow.refreshResources(schemas);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.schemaDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.schemaDeleteError);}
      WaitMessage().dismiss();
    });
  }
}